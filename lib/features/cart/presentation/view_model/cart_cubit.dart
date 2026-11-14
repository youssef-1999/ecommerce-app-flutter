import 'package:ecommerce_app/core/network/error/error_model.dart';
import 'package:ecommerce_app/features/cart/domain/entity/cart_entity.dart';
import 'package:ecommerce_app/features/cart/domain/usecases/add_to_cart_usecase.dart';
import 'package:ecommerce_app/features/cart/domain/usecases/clear_cart_usecase.dart';
import 'package:ecommerce_app/features/cart/domain/usecases/get_cart_usecase.dart';
import 'package:ecommerce_app/features/cart/domain/usecases/remove_cart_item_usecase.dart';
import 'package:ecommerce_app/features/cart/domain/usecases/update_cart_item_count_usecase.dart';
import 'package:ecommerce_app/features/cart/presentation/view_model/cart_status.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class CartCubit extends Cubit<CartStatus> {
  final GetCartUsecase getCartUsecase;
  final AddToCartUsecase addToCartUsecase;
  final UpdateCartItemCountUsecase updateCartItemCountUsecase;
  final RemoveCartItemUsecase removeCartItemUsecase;
  final ClearCartUsecase clearCartUsecase;

  CartCubit({
    required this.getCartUsecase,
    required this.addToCartUsecase,
    required this.updateCartItemCountUsecase,
    required this.removeCartItemUsecase,
    required this.clearCartUsecase,
  }) : super(const CartStatus());

  /// Loads the cart when the cart screen opens.
  Future<void> getCart() async {
    emit(state.copyWith(isLoading: true));
    try {
      final cart = await getCartUsecase();
      emit(state.copyWith(
        isLoading: false,
        cart: cart,
        cartItemsCount: cart.itemsCount,
      ));
    } on ErrorModel catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.message));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  /// Called from the "Add to cart" button on a product.
  Future<void> addToCart(String productId) async {
    emit(state.copyWith(updatingProductId: productId));
    try {
      final count = await addToCartUsecase(productId);
      emit(state.copyWith(cartItemsCount: count));
    } on ErrorModel catch (e) {
      emit(state.copyWith(errorMessage: e.message));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  /// "+" button.
  Future<void> increase(CartItemEntity item) async {
    if (!item.canIncrease) return; // no more in stock
    await _updateCount(item.productId, item.count + 1);
  }

  /// "-" button. Going below 1 removes the item.
  Future<void> decrease(CartItemEntity item) async {
    if (item.count <= 1) return removeItem(item.productId);
    await _updateCount(item.productId, item.count - 1);
  }

  Future<void> removeItem(String productId) async {
    await _runOnItem(productId, () => removeCartItemUsecase(productId));
  }

  Future<void> clearCart() async {
    emit(state.copyWith(isLoading: true));
    try {
      await clearCartUsecase();
      emit(const CartStatus()); // back to an empty cart
    } on ErrorModel catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.message));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> _updateCount(String productId, int count) async {
    await _runOnItem(
        productId, () => updateCartItemCountUsecase(productId, count));
  }

  /// Shared code for + / - / delete: show a spinner on that one item,
  /// call the server, then show the new cart it sends back.
  Future<void> _runOnItem(
      String productId, Future<CartEntity> Function() action) async {
    emit(state.copyWith(updatingProductId: productId));
    try {
      final cart = await action();
      emit(state.copyWith(cart: cart, cartItemsCount: cart.itemsCount));
    } on ErrorModel catch (e) {
      emit(state.copyWith(errorMessage: e.message));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }
}
