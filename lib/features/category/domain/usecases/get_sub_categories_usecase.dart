import 'package:ecommerce_app/features/category/domain/entity/category_entity.dart';
import 'package:ecommerce_app/features/category/domain/repository/category_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetSubCategoriesUsecase {
  final CategoryRepo _categoryRepo;

  GetSubCategoriesUsecase({required CategoryRepo categoryRepo})
      : _categoryRepo = categoryRepo;

  Future<List<CategoryEntity>> call(String categoryId) async =>
      await _categoryRepo.getSubCategories(categoryId);
}
