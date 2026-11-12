import 'package:ecommerce_app/core/resources/color_manager.dart';
import 'package:ecommerce_app/core/resources/font_manager.dart';
import 'package:ecommerce_app/core/resources/styles_manager.dart';
import 'package:ecommerce_app/core/resources/values_manager.dart';
import 'package:ecommerce_app/features/category/domain/entity/category_entity.dart';
import 'package:ecommerce_app/features/category/presentation/view/widgets/category_card_item.dart';
import 'package:flutter/material.dart';

import 'sub_category_item.dart';

class SubCategoriesList extends StatelessWidget {
  final CategoryEntity category;
  final List<CategoryEntity> subCategories; // same entity type
  final bool isLoading;
  final String? errorMessage;

  const SubCategoriesList({
    super.key,
    required this.category,
    required this.subCategories,
    required this.isLoading,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: CustomScrollView(
        slivers: <Widget>[
          // category title
          SliverToBoxAdapter(
            child: Text(
              category.name,
              style: getBoldStyle(
                  color: ColorManager.primary, fontSize: FontSize.s14),
            ),
          ),
          // the category card
          SliverToBoxAdapter(
            child: CategoryCardItem(
                category.name, category.image, goToCategoryProductsListScreen),
          ),
          // spinner / message / grid
          if (isLoading)
            SliverToBoxAdapter(
              child: Center(
                child: CircularProgressIndicator(color: ColorManager.primary),
              ),
            )
          else if (subCategories.isEmpty)
            SliverToBoxAdapter(
              child: Center(
                child: Text(
                  errorMessage ?? 'No subcategories',
                  style: getRegularStyle(color: ColorManager.primary),
                ),
              ),
            )
          else
            SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  childCount: subCategories.length,
                  (context, index) => SubCategoryItem(
                      subCategories[index].name,
                      subCategories[index].image,
                      goToCategoryProductsListScreen),
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 0.75,
                  mainAxisSpacing: AppSize.s8,
                  crossAxisSpacing: AppSize.s8,
                ))
        ],
      ),
    );
  }

  goToCategoryProductsListScreen() {
    // todo implement this function
  }
}
