import 'package:dio/dio.dart';
import 'package:ecommerce_app/core/network/error/error_model.dart';
import 'package:ecommerce_app/features/products/data/data_source/products_data_source.dart';
import 'package:ecommerce_app/features/products/data/model/request_model/products_request_model.dart';
import 'package:ecommerce_app/features/products/domain/entity/product_entity.dart';
import 'package:ecommerce_app/features/products/domain/entity/products_params_entity.dart';
import 'package:ecommerce_app/features/products/domain/repository/products_repo.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ProductsRepo)
class ProductsRepoImpl implements ProductsRepo {
  final ProductsDataSource _productsDataSource;
  ProductsRepoImpl(this._productsDataSource);

  @override
  Future<List<ProductEntity>> getProducts(ProductsParamsEntity params) async {
    try {
      // entity (domain) → request model (data), same as LoginRequestModel
      final response = await _productsDataSource
          .getProducts(ProductsRequestModel.fromDomain(params));
      // data is a list → convert every item
      return (response.data ?? [])
          .map((product) => product.toDomain())
          .toList();
    } on DioException catch (e) {
      throw ErrorModel.fromDioException(e);
    }
  }

  @override
  Future<ProductEntity> getProductDetails(String productId) async {
    try {
      final response = await _productsDataSource.getProductDetails(productId);
      final product = response.data;
      // details MUST return a product — no product means something went wrong
      if (product == null) {
        throw GeneralError(errorMessage: 'Product not found');
      }
      return product.toDomain();
    } on DioException catch (e) {
      throw ErrorModel.fromDioException(e);
    }
  }
}
