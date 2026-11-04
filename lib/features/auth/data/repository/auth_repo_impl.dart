// here i will decide which one to use remote or local 

import 'package:dio/dio.dart';
import 'package:ecommerce_app/core/network/error/error_model.dart';
import 'package:ecommerce_app/features/auth/data/data_source/auth_data_source.dart';
import 'package:ecommerce_app/features/auth/data/model/request_model/login_request_model.dart';
import 'package:ecommerce_app/features/auth/data/model/response_model/login_response_model.dart';
import 'package:ecommerce_app/features/auth/domain/entity/user_entity.dart';
import 'package:ecommerce_app/features/auth/domain/repository/auth_repo.dart';
import 'package:injectable/injectable.dart';
@Injectable(as: AuthRepo)
class AuthRepoImpl implements AuthRepo {
  final AuthDataSource _authDataSource;
  AuthRepoImpl(this._authDataSource);
  @override
  Future<UserEntity> login(UserEntity user)async {
    // here i will decide which one to use remote or local 
    try {
      LoginResponseModel response = await _authDataSource.login(LoginRequestModel.fromDomain(user));
      final loggedInUser = response.user;
      if (loggedInUser == null) {
        throw AuthError(errorMessage: response.message ?? 'Login failed');
      }
      return loggedInUser.toDomain();
    } on DioException catch (e) {
      throw ErrorModel.fromDioException(e);
    }
  }

}