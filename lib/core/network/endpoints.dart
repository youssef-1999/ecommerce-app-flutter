class Endpoints {
  static const String login = '/auth/signin';
  static const String register = '/auth/signup';

  // Category feature
  static const String categories = '/categories';
  static const String subCategories = '/categories/{id}';

  // Products feature
  static const String products = '/products'; // list (+ filters as ?query)
  static const String productDetails = '/products/{id}'; // one product
}
