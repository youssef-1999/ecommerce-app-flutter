import 'package:ecommerce_app/features/category/domain/entity/category_entity.dart';
import 'package:equatable/equatable.dart';

class CategoryState extends Equatable {
  final List<CategoryEntity> categories; // left list
  final List<CategoryEntity> subCategories; // right grid (same entity)
  final int selectedIndex;
  final bool isLoading; // loading the left list
  final bool isSubLoading; // loading the right grid
  final String? errorMessage;

  const CategoryState({
    this.categories = const [],
    this.subCategories = const [],
    this.selectedIndex = 0,
    this.isLoading = false,
    this.isSubLoading = false,
    this.errorMessage,
  });

  /// The category currently highlighted on the left, or null if the list is empty.
  CategoryEntity? get selectedCategory =>
      categories.isEmpty ? null : categories[selectedIndex];

  CategoryState copyWith({
    List<CategoryEntity>? categories,
    List<CategoryEntity>? subCategories,
    int? selectedIndex,
    bool? isLoading,
    bool? isSubLoading,
    String? errorMessage,
  }) {
    return CategoryState(
      categories: categories ?? this.categories,
      subCategories: subCategories ?? this.subCategories,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      isLoading: isLoading ?? this.isLoading,
      isSubLoading: isSubLoading ?? this.isSubLoading,
      // NOT "?? this.errorMessage" on purpose: every new state clears the
      // old error unless you pass a new one.
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [categories, subCategories, selectedIndex, isLoading, isSubLoading, errorMessage];
}
