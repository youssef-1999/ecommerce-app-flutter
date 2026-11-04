import 'package:ecommerce_app/core/network/error/error_model.dart';
import 'package:ecommerce_app/features/auth/domain/entity/user_entity.dart';
import 'package:ecommerce_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:ecommerce_app/features/auth/presentation/view_model/auth_status.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class AuthCubit extends Cubit<AuthStatus> {
  final LoginUsecase loginUseCase;
  AuthCubit({required this.loginUseCase}) : super(AuthStatus());

  Future<void> login(String email, String password) async {
    emit(AuthStatus(isLoading: true));
    try {
      final user = await loginUseCase(UserEntity(email: email, password: password));
      if (user != null) {
        emit(AuthStatus(user: user));
      } else {
        emit(AuthStatus(errorMessage: 'Login failed'));
      }
    } on ErrorModel catch (e) {
      emit(AuthStatus(errorMessage: e.message));
    } catch (e) {
      emit(AuthStatus(errorMessage: e.toString()));
    }
  }
}
