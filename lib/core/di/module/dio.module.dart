import 'package:dio/dio.dart';
import 'package:ecommerce_app/core/network/consts.dart';
import 'package:injectable/injectable.dart';
@module
abstract class DioModule {
  @singleton
  Dio get dio=>Dio(
    BaseOptions(
      baseUrl: AppConsts.baseUrl,
    ),
  );
}