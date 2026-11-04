import 'package:ecommerce_app/core/resources/color_manager.dart';
import 'package:ecommerce_app/core/resources/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomElevatedButton extends StatelessWidget {
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String label;
  final Color? backgroundColor;
  final double? radius;
  final void Function() onTap;
  final TextStyle? textStyle;
  final bool isStadiumBorder;
  final bool isLoading;


  const CustomElevatedButton(
      {super.key,
      this.prefixIcon,
      this.textStyle,
      this.isStadiumBorder = true,
      this.isLoading = false,
      this.backgroundColor,
      this.radius,
      this.suffixIcon,
      required this.label,
      required this.onTap});

  @override

  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: isStadiumBorder
              ? const StadiumBorder()
              : RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(17.r)),
          backgroundColor: backgroundColor ?? ColorManager.primary,
          // keep the same color while disabled (loading) instead of grey
          disabledBackgroundColor: backgroundColor ?? ColorManager.primary,
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 14.h),
        ),
        // null disables the button so the user can't send the request twice
        onPressed: isLoading ? null : onTap,
        child: isLoading
            // a full-width Row keeps the button the same size as normal
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 28.h,
                    width: 28.h,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: textStyle?.color ?? ColorManager.white,
                    ),
                  ),
                ],
              )
            : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            prefixIcon ?? const SizedBox(),
            SizedBox(
              width: 24.w,
            ),
            Text(
              label,
              style: textStyle ??
                  getMediumStyle(color: ColorManager.white)
                      .copyWith(fontSize: 20.sp),
            ),
            SizedBox(
              width: 27.w,
            ),
            suffixIcon ?? const SizedBox()
          ],
        ));
  }
}
