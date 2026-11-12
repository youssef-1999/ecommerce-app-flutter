import 'package:dio/dio.dart';
import 'package:ecommerce_app/core/network/error/error_model.dart';
import 'package:ecommerce_app/features/category/data/data_source/category_data_source.dart';
import 'package:ecommerce_app/features/category/domain/entity/category_entity.dart';
import 'package:ecommerce_app/features/category/domain/repository/category_repo.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: CategoryRepo)
class CategoryRepoImpl implements CategoryRepo {
  final CategoryDataSource _categoryDataSource;
  CategoryRepoImpl(this._categoryDataSource);

  @override
  Future<List<CategoryEntity>> getCategories() async {
    try {
      final response = await _categoryDataSource.getCategories();
      // data is a list → convert every item
      return (response.data ?? [])
          .map((category) => category.toDomain())
          .toList();
    } on DioException catch (e) {
      throw ErrorModel.fromDioException(e);
    }
  }

  @override
  Future<List<CategoryEntity>> getSubCategories(String categoryId) async {
    try {
      final response = await _categoryDataSource.getSubCategories(categoryId);
      final category = response.data;
      // data is ONE object → wrap it in a list (empty if missing)
      return category == null ? [] : [category.toDomain()];
    } on DioException catch (e) {
      throw ErrorModel.fromDioException(e);
    }
  }
}
