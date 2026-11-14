/// The whole cart as the UI needs it.
class CartEntity {
  final String id;
  final List<CartItemEntity> items;
  final double totalPrice; // already calculated by the server

  const CartEntity({
    required this.id,
    required this.items,
    required this.totalPrice,
  });

  /// Used when the user has no cart yet (server answers 404).
  const CartEntity.empty() : id = '', items = const [], totalPrice = 0;

  bool get isEmpty => items.isEmpty;

  /// Number of different products in the cart (for the cart badge).
  int get itemsCount => items.length;
}

/// One line in the cart: a product + how many of it.
class CartItemEntity {
  /// Use this id for update count / remove item (/cart/{productId}).
  final String productId;
  final String title;
  final String imageCover;
  final String brandName;
  final String categoryName;
  final int count; // how many the user wants
  final double price; // price of ONE piece
  final int stock; // how many are left in the store

  const CartItemEntity({
    required this.productId,
    required this.title,
    required this.imageCover,
    required this.brandName,
    required this.categoryName,
    required this.count,
    required this.price,
    required this.stock,
  });

  /// price × count, e.g. 150 × 2 = 300
  double get totalPrice => price * count;

  bool get canIncrease => count < stock;
}
