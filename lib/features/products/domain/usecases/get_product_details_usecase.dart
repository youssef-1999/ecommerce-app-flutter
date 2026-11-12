import 'package:ecommerce_app/features/products/domain/entity/product_entity.dart';
import 'package:ecommerce_app/features/products/domain/repository/products_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetProductDetailsUsecase {
  final ProductsRepo _productsRepo;

  GetProductDetailsUsecase({required ProductsRepo productsRepo})
      : _productsRepo = productsRepo;

  Future<ProductEntity> call(String productId) async =>
      await _productsRepo.getProductDetails(productId);
}
