import 'package:ecommerce_app/features/cart/domain/repository/cart_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class ClearCartUsecase {
  final CartRepo _cartRepo;

  ClearCartUsecase({required CartRepo cartRepo}) : _cartRepo = cartRepo;

  Future<void> call() async => await _cartRepo.clearCart();
}
