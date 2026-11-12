import 'package:ecommerce_app/features/category/domain/entity/category_entity.dart';

abstract class CategoryRepo {
  Future<List<CategoryEntity>> getCategories();
  Future<List<CategoryEntity>> getSubCategories(String categoryId);
}
