import 'package:ecommerce_app/features/cart/domain/entity/cart_entity.dart';
import 'package:ecommerce_app/features/products/data/model/product_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cart_model.g.dart';

/// The "data" object inside every cart response.
@JsonSerializable()
class CartModel {
  @JsonKey(name: '_id')
  String? id;
  @JsonKey(name: 'cartOwner')
  String? cartOwner;
  @JsonKey(name: 'products')
  List<CartItemModel>? products;
  @JsonKey(name: 'totalCartPrice')
  num? totalCartPrice;

  CartModel({this.id, this.cartOwner, this.products, this.totalCartPrice});

  factory CartModel.fromJson(Map<String, dynamic> json) =>
      _$CartModelFromJson(json);

  Map<String, dynamic> toJson() => _$CartModelToJson(this);

  CartEntity toDomain() => CartEntity(
        id: id ?? '',
        items: (products ?? []).map((item) => item.toDomain()).toList(),
        totalPrice: (totalCartPrice ?? 0).toDouble(),
      );
}

/// One item in "products": { count, _id, product: {...}, price }
@JsonSerializable()
class CartItemModel {
  @JsonKey(name: '_id')
  String? id;
  @JsonKey(name: 'count')
  int? count;
  @JsonKey(name: 'price')
  num? price;
  // The product inside a cart item has the same shape as a normal product
  // (just fewer fields) -> reuse ProductModel, missing fields become null.
  @JsonKey(name: 'product')
  ProductModel? product;

  CartItemModel({this.id, this.count, this.price, this.product});

  factory CartItemModel.fromJson(Map<String, dynamic> json) =>
      _$CartItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$CartItemModelToJson(this);

  CartItemEntity toDomain() => CartItemEntity(
        productId: product?.id ?? '',
        title: product?.title ?? '',
        imageCover: product?.imageCover ?? '',
        brandName: product?.brand?.name ?? '',
        categoryName: product?.category?.name ?? '',
        count: count ?? 0,
        price: (price ?? 0).toDouble(),
        stock: product?.quantity ?? 0,
      );
}
