import 'package:ecommerce_app/features/category/data/model/category_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'sub_categories_response_model.g.dart';

@JsonSerializable()
class SubCategoriesResponseModel {
  @JsonKey(name: 'data')
  CategoryModel? data; // one object → no List

  SubCategoriesResponseModel({this.data});

  factory SubCategoriesResponseModel.fromJson(Map<String, dynamic> json) =>
      _$SubCategoriesResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$SubCategoriesResponseModelToJson(this);
}
