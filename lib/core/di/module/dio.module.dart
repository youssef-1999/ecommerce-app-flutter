import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:ecommerce_app/core/di/di.dart';
import 'package:ecommerce_app/core/network/consts.dart';
import 'package:ecommerce_app/core/resources/constants_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@module
abstract class DioModule {
  @singleton
  Dio get dio {
    final dio = Dio(BaseOptions(baseUrl: AppConsts.baseUrl));

    // Add the saved token to every request. This runs each time a request
    // is sent, so it always uses the latest token (after login/logout).
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token =
              getIt<SharedPreferences>().getString(AppConstants.token);
          if (token != null && token.isNotEmpty) {
            options.headers['token'] = token;
          }
          handler.next(options);
        },
      ),
    );

    // Only log in debug mode, so release builds don't print user data.
    if (kDebugMode) {
      dio.interceptors.add(LogDioInterceptor());
    }
    return dio;
  }
}

class LogDioInterceptor extends Interceptor {
  /// debugPrint always shows in the Debug Console (unlike dart:developer's
  /// log(), which only shows when a debugger is attached). It also splits
  /// long text so big JSON responses don't get cut off.
  void _print(String message) => debugPrint(message);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Remember when the request started, so we can show how long it took.
    options.extra['startTime'] = DateTime.now().millisecondsSinceEpoch;

    _print(
      '┌── REQUEST ─────────────────────────────\n'
      '│ ${options.method} ${options.uri}\n'
      '│ Headers: ${_pretty(_hideToken(options.headers))}\n'
      '│ Query: ${_pretty(options.queryParameters)}\n'
      '│ Body: ${_pretty(options.data)}\n'
      '└────────────────────────────────────────',
    );
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final options = response.requestOptions;
    _print(
      '┌── RESPONSE ────────────────────────────\n'
      '│ ${response.statusCode} ${options.method} ${options.uri}'
      ' (${_duration(options)})\n'
      '│ Data: ${_pretty(response.data)}\n'
      '└────────────────────────────────────────',
    );
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final options = err.requestOptions;
    _print(
      '┌── ERROR ───────────────────────────────\n'
      '│ ${err.response?.statusCode ?? '-'} ${options.method} ${options.uri}'
      ' (${_duration(options)})\n'
      '│ Type: ${err.type}\n'
      '│ Message: ${err.message}\n'
      '│ Data: ${_pretty(err.response?.data)}\n'
      '│ Cause: ${err.error}\n'
      '└────────────────────────────────────────',
    );
    super.onError(err, handler);
  }

  /// How many milliseconds passed since the request started.
  String _duration(RequestOptions options) {
    final start = options.extra['startTime'] as int?;
    if (start == null) return '? ms';
    return '${DateTime.now().millisecondsSinceEpoch - start} ms';
  }

  /// Don't print the full auth token in the logs.
  Map<String, dynamic> _hideToken(Map<String, dynamic> headers) {
    final copy = Map<String, dynamic>.from(headers);
    for (final key in ['Authorization', 'authorization', 'token']) {
      if (copy.containsKey(key)) copy[key] = '***';
    }
    return copy;
  }

  /// Turns maps/lists into indented JSON so they're easy to read.
  String _pretty(dynamic data) {
    if (data == null) return 'null';
    if (data is FormData) {
      return _pretty({
        'fields': {for (final f in data.fields) f.key: f.value},
        'files': [for (final f in data.files) f.key],
      });
    }
    try {
      return const JsonEncoder.withIndent('  ').convert(data);
    } catch (_) {
      return data.toString();
    }
  }
}
