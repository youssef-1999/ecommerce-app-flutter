import 'package:dio/dio.dart';
import 'package:ecommerce_app/core/network/endpoints.dart';
import 'package:ecommerce_app/features/products/data/model/response_model/product_details_response_model.dart';
import 'package:ecommerce_app/features/products/data/model/response_model/products_response_model.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'products_api.g.dart';

@injectable
@RestApi()
abstract class ProductsApi {
  @factoryMethod
  factory ProductsApi(Dio dio) = _ProductsApi;

  // @Queries takes a whole Map and turns every entry into "?key=value&...".
  // Example map: {'limit': 10, 'price[gte]': 500}  →  /products?limit=10&price[gte]=500
  // A List value is sent once per item: {'category[in]': ['a','b']}
  //   →  ?category[in]=a&category[in]=b
  @GET(Endpoints.products)
  Future<ProductsResponseModel> getProducts(
      @Queries() Map<String, dynamic> queries);

  // @Path('id') replaces {id} in '/products/{id}'
  @GET(Endpoints.productDetails)
  Future<ProductDetailsResponseModel> getProductDetails(
      @Path('id') String productId);
}
