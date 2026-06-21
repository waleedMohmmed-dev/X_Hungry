import 'package:hungry_app/core/imports/core_imports.dart';
import 'package:hungry_app/core/imports/packages_imports.dart';
import 'package:hungry_app/core/theme/app_theme.dart';

class AppButton extends StatelessWidget {
  final String? buttonText;
  final Color? buttonColor;
  final double? width;
  final double? height;
  final double? borderRadius;
  final double? side;
  final Color? textColor;
  final double? fontSize;
  final void Function()? onTap;
  final Widget? icon;
  final Widget? trailingIcon;
  final bool isLoading;
  final double? gap;

  const AppButton({
    super.key,
    this.buttonText,
    this.buttonColor,
    this.side,
    this.width,
    this.height,
    this.borderRadius,
    this.fontSize,
    this.textColor,
    this.onTap,
    this.icon,
    this.trailingIcon,
    this.isLoading = false,
    this.gap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor ?? AppColors.primaryColor,
        shape: RoundedRectangleBorder(
          side: side != null
              ? BorderSide(color: Color(side!.toInt()), width: 1)
              : BorderSide.none,
          borderRadius: BorderRadius.circular(borderRadius ?? 8.r),
        ),
        fixedSize: Size(width ?? 331.w, height ?? 56.h),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            icon!,
            Gap(gap ?? 8.w),
          ],
          Text(
            buttonText ?? "",
            style: TextStyle(
              color: textColor ?? cs.onPrimary,
              fontWeight: FontWeight.w500,
              fontSize: fontSize ?? 16.sp,
            ),
          ),
          if (trailingIcon != null) ...[
            Gap(gap ?? 8.w),
            trailingIcon!,
          ],
        ],
      ),
    );
  }
}
