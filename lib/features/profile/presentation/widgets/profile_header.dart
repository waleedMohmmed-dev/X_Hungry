import 'package:hungry_app/core/imports/core_imports.dart';
import 'package:hungry_app/core/theme/app_theme.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () => Navigator.popUntil(context, (route) => route.isFirst),
          child: Icon(Icons.arrow_back, color: AppColors.primaryColor),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
          child: Icon(CupertinoIcons.settings_solid),
        ),
      ],
    );
  }
}
