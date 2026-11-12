import 'package:ecommerce_app/features/category/data/api/category_api.dart';
import 'package:ecommerce_app/features/category/data/model/response_model/categories_response_model.dart';
import 'package:ecommerce_app/features/category/data/model/response_model/sub_categories_response_model.dart';
import 'package:injectable/injectable.dart';

abstract class CategoryDataSource {
  Future<CategoriesResponseModel> getCategories();
  Future<SubCategoriesResponseModel> getSubCategories(String categoryId);
}

@Injectable(as: CategoryDataSource)
class CategoryRemoteDataSource implements CategoryDataSource {
  final CategoryApi _categoryApi;
  CategoryRemoteDataSource(this._categoryApi);

  @override
  Future<CategoriesResponseModel> getCategories() async =>
      await _categoryApi.getCategories();

  @override
  Future<SubCategoriesResponseModel> getSubCategories(String categoryId) async =>
      await _categoryApi.getSubCategories(categoryId);
}
