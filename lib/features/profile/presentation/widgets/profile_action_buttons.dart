import 'package:hungry_app/core/imports/core_imports.dart';
import 'package:hungry_app/core/imports/packages_imports.dart';
import 'package:hungry_app/core/theme/app_theme.dart';
import 'package:hungry_app/core/shared/widgets/app_text.dart';
import 'package:hungry_app/features/auth/presentation/pages/login_page.dart';
import 'package:hungry_app/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:hungry_app/features/profile/presentation/bloc/profile_event.dart';

class ProfileActionButtons extends StatelessWidget {
  final bool isSubmitting;
  final String name;
  final String email;
  final String address;
  final String? selectedImage;
  final String visa;

  const ProfileActionButtons({
    super.key,
    required this.isSubmitting,
    required this.name,
    required this.email,
    required this.address,
    this.selectedImage,
    required this.visa,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                context.read<ProfileBloc>().add(
                  ProfileUpdateRequested(
                    name: name,
                    email: email,
                    address: address,
                    imagePath: selectedImage,
                    visa: visa,
                  ),
                );
              },
              child: Container(
                height: 50.h,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: isSubmitting
                    ? const CupertinoActivityIndicator(color: Colors.white)
                    : Center(
                        child: AppText(
                          text: 'Edit Profile',
                          weight: FontWeight.w600,
                          color: Colors.white,
                          size: 15.sp,
                        ),
                      ),
              ),
            ),
          ),
          Gap(10),
          Expanded(
            child: GestureDetector(
              onTap: () {
                context.read<ProfileBloc>().add(const ProfileLogoutRequested());
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                );
              },
              child: Container(
                height: 50.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: AppColors.primaryColor),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: isSubmitting
                    ? CupertinoActivityIndicator(color: AppColors.primaryColor)
                    : Center(
                        child: AppText(
                          text: 'Logout',
                          weight: FontWeight.w600,
                          color: AppColors.primaryColor,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
