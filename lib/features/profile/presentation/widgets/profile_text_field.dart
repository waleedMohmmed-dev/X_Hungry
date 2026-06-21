import 'package:hungry_app/core/imports/core_imports.dart';
import 'package:hungry_app/core/imports/packages_imports.dart';
import 'package:hungry_app/core/theme/app_theme.dart';

class ProfileTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType? textInputType;

  const ProfileTextField({
    super.key,
    required this.controller,
    required this.label,
    this.textInputType,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: textInputType,
      controller: controller,
      cursorColor: AppColors.primaryColor,
      style: TextStyle(color: AppColors.primaryColor),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: AppColors.primaryColor, fontSize: 18.sp),
        hintStyle: TextStyle(color: AppColors.primaryColor, fontSize: 18.sp),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryColor, width: 1),
          borderRadius: BorderRadius.circular(15.r),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryColor, width: 1),
          borderRadius: BorderRadius.circular(15.r),
        ),
      ),
    );
  }
}
