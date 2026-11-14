class Endpoints {
  static const String login = '/auth/signin';
  static const String register = '/auth/signup';

  // Category feature
  static const String categories = '/categories';
  static const String subCategories = '/categories/{id}';

  // Products feature
  static const String products = '/products'; // list (+ filters as ?query)
  static const String productDetails = '/products/{id}'; // one product

  // Cart feature
  // POST   -> add product to cart   body: { "productId": "..." }
  // GET    -> get logged user cart
  // DELETE -> clear user cart
  static const String cart = '/cart';
  // PUT    -> update item count     body: { "count": "1" }
  // DELETE -> remove specific item
  static const String cartItem = '/cart/{id}';
}
