import 'package:hungry_app/core/imports/core_imports.dart';
import 'package:hungry_app/core/imports/packages_imports.dart';
import 'package:hungry_app/core/shared/widgets/app_text.dart';

class ProfileImageActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color backgroundColor;
  final VoidCallback onTap;

  const ProfileImageActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.backgroundColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 0,
        color: backgroundColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppText(
                text: label,
                weight: FontWeight.w500,
                color: Colors.white,
                size: 13,
              ),
              Gap(10),
              Icon(icon, size: 17, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
