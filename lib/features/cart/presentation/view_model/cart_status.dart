import 'package:ecommerce_app/features/cart/domain/entity/cart_entity.dart';
import 'package:equatable/equatable.dart';

class CartStatus extends Equatable {
  final CartEntity cart;
  final int cartItemsCount; // number shown on the cart badge
  final bool isLoading; // loading the whole cart
  final String? updatingProductId; // the one item showing a small spinner (+ / - / delete)
  final String? errorMessage;

  const CartStatus({
    this.cart = const CartEntity.empty(),
    this.cartItemsCount = 0,
    this.isLoading = false,
    this.updatingProductId,
    this.errorMessage,
  });

  CartStatus copyWith({
    CartEntity? cart,
    int? cartItemsCount,
    bool? isLoading,
    String? updatingProductId,
    String? errorMessage,
  }) {
    return CartStatus(
      cart: cart ?? this.cart,
      cartItemsCount: cartItemsCount ?? this.cartItemsCount,
      isLoading: isLoading ?? this.isLoading,
      // NOT "?? this.x" on purpose: every new state clears these
      // unless you pass a new value.
      updatingProductId: updatingProductId,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [cart, cartItemsCount, isLoading, updatingProductId, errorMessage];
}
