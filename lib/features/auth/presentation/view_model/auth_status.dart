import 'package:ecommerce_app/features/auth/domain/entity/user_entity.dart';
import 'package:equatable/equatable.dart';

class AuthStatus extends Equatable {
  final String? errorMessage;
  final UserEntity? user;
  final bool isLoading;
  const AuthStatus({this.errorMessage, this.user, this.isLoading = false});
  @override
  List<Object?> get props => [errorMessage, user, isLoading];
  AuthStatus copyWith({
    String? errorMessage,
    UserEntity? user,
    bool? isLoading,
  }) {
    return AuthStatus(
      errorMessage: errorMessage ?? this.errorMessage,
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
    );
  }

}

// class AuthInitialStatus extends AuthStatus {}

// class AuthLoadingStatus extends AuthStatus {}

// class LoginSuccessStatus extends AuthStatus {
//   final UserEntity userEntity;
//   LoginSuccessStatus({required this.userEntity});
// }

// class LoginErrorStatus extends AuthStatus {
//   final String message;
//   LoginErrorStatus({required this.message});
// }
