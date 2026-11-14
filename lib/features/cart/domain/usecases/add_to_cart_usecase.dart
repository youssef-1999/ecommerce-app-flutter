import 'package:ecommerce_app/features/cart/domain/repository/cart_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class AddToCartUsecase {
  final CartRepo _cartRepo;

  AddToCartUsecase({required CartRepo cartRepo}) : _cartRepo = cartRepo;

  /// Returns the new number of items in the cart.
  Future<int> call(String productId) async =>
      await _cartRepo.addToCart(productId);
}
