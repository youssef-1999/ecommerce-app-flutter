// here i will decide which one to use remote or local 

import 'package:dio/dio.dart';
import 'package:ecommerce_app/core/network/error/error_model.dart';
import 'package:ecommerce_app/core/resources/constants_manager.dart';
import 'package:ecommerce_app/features/auth/data/data_source/auth_data_source.dart';
import 'package:ecommerce_app/features/auth/data/model/request_model/login_request_model.dart';
import 'package:ecommerce_app/features/auth/data/model/request_model/register_request_model.dart';
import 'package:ecommerce_app/features/auth/data/model/response_model/login_response_model.dart';
import 'package:ecommerce_app/features/auth/data/model/response_model/register_response_model.dart';
import 'package:ecommerce_app/features/auth/domain/entity/user_entity.dart';
import 'package:ecommerce_app/features/auth/domain/repository/auth_repo.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
@Injectable(as: AuthRepo)
class AuthRepoImpl implements AuthRepo {
  final AuthDataSource _authDataSource;
  final SharedPreferences _sharedPreferences;
  AuthRepoImpl(this._authDataSource, this._sharedPreferences);
  @override
  Future<UserEntity> login(UserEntity user)async {
    // here i will decide which one to use remote or local 
    try {
      LoginResponseModel response = await _authDataSource.login(LoginRequestModel.fromDomain(user));
      final loggedInUser = response.user;
      if (loggedInUser == null) {
        throw AuthError(errorMessage: response.message ?? 'Login failed');
      }
      _sharedPreferences.setString(AppConstants.token, response.token ?? '');
      return loggedInUser.toDomain();
    } on DioException catch (e) {
      throw ErrorModel.fromDioException(e);
    }
  }

  @override
  Future<UserEntity>register(UserEntity user)async {
    try {
      RegisterResponseModel response=await _authDataSource.register(RegisterRequestModel.fromDomain(user));
      final registeredUser = response.user;
      if (registeredUser == null) {
        throw AuthError(errorMessage: response.message ?? 'Registration failed');
      }
      _sharedPreferences.setString(AppConstants.token, response.token ?? '');
      return registeredUser.toDomain();
    } on DioException catch (e) {
      throw ErrorModel.fromDioException(e);
    }
  }

  @override
  bool checkLoggedIn() {
    final token = _sharedPreferences.getString(AppConstants.token);
    return token != null;
  }

}