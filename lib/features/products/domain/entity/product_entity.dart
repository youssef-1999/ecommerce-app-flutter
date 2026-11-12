/// One entity used by BOTH the products grid and the product details screen.
/// The API returns the same product shape for both endpoints, so one class is enough.
class ProductEntity {
  final String id;
  final String title;
  final String description;
  final double price; // original price
  final double? priceAfterDiscount; // null when the product has no discount
  final String imageCover; // main image (used in the grid)
  final List<String> images; // all images (used in the details slider)
  final double ratingsAverage; // e.g. 4.1
  final int ratingsQuantity; // how many people rated it
  final int sold;
  final int quantity; // stock left
  final String categoryId;
  final String categoryName;
  final String brandName;

  const ProductEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    this.priceAfterDiscount,
    required this.imageCover,
    required this.images,
    required this.ratingsAverage,
    required this.ratingsQuantity,
    required this.sold,
    required this.quantity,
    required this.categoryId,
    required this.categoryName,
    required this.brandName,
  });

  bool get hasDiscount =>
      priceAfterDiscount != null && priceAfterDiscount! < price;

  /// The price the user actually pays.
  double get finalPrice => hasDiscount ? priceAfterDiscount! : price;

  /// e.g. price 400, after discount 300 → 25
  int get discountPercentage =>
      hasDiscount ? (((price - priceAfterDiscount!) / price) * 100).round() : 0;
}
