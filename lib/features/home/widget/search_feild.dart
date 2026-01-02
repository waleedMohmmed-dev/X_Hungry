import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hungry_app/core/constans/app_colors.dart';
import 'package:hungry_app/shared/costum_textfeild.dart';

class SearchFeild extends StatefulWidget {
  SearchFeild({super.key, this.onChanged, required this.controller});
  void Function(String)? onChanged;
  final TextEditingController? controller;

  @override
  State<SearchFeild> createState() => _SearchFeildState();
}

class _SearchFeildState extends State<SearchFeild> {
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 6,
      borderRadius: BorderRadius.circular(20.r),
      child: CostumTextField(
        onChanged: widget.onChanged,
        controller: widget.controller,
        width: double.infinity.sp,
        hintText: 'Search ',
        prefixIcon: Icon(
          Icons.search,
          color: AppColors.primaryColor,
          size: 30.sp,
        ),
      ),
    );
  }
}
