import 'package:ecommerce_app/features/cart/data/model/cart_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cart_response_model.g.dart';

/// Used by GET /cart, PUT /cart/{id} and DELETE /cart/{id}.
/// All three return the cart with FULL product objects inside.
@JsonSerializable()
class CartResponseModel {
  @JsonKey(name: 'status')
  String? status;
  @JsonKey(name: 'numOfCartItems')
  int? numOfCartItems;
  @JsonKey(name: 'cartId')
  String? cartId;
  @JsonKey(name: 'data')
  CartModel? data;

  CartResponseModel({this.status, this.numOfCartItems, this.cartId, this.data});

  factory CartResponseModel.fromJson(Map<String, dynamic> json) =>
      _$CartResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$CartResponseModelToJson(this);
}
