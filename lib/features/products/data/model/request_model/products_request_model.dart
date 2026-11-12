import 'package:ecommerce_app/features/products/domain/entity/products_params_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'products_request_model.g.dart';

/// The DATA-layer version of [ProductsParamsEntity].
///
/// The entity (domain) uses nice Dart names like `priceGte`.
/// This model knows the EXACT query keys the server expects,
/// like `price[gte]` (via @JsonKey), and turns itself into the
/// query map via the generated [toJson].
///
/// `createFactory: false` → no fromJson, because we only SEND this, never receive it.
@JsonSerializable(createFactory: false)
class ProductsRequestModel {
  final int? limit;
  final int? page;
  final String? sort;
  final String? fields;
  final String? keyword;
  final String? brand;
  @JsonKey(name: 'price[gte]')
  final num? priceGte;
  @JsonKey(name: 'price[lte]')
  final num? priceLte;
  @JsonKey(name: 'category[in]')
  final List<String>? categoryIn;

  const ProductsRequestModel({
    this.limit,
    this.page,
    this.sort,
    this.fields,
    this.keyword,
    this.brand,
    this.priceGte,
    this.priceLte,
    this.categoryIn,
  });

  /// Null fields are removed, so they don't appear in the URL as `?brand=null`.
  Map<String, dynamic> toJson() =>
      _$ProductsRequestModelToJson(this)..removeWhere((key, value) => value == null);

  /// Entity (domain) → request model (data).
  static ProductsRequestModel fromDomain(ProductsParamsEntity params) {
    return ProductsRequestModel(
      limit: params.limit,
      page: params.page,
      sort: params.sort,
      fields: params.fields,
      keyword: params.keyword,
      brand: params.brand,
      priceGte: params.priceGte,
      priceLte: params.priceLte,
      // An empty list becomes null so it's skipped (includeIfNull only skips nulls).
      categoryIn: (params.categoryIn?.isEmpty ?? true) ? null : params.categoryIn,
    );
  }
}
