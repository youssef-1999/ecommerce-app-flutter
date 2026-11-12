import 'package:equatable/equatable.dart';

/// All the filters you can send to GET /products, bundled in ONE object.
///
/// Instead of passing (limit, page, sort, ...) one by one through
/// cubit → usecase → repo → data source → api, we pass this single object.
///
/// Every field is optional: `const ProductsParamsEntity()` means "all products".
///
/// Extends Equatable so two params with the same values are "equal"
/// (useful later, e.g. to skip reloading when the filters didn't change).
class ProductsParamsEntity extends Equatable {
  /// Page size, e.g. `limit=2`.
  final int? limit;

  /// Page number (1-based), e.g. `page=2`.
  final int? page;

  /// Sort expression, prefix with `-` for descending,
  /// e.g. `sort=price` (low → high) or `sort=-price` (high → low).
  final String? sort;

  /// Comma-separated response fields, e.g. `fields=title,price`.
  final String? fields;

  /// Free-text search, e.g. `keyword=new`.
  final String? keyword;

  /// Brand id, e.g. `brand=6212b6b488f2cee15c5db3c8`.
  final String? brand;

  /// Minimum price (inclusive), sent as `price[gte]`.
  final num? priceGte;

  /// Maximum price (inclusive), sent as `price[lte]`.
  final num? priceLte;

  /// Category ids, sent as one `category[in]` entry per id.
  /// One category → `categoryIn: [id]`.
  final List<String>? categoryIn;

  const ProductsParamsEntity({
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

  @override
  List<Object?> get props => [
        limit,
        page,
        sort,
        fields,
        keyword,
        brand,
        priceGte,
        priceLte,
        categoryIn,
      ];
}
