import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hungry_app/core/constans/app_colors.dart';
import 'package:hungry_app/features/auth/widgets/app_stayling.dart';

class CostumCategories extends StatelessWidget {
  final String catogeryName;
  final VoidCallback? onPress;
  final bool isSelected;
  const CostumCategories({
    super.key,
    required this.catogeryName,
    this.onPress,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress ?? () {},
      child: Padding(
        padding: EdgeInsetsDirectional.only(end: 8.w),
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 7.h),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryColor : Color(0xFFF3F4F6),
            border: isSelected
                ? null
                : Border.all(color: Color(0xffF3F4F6), width: 0.5.w),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Text(
            catogeryName,
            style: AppStyles.black16w500Style.copyWith(
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
