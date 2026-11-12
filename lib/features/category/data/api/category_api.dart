import 'package:dio/dio.dart';
import 'package:ecommerce_app/core/network/endpoints.dart';
import 'package:ecommerce_app/features/category/data/model/response_model/categories_response_model.dart';
import 'package:ecommerce_app/features/category/data/model/response_model/sub_categories_response_model.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'category_api.g.dart';

@injectable
@RestApi()
abstract class CategoryApi {
  @factoryMethod
  factory CategoryApi(Dio dio) = _CategoryApi;

  @GET(Endpoints.categories)
  Future<CategoriesResponseModel> getCategories();

  // @Path('id') replaces {id} in '/categories/{id}'
  @GET(Endpoints.subCategories)
  Future<SubCategoriesResponseModel> getSubCategories(
      @Path('id') String categoryId);
}
