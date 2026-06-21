import 'package:hungry_app/core/imports/core_imports.dart';
import 'package:hungry_app/core/imports/packages_imports.dart';
import 'package:hungry_app/core/theme/app_theme.dart';
import 'package:hungry_app/features/auth/presentation/widgets/app_styling.dart';

class CategoryChip extends StatelessWidget {
  final String categoryName;
  final VoidCallback? onTap;
  final bool isSelected;

  const CategoryChip({
    super.key,
    required this.categoryName,
    this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () {},
      child: Padding(
        padding: EdgeInsetsDirectional.only(end: 8.w),
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 7.h),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryColor : const Color(0xFFF3F4F6),
            border: isSelected
                ? null
                : Border.all(color: const Color(0xffF3F4F6), width: 0.5.w),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Text(
            categoryName,
            style: AppStyles.black16w500Style.copyWith(
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
