import 'package:ecommerce_app/features/category/data/model/response_model/categories_response_model.dart';
import 'package:ecommerce_app/features/products/data/model/product_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'products_response_model.g.dart';

/// GET /products → { results, metadata, data: [ ...products ] }
@JsonSerializable()
class ProductsResponseModel {
  @JsonKey(name: 'results')
  int? results;
  // Same metadata shape as categories → reuse it
  @JsonKey(name: 'metadata')
  Metadata? metadata;
  @JsonKey(name: 'data')
  List<ProductModel>? data;

  ProductsResponseModel({this.results, this.metadata, this.data});

  factory ProductsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ProductsResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductsResponseModelToJson(this);
}
