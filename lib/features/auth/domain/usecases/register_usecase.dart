import 'package:ecommerce_app/features/auth/domain/entity/user_entity.dart';
import 'package:ecommerce_app/features/auth/domain/repository/auth_repo.dart';
import 'package:injectable/injectable.dart';
@injectable
class RegisterUsecase {
  final AuthRepo authRepo;
  RegisterUsecase(this.authRepo);
  Future<UserEntity> call(UserEntity user)async =>await authRepo.register(user);
}