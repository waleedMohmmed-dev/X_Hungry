import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hungry_app/core/constans/app_colors.dart';

class CostumButton extends StatelessWidget {
  final String? buttonText;
  final Color? buttonColor;

  final double? width;
  final double? height;
  final double? raidus;
  final double? side;
  final Color? textColor;
  final double? fontSize;
  final void Function()? onTap;
  // final Widget? icon;
  final Widget? widget;
  // final Widget? tralingIcon;
  final bool isLoding;
  final double? gap;

  const CostumButton({
    super.key,
    this.buttonText,
    this.buttonColor,
    this.side,
    this.width,
    this.height,
    this.raidus,
    this.fontSize,
    this.textColor,
    this.onTap,
    // this.icon,
    // this.tralingIcon,
    this.isLoding = false,
    this.widget,
    this.gap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor ?? AppColors.primaryColor,
        shape: RoundedRectangleBorder(
          side:
              BorderSide(color: Color(0xffCCCCCC), width: 1) ??
              const BorderSide(color: Colors.white, width: 1),
          borderRadius: BorderRadius.circular(raidus ?? 8.r),
        ),
        fixedSize: Size(width ?? 331.w, height ?? 56.h),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            buttonText ?? "",
            style: TextStyle(
              color: textColor ?? Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: fontSize ?? 16.sp,
            ),
          ),
          Gap(gap ?? 0.0),
          widget ?? SizedBox.shrink(),
        ],
      ),
    );
  }
}
