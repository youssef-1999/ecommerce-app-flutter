// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_to_cart_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddToCartResponseModel _$AddToCartResponseModelFromJson(
        Map<String, dynamic> json) =>
    AddToCartResponseModel(
      status: json['status'] as String?,
      message: json['message'] as String?,
      numOfCartItems: (json['numOfCartItems'] as num?)?.toInt(),
      cartId: json['cartId'] as String?,
    );

Map<String, dynamic> _$AddToCartResponseModelToJson(
        AddToCartResponseModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'numOfCartItems': instance.numOfCartItems,
      'cartId': instance.cartId,
    };
