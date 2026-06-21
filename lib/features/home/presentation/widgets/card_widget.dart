import 'package:hungry_app/core/imports/core_imports.dart';
import 'package:hungry_app/core/imports/packages_imports.dart';
import 'package:hungry_app/core/theme/app_theme.dart';
import 'package:hungry_app/core/shared/widgets/app_text.dart';

class CardWidget extends StatelessWidget {
  final String image, desc, rate, text;
  final bool isFavorite;
  final VoidCallback? onFavoriteToggle;

  const CardWidget({
    super.key,
    required this.image,
    required this.desc,
    required this.rate,
    required this.text,
    this.isFavorite = false,
    this.onFavoriteToggle,
  });

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
            AppText(
              text: text,
              color: AppColors.primaryColor,
              weight: FontWeight.bold,
              size: 14.sp,
            ),
            AppText(
              maxLines: 2,
              text: desc,
              color: Colors.grey.shade700,
              weight: FontWeight.w500,
              size: 10.sp,
            ),
            Gap(6),
            Row(
              children: [
                AppText(
                  text: '⭐ $rate',
                  weight: FontWeight.w500,
                  size: 14.sp,
                  color: AppColors.primaryColor,
                ),
                const Spacer(),
                GestureDetector(
                  onTap: onFavoriteToggle,
                  child: Icon(
                    isFavorite ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                    color: isFavorite ? Colors.red : AppColors.primaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
