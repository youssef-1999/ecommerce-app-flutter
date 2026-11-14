import 'package:ecommerce_app/features/cart/domain/entity/cart_entity.dart';

abstract class CartRepo {
  Future<CartEntity> getCart();

  /// Returns the new number of items in the cart (for the badge).
  Future<int> addToCart(String productId);

  Future<CartEntity> updateItemCount(String productId, int count);

  Future<CartEntity> removeItem(String productId);

  Future<void> clearCart();
}
