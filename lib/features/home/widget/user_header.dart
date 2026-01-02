import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:hungry_app/core/constans/app_colors.dart';
import 'package:hungry_app/shared/costum_text.dart';

class UserHeader extends StatelessWidget {
  const UserHeader({
    super.key,
    required this.userName,
    required this.userImage,
  });
  final String userName, userImage;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset(
              'assets/logo/Hungry_.svg',
              color: AppColors.primaryColor,
              height: 40.h,
            ),
            Gap(5),
            CostumText(
              text: userName ?? '',
              color: Colors.grey,
              weight: FontWeight.w400,
              size: 18,
            ),
          ],
        ),
        Spacer(),
        CircleAvatar(
          backgroundColor: Colors.white,
          radius: 34,

          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Image.network(
              userImage ?? 'assets/splach/splsh.png',
              width: 100.w,
              height: 120.h,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }
}
