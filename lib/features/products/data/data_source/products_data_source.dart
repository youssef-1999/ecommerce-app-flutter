import 'package:ecommerce_app/features/products/data/api/products_api.dart';
import 'package:ecommerce_app/features/products/data/model/request_model/products_request_model.dart';
import 'package:ecommerce_app/features/products/data/model/response_model/product_details_response_model.dart';
import 'package:ecommerce_app/features/products/data/model/response_model/products_response_model.dart';
import 'package:injectable/injectable.dart';

abstract class ProductsDataSource {
  Future<ProductsResponseModel> getProducts(ProductsRequestModel requestModel);
  Future<ProductDetailsResponseModel> getProductDetails(String productId);
}

@Injectable(as: ProductsDataSource)
class ProductsRemoteDataSource implements ProductsDataSource {
  final ProductsApi _productsApi;
  ProductsRemoteDataSource(this._productsApi);

  @override
  Future<ProductsResponseModel> getProducts(
          ProductsRequestModel requestModel) async =>
      await _productsApi.getProducts(requestModel.toJson());

  @override
  Future<ProductDetailsResponseModel> getProductDetails(
          String productId) async =>
      await _productsApi.getProductDetails(productId);
}
