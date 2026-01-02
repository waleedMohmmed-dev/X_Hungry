import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hungry_app/core/constans/app_colors.dart';
import 'package:hungry_app/shared/costum_text.dart';

class CardWidget extends StatelessWidget {
  const CardWidget({
    super.key,
    required this.image,
    required this.desc,
    required this.rate,
    required this.text,
  });

  final String image, desc, rate, text;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(image, width: 120.w),
            Gap(6),
            CostumText(
              text: text,
              color: AppColors.primaryColor,
              weight: FontWeight.bold,
              size: 14.sp,
            ),
            CostumText(
              maxLines: 2,
              text: desc,
              color: Colors.grey.shade700,
              weight: FontWeight.w500,
              size: 10.sp,
            ),
            Gap(6),

            Row(
              children: [
                CostumText(
                  text: '⭐ $rate',
                  weight: FontWeight.w500,
                  size: 14.sp,
                  color: AppColors.primaryColor,
                ),
                Spacer(),
                Icon(CupertinoIcons.heart, color: AppColors.primaryColor),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
