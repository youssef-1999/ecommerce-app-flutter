import 'package:ecommerce_app/features/products/domain/entity/product_entity.dart';
import 'package:ecommerce_app/features/products/domain/entity/products_params_entity.dart';
import 'package:ecommerce_app/features/products/domain/repository/products_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetProductsUsecase {
  final ProductsRepo _productsRepo;

  GetProductsUsecase({required ProductsRepo productsRepo})
      : _productsRepo = productsRepo;

  Future<List<ProductEntity>> call(ProductsParamsEntity params) async =>
      await _productsRepo.getProducts(params);
}
