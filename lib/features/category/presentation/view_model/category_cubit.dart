import 'package:ecommerce_app/core/network/error/error_model.dart';
import 'package:ecommerce_app/features/category/domain/usecases/get_categories_usecase.dart';
import 'package:ecommerce_app/features/category/domain/usecases/get_sub_categories_usecase.dart';
import 'package:ecommerce_app/features/category/presentation/view_model/category_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class CategoryCubit extends Cubit<CategoryState> {
  final GetCategoriesUsecase getCategoriesUsecase;
  final GetSubCategoriesUsecase getSubCategoriesUsecase;

  CategoryCubit({
    required this.getCategoriesUsecase,
    required this.getSubCategoriesUsecase,
  }) : super(const CategoryState());

  /// Loads the left list, then automatically loads the first category's subcategories.
  Future<void> getCategories() async {
    emit(state.copyWith(isLoading: true));
    try {
      final categories = await getCategoriesUsecase();
      emit(state.copyWith(
        isLoading: false,
        categories: categories,
        selectedIndex: 0,
      ));
      if (categories.isNotEmpty) {
        await selectCategory(0);
      }
    } on ErrorModel catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.message));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  /// Called when the user taps a category on the left.
  Future<void> selectCategory(int index) async {
    final category = state.categories[index];
    emit(state.copyWith(
      selectedIndex: index,
      isSubLoading: true,
      subCategories: [], // clear the old grid while loading
    ));
    try {
      final subCategories = await getSubCategoriesUsecase(category.id);
      // The user tapped another category while we waited → ignore this stale answer.
      if (state.selectedIndex != index) return;
      emit(state.copyWith(isSubLoading: false, subCategories: subCategories));
    } on ErrorModel catch (e) {
      if (state.selectedIndex != index) return;
      emit(state.copyWith(isSubLoading: false, errorMessage: e.message));
    } catch (e) {
      if (state.selectedIndex != index) return;
      emit(state.copyWith(isSubLoading: false, errorMessage: e.toString()));
    }
  }
}
