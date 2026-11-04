import 'package:ecommerce_app/features/auth/data/api/auth_api.dart';
import 'package:ecommerce_app/features/auth/data/model/request_model/login_request_model.dart';
import 'package:ecommerce_app/features/auth/data/model/response_model/login_response_model.dart';
import 'package:injectable/injectable.dart';

abstract class AuthDataSource {

  Future<LoginResponseModel> login(LoginRequestModel requestModel);
}
@Injectable(as: AuthDataSource)
class AuthRemoteDataSource implements AuthDataSource {
  final AuthApi _authApi;
  AuthRemoteDataSource(this._authApi);
  @override
  Future<LoginResponseModel> login(LoginRequestModel requestModel)async=>await  _authApi.login(requestModel);
  
}