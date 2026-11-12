import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_app/core/resources/assets_manager.dart';
import 'package:ecommerce_app/core/resources/color_manager.dart';
import 'package:ecommerce_app/core/resources/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomCategoryWidget extends StatelessWidget {
  final String name;
  final String imageUrl;

  const CustomCategoryWidget({
    super.key,
    required this.name,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ClipOval cuts the image into a circle.
        ClipOval(
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            height: 100.h,
            width: 100.w,
            fit: BoxFit.cover,
            // Shown while the image is downloading (first time only — after
            // that it comes from the cache instantly).
            placeholder: (context, url) => Container(
              color: ColorManager.containerGray,
            ),
            // Shown if the download fails (bad URL, no internet...).
            errorWidget: (context, url, error) => Image.asset(
              ImageAssets.categoryHomeImage,
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: getRegularStyle(color: ColorManager.darkBlue, fontSize: 14.sp),
        ),
      ],
    );
  }
}
