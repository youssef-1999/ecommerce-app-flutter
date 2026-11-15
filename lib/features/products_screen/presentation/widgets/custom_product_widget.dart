import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_app/core/resources/assets_manager.dart';
import 'package:ecommerce_app/core/resources/color_manager.dart';
import 'package:ecommerce_app/core/resources/styles_manager.dart';
import 'package:ecommerce_app/core/routes_manager/routes.dart';
import 'package:ecommerce_app/core/widget/heart_button.dart';
import 'package:ecommerce_app/features/cart/presentation/view_model/cart_cubit.dart';
import 'package:ecommerce_app/features/cart/presentation/view_model/cart_status.dart';
import 'package:ecommerce_app/features/products/domain/entity/product_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// One product card in the products grid.
/// It receives a whole [ProductEntity] (the product from the API)
/// instead of many separate fields.
class CustomProductWidget extends StatelessWidget {
  final ProductEntity product;

  const CustomProductWidget({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, Routes.productDetails),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: ColorManager.primary.withValues(alpha: 0.3),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ---------- Image + heart ----------
            Expanded(
              flex: 5,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(14.r)),
                      child: CachedNetworkImage(
                        imageUrl: product.imageCover,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            Container(color: ColorManager.containerGray),
                        errorWidget: (context, url, error) => Image.asset(
                          ImageAssets.categoryHomeImage,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 6.h,
                    right: 6.w,
                    child: HeartButton(onTap: () {}),
                  ),
                ],
              ),
            ),
            // ---------- Texts ----------
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: getMediumStyle(
                        color: ColorManager.textColor,
                        fontSize: 14.sp,
                      ),
                    ),
                    Text(
                      product.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: getRegularStyle(
                        color: ColorManager.textColor,
                        fontSize: 14.sp,
                      ),
                    ),
                    const Spacer(),
                    // Price (and old price crossed out when there is a discount)
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            "EGP ${product.finalPrice.toStringAsFixed(0)}",
                            overflow: TextOverflow.ellipsis,
                            style: getRegularStyle(
                              color: ColorManager.textColor,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                        if (product.hasDiscount) ...[
                          SizedBox(width: 8.w),
                          Flexible(
                            child: Text(
                              "${product.price.toStringAsFixed(0)} EGP",
                              overflow: TextOverflow.ellipsis,
                              style: getTextWithLine(),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Text(
                          "Review (${product.ratingsAverage})",
                          style: getRegularStyle(
                            color: ColorManager.textColor,
                            fontSize: 12.sp,
                          ),
                        ),
                        const Icon(
                          Icons.star_rate_rounded,
                          color: ColorManager.starRateColor,
                        ),
                        const Spacer(),
                        // Redraw ONLY this button when "is it in the cart?" changes.
                        BlocBuilder<CartCubit, CartStatus>(
                          buildWhen: (prev, curr) =>
                              prev.isInCart(product.id) !=
                              curr.isInCart(product.id),
                          builder: (context, state) {
                            final inCart = state.isInCart(product.id);
                            final cubit = context.read<CartCubit>();
                            return InkWell(
                              // in cart → remove it, not in cart → add it
                              onTap: () => inCart
                                  ? cubit.removeItem(product.id)
                                  : cubit.addToCart(product.id),
                              customBorder: const CircleBorder(),
                              child: Container(
                                width: 30.r,
                                height: 30.r,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  // red when it's in the cart, so it stands out
                                  color: inCart
                                      ? ColorManager.error
                                      : ColorManager.primary,
                                ),
                                child: Icon(
                                  inCart ? Icons.delete_outline : Icons.add,
                                  color: Colors.white,
                                  size: 20.r,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
