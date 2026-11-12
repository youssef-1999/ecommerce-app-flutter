import 'package:ecommerce_app/core/di/di.dart';
import 'package:ecommerce_app/core/resources/color_manager.dart';
import 'package:ecommerce_app/core/resources/styles_manager.dart';
import 'package:ecommerce_app/core/resources/values_manager.dart';
import 'package:ecommerce_app/features/category/presentation/view/widgets/categories_list.dart';
import 'package:ecommerce_app/features/category/presentation/view/widgets/sub_categories_list.dart';
import 'package:ecommerce_app/features/category/presentation/view_model/category_cubit.dart';
import 'package:ecommerce_app/features/category/presentation/view_model/category_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoriesTab extends StatelessWidget {
  const CategoriesTab({super.key});

  @override
  Widget build(BuildContext context) {
    // BlocProvider creates the cubit (via getIt) and shares it with every widget below.
    // "..getCategories()" starts loading right after the cubit is created.
    return BlocProvider(
      create: (_) => getIt<CategoryCubit>()..getCategories(),
      child: const _CategoriesView(),
    );
  }
}

class _CategoriesView extends StatelessWidget {
  const _CategoriesView();

  @override
  Widget build(BuildContext context) {
    // BlocBuilder re-runs "builder" every time the cubit emits a new state.
    return BlocBuilder<CategoryCubit, CategoryState>(
      builder: (context, state) {
        // 1) First load → spinner
        if (state.isLoading) {
          return Center(
            child: CircularProgressIndicator(color: ColorManager.primary),
          );
        }

        // 2) Nothing to show → error/empty message + retry
        final selectedCategory = state.selectedCategory;
        if (selectedCategory == null) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  state.errorMessage ?? 'No categories found',
                  style: getRegularStyle(color: ColorManager.primary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSize.s12),
                ElevatedButton(
                  onPressed: () => context.read<CategoryCubit>().getCategories(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        // 3) Data ready → the two-column layout
        return Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppPadding.p12, vertical: AppPadding.p12),
          child: Row(
            children: [
              CategoriesList(
                categories: state.categories,
                selectedIndex: state.selectedIndex,
                onItemClick: (index) =>
                    context.read<CategoryCubit>().selectCategory(index),
              ),
              const SizedBox(width: AppSize.s16),
              SubCategoriesList(
                category: selectedCategory,
                subCategories: state.subCategories,
                isLoading: state.isSubLoading,
                errorMessage: state.errorMessage,
              ),
            ],
          ),
        );
      },
    );
  }
}
