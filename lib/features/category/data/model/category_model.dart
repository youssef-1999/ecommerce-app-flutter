import 'package:ecommerce_app/features/category/domain/entity/category_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'category_model.g.dart';

@JsonSerializable()
class CategoryModel {
  @JsonKey(name: '_id')
  String? id;
  @JsonKey(name: 'name')
  String? name;
  @JsonKey(name: 'slug')
  String? slug;
  @JsonKey(name: 'image')
  String? image;
  @JsonKey(name: 'createdAt')
  String? createdAt;
  @JsonKey(name: 'updatedAt')
  String? updatedAt;

  CategoryModel({
    this.id,
    this.name,
    this.slug,
    this.image,
    this.createdAt,
    this.updatedAt,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);

  /// Data → Domain: keep only what the app needs, replace null with ''.
  CategoryEntity toDomain() => CategoryEntity(
        id: id ?? '',
        name: name ?? '',
        image: image ?? '',
      );
}
