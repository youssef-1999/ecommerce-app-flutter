import 'package:ecommerce_app/features/category/data/model/category_model.dart';
import 'package:ecommerce_app/features/products/domain/entity/product_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product_model.g.dart';

/// Matches ONE product object from the API exactly (everything nullable,
/// because we don't trust the server to always send every field).
@JsonSerializable()
class ProductModel {
  @JsonKey(name: '_id')
  String? id;
  @JsonKey(name: 'title')
  String? title;
  @JsonKey(name: 'slug')
  String? slug;
  @JsonKey(name: 'description')
  String? description;
  @JsonKey(name: 'quantity')
  int? quantity;
  @JsonKey(name: 'sold')
  int? sold;
  // "num" accepts both 149 and 149.5 from JSON
  @JsonKey(name: 'price')
  num? price;
  @JsonKey(name: 'priceAfterDiscount')
  num? priceAfterDiscount;
  @JsonKey(name: 'imageCover')
  String? imageCover;
  @JsonKey(name: 'images')
  List<String>? images;
  @JsonKey(name: 'ratingsAverage')
  num? ratingsAverage;
  @JsonKey(name: 'ratingsQuantity')
  int? ratingsQuantity;
  // The category inside a product has the same shape as a category → reuse CategoryModel
  @JsonKey(name: 'category')
  CategoryModel? category;
  @JsonKey(name: 'brand')
  BrandModel? brand;

  ProductModel({
    this.id,
    this.title,
    this.slug,
    this.description,
    this.quantity,
    this.sold,
    this.price,
    this.priceAfterDiscount,
    this.imageCover,
    this.images,
    this.ratingsAverage,
    this.ratingsQuantity,
    this.category,
    this.brand,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductModelToJson(this);

  /// Data → Domain: keep only what the app needs, replace null with defaults.
  ProductEntity toDomain() => ProductEntity(
        id: id ?? '',
        title: title ?? '',
        description: description ?? '',
        price: (price ?? 0).toDouble(),
        priceAfterDiscount: priceAfterDiscount?.toDouble(),
        imageCover: imageCover ?? '',
        images: images ?? [],
        ratingsAverage: (ratingsAverage ?? 0).toDouble(),
        ratingsQuantity: ratingsQuantity ?? 0,
        sold: sold ?? 0,
        quantity: quantity ?? 0,
        categoryId: category?.id ?? '',
        categoryName: category?.name ?? '',
        brandName: brand?.name ?? '',
      );
}

@JsonSerializable()
class BrandModel {
  @JsonKey(name: '_id')
  String? id;
  @JsonKey(name: 'name')
  String? name;
  @JsonKey(name: 'slug')
  String? slug;
  @JsonKey(name: 'image')
  String? image;

  BrandModel({this.id, this.name, this.slug, this.image});

  factory BrandModel.fromJson(Map<String, dynamic> json) =>
      _$BrandModelFromJson(json);

  Map<String, dynamic> toJson() => _$BrandModelToJson(this);
}
