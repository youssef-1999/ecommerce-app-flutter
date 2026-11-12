import 'package:ecommerce_app/core/resources/color_manager.dart';
import 'package:ecommerce_app/core/resources/values_manager.dart';
import 'package:ecommerce_app/features/category/domain/entity/category_entity.dart';
import 'package:ecommerce_app/features/category/presentation/view/widgets/category_item.dart';
import 'package:flutter/material.dart';

class CategoriesList extends StatelessWidget {
  final List<CategoryEntity> categories;
  final int selectedIndex;
  final void Function(int index) onItemClick;

  const CategoriesList({
    super.key,
    required this.categories,
    required this.selectedIndex,
    required this.onItemClick,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
      decoration: BoxDecoration(
        color: ColorManager.containerGray,
        border: Border(
            // set the border for only 3 sides
            top: BorderSide(
                width: AppSize.s2,
                color: ColorManager.primary.withValues(alpha: 0.3)),
            left: BorderSide(
                width: AppSize.s2,
                color: ColorManager.primary.withValues(alpha: 0.3)),
            bottom: BorderSide(
                width: AppSize.s2,
                color: ColorManager.primary.withValues(alpha: 0.3))),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppSize.s12),
          bottomLeft: Radius.circular(AppSize.s12),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppSize.s12),
          bottomLeft: Radius.circular(AppSize.s12),
        ),
        child: ListView.builder(
          itemCount: categories.length,
          itemBuilder: (context, index) => CategoryItem(
            index,
            categories[index].name,
            selectedIndex == index,
            onItemClick,
          ),
        ),
      ),
    ));
  }
}
