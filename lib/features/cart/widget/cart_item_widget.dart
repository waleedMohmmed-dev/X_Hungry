import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hungry_app/core/constans/app_colors.dart';
import 'package:hungry_app/features/products/widget/costum_button.dart';
import 'package:hungry_app/shared/costum_text.dart';

class CartItemWidget extends StatelessWidget {
  const CartItemWidget({
    super.key,

    required this.isLoding,
    required this.image,
    required this.text,
    this.onAdd,
    this.onRemove,
    this.onMinus,
    required this.number,

    required this.des,
  });
  final bool isLoding;
  final String image, text, des;
  final Function()? onAdd;
  final Function()? onRemove;
  final Function()? onMinus;

  final int number;

  @override
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 7),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(image, width: 85.w),
                  CostumText(text: text, weight: FontWeight.bold, size: 15),
                  CostumText(text: des, size: 16),
                ],
              ),
            ),

            Column(
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: onAdd,
                      child: CircleAvatar(
                        backgroundColor: AppColors.primaryColor,
                        child: Icon(CupertinoIcons.add, color: Colors.white),
                      ),
                    ),
                    Gap(20),
                    CostumText(
                      text: number.toString(),
                      weight: FontWeight.bold,
                      size: 15,
                    ),

                    Gap(20),
                    GestureDetector(
                      onTap: onMinus,
                      child: CircleAvatar(
                        backgroundColor: AppColors.primaryColor,
                        child: Icon(CupertinoIcons.minus, color: Colors.white),
                      ),
                    ),
                  ],
                ),

                Gap(15),
                isLoding
                    ? CupertinoActivityIndicator(color: Colors.black)
                    : CostumButton(
                        onTap: onRemove,
                        width: 140.w,
                        height: 30.h,
                        raidus: 20,
                        buttonText: 'Remove',
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
