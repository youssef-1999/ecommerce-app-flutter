import 'package:ecommerce_app/features/category/data/model/category_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'categories_response_model.g.dart';

@JsonSerializable()
class CategoriesResponseModel {
  @JsonKey(name: 'results')
  int? results;
  @JsonKey(name: 'metadata')
  Metadata? metadata;
  @JsonKey(name: 'data')
  List<CategoryModel>? data;

  CategoriesResponseModel({this.results, this.metadata, this.data});

  factory CategoriesResponseModel.fromJson(Map<String, dynamic> json) =>
      _$CategoriesResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$CategoriesResponseModelToJson(this);
}

@JsonSerializable()
class Metadata {
  @JsonKey(name: 'currentPage')
  int? currentPage;
  @JsonKey(name: 'numberOfPages')
  int? numberOfPages;
  @JsonKey(name: 'limit')
  int? limit;

  Metadata({this.currentPage, this.numberOfPages, this.limit});

  factory Metadata.fromJson(Map<String, dynamic> json) =>
      _$MetadataFromJson(json);

  Map<String, dynamic> toJson() => _$MetadataToJson(this);
}
