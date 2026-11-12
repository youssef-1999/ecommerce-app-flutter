import 'package:ecommerce_app/features/products/domain/entity/product_entity.dart';
import 'package:ecommerce_app/features/products/domain/entity/products_params_entity.dart';

abstract class ProductsRepo {
  Future<List<ProductEntity>> getProducts(ProductsParamsEntity params);

  Future<ProductEntity> getProductDetails(String productId);
}
