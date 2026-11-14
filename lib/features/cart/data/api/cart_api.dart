import 'package:dio/dio.dart';
import 'package:ecommerce_app/core/network/endpoints.dart';
import 'package:ecommerce_app/features/cart/data/model/request_model/add_to_cart_request_model.dart';
import 'package:ecommerce_app/features/cart/data/model/request_model/update_cart_item_request_model.dart';
import 'package:ecommerce_app/features/cart/data/model/response_model/add_to_cart_response_model.dart';
import 'package:ecommerce_app/features/cart/data/model/response_model/cart_response_model.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'cart_api.g.dart';

// No need to add the token here: the Dio interceptor in dio.module.dart
// adds the "token" header to every request automatically.
@injectable
@RestApi()
abstract class CartApi {
  @factoryMethod
  factory CartApi(Dio dio) = _CartApi;

  @GET(Endpoints.cart)
  Future<CartResponseModel> getCart();

  @POST(Endpoints.cart)
  Future<AddToCartResponseModel> addToCart(@Body() AddToCartRequestModel body);

  // {id} is the PRODUCT id, not the cart item id
  @PUT(Endpoints.cartItem)
  Future<CartResponseModel> updateItemCount(
    @Path('id') String productId,
    @Body() UpdateCartItemRequestModel body,
  );

  @DELETE(Endpoints.cartItem)
  Future<CartResponseModel> removeItem(@Path('id') String productId);

  // Server answers { "message": "success" } -> nothing useful to parse
  @DELETE(Endpoints.cart)
  Future<void> clearCart();
}
