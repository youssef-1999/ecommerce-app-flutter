import 'package:dio/dio.dart';
import 'package:ecommerce_app/core/network/error/error_model.dart';
import 'package:ecommerce_app/features/cart/data/data_source/cart_data_source.dart';
import 'package:ecommerce_app/features/cart/data/model/request_model/add_to_cart_request_model.dart';
import 'package:ecommerce_app/features/cart/data/model/request_model/update_cart_item_request_model.dart';
import 'package:ecommerce_app/features/cart/data/model/response_model/cart_response_model.dart';
import 'package:ecommerce_app/features/cart/domain/entity/cart_entity.dart';
import 'package:ecommerce_app/features/cart/domain/repository/cart_repo.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: CartRepo)
class CartRepoImpl implements CartRepo {
  final CartDataSource _cartDataSource;
  CartRepoImpl(this._cartDataSource);

  @override
  Future<CartEntity> getCart() async {
    try {
      final response = await _cartDataSource.getCart();
      return _toCartEntity(response);
    } on DioException catch (e) {
      // A user who never added anything has no cart, so the server sends 404.
      // For the UI that is not an error, it is just an empty cart.
      if (e.response?.statusCode == 404) return const CartEntity.empty();
      throw ErrorModel.fromDioException(e);
    }
  }

  @override
  Future<int> addToCart(String productId) async {
    try {
      final response = await _cartDataSource
          .addToCart(AddToCartRequestModel(productId: productId));
      return response.numOfCartItems ?? 0;
    } on DioException catch (e) {
      throw ErrorModel.fromDioException(e);
    }
  }

  @override
  Future<CartEntity> updateItemCount(String productId, int count) async {
    try {
      final response = await _cartDataSource.updateItemCount(
        productId,
        UpdateCartItemRequestModel.fromCount(count),
      );
      return _toCartEntity(response);
    } on DioException catch (e) {
      throw ErrorModel.fromDioException(e);
    }
  }

  @override
  Future<CartEntity> removeItem(String productId) async {
    try {
      final response = await _cartDataSource.removeItem(productId);
      return _toCartEntity(response);
    } on DioException catch (e) {
      throw ErrorModel.fromDioException(e);
    }
  }

  @override
  Future<void> clearCart() async {
    try {
      await _cartDataSource.clearCart();
    } on DioException catch (e) {
      throw ErrorModel.fromDioException(e);
    }
  }

  /// No "data" in the response -> treat it as an empty cart.
  CartEntity _toCartEntity(CartResponseModel response) =>
      response.data?.toDomain() ?? const CartEntity.empty();
}
