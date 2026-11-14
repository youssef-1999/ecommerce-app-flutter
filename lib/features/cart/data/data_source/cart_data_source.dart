import 'package:ecommerce_app/features/cart/data/api/cart_api.dart';
import 'package:ecommerce_app/features/cart/data/model/request_model/add_to_cart_request_model.dart';
import 'package:ecommerce_app/features/cart/data/model/request_model/update_cart_item_request_model.dart';
import 'package:ecommerce_app/features/cart/data/model/response_model/add_to_cart_response_model.dart';
import 'package:ecommerce_app/features/cart/data/model/response_model/cart_response_model.dart';
import 'package:injectable/injectable.dart';

abstract class CartDataSource {
  Future<CartResponseModel> getCart();
  Future<AddToCartResponseModel> addToCart(AddToCartRequestModel requestModel);
  Future<CartResponseModel> updateItemCount(
      String productId, UpdateCartItemRequestModel requestModel);
  Future<CartResponseModel> removeItem(String productId);
  Future<void> clearCart();
}

@Injectable(as: CartDataSource)
class CartRemoteDataSource implements CartDataSource {
  final CartApi _cartApi;
  CartRemoteDataSource(this._cartApi);

  @override
  Future<CartResponseModel> getCart() async => await _cartApi.getCart();

  @override
  Future<AddToCartResponseModel> addToCart(
          AddToCartRequestModel requestModel) async =>
      await _cartApi.addToCart(requestModel);

  @override
  Future<CartResponseModel> updateItemCount(
          String productId, UpdateCartItemRequestModel requestModel) async =>
      await _cartApi.updateItemCount(productId, requestModel);

  @override
  Future<CartResponseModel> removeItem(String productId) async =>
      await _cartApi.removeItem(productId);

  @override
  Future<void> clearCart() async => await _cartApi.clearCart();
}
