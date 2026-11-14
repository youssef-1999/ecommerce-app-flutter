import 'package:json_annotation/json_annotation.dart';

part 'add_to_cart_response_model.g.dart';

/// POST /cart is DIFFERENT from the other cart endpoints:
/// inside data.products, "product" is only an id string, not an object.
/// So we can NOT reuse CartResponseModel here (parsing would crash).
/// We only read the fields the app needs.
@JsonSerializable()
class AddToCartResponseModel {
  @JsonKey(name: 'status')
  String? status;
  @JsonKey(name: 'message')
  String? message; // "Product added successfully to your cart"
  @JsonKey(name: 'numOfCartItems')
  int? numOfCartItems;
  @JsonKey(name: 'cartId')
  String? cartId;

  AddToCartResponseModel({
    this.status,
    this.message,
    this.numOfCartItems,
    this.cartId,
  });

  factory AddToCartResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AddToCartResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$AddToCartResponseModelToJson(this);
}
