import 'dart:io';

import 'package:hungry_app/core/imports/core_imports.dart';
import 'package:hungry_app/core/imports/packages_imports.dart';
import 'package:hungry_app/core/theme/app_theme.dart';
import 'package:hungry_app/features/auth/domain/entities/user_entity.dart';

class ProfileAvatar extends StatelessWidget {
  final UserEntity? user;
  final String? selectedImage;

  const ProfileAvatar({
    super.key,
    this.user,
    this.selectedImage,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = user?.image;
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(width: 1, color: Colors.black),
        color: Colors.grey.shade300,
      ),
      child: Padding(
        padding: const EdgeInsets.all(1),
        child: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          padding: const EdgeInsets.all(3),
          child: Container(
            height: 100.h,
            width: 100.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(width: 1, color: AppColors.primaryColor),
              color: Colors.grey.shade100,
            ),
            clipBehavior: Clip.antiAlias,
            child: selectedImage != null
                ? Image.file(File(selectedImage!), fit: BoxFit.cover)
                : (imageUrl != null && imageUrl.isNotEmpty)
                    ? Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(Icons.person),
                      )
                    : const Icon(Icons.person),
          ),
        ),
      ),
    );
  }
}
