import 'package:ecommerce_app/features/auth/domain/repository/auth_repo.dart';
import 'package:injectable/injectable.dart';

@singleton
class CheckLoggedinUsecase {
  final AuthRepo authRepo;
  CheckLoggedinUsecase({required this.authRepo});

  bool call() => authRepo.checkLoggedIn();
}
