import 'package:ecommerce_app/features/products/data/model/product_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product_details_response_model.g.dart';

/// GET /products/{id} → { data: { ...one product } }
@JsonSerializable()
class ProductDetailsResponseModel {
  @JsonKey(name: 'data')
  ProductModel? data; // one object → no List

  ProductDetailsResponseModel({this.data});

  factory ProductDetailsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ProductDetailsResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductDetailsResponseModelToJson(this);
}
