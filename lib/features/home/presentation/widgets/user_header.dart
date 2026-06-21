import 'package:hungry_app/core/imports/core_imports.dart';
import 'package:hungry_app/core/imports/packages_imports.dart';
import 'package:hungry_app/core/theme/app_theme.dart';
import 'package:hungry_app/core/shared/widgets/app_text.dart';
import 'package:hungry_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:hungry_app/features/auth/presentation/bloc/auth_state.dart';

class UserHeaderWidget extends StatelessWidget {
  const UserHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      buildWhen: (prev, curr) => prev.user != curr.user,
      builder: (context, state) {
        final userName = state.user?.name ?? 'Guest';
        final userImage = state.user?.image ??
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS5TPu3HoTZkTyxzVY6h3fuKo-nPU85G5u4Vw&s';
        return Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  'assets/logo/Hungry_.svg',
                  colorFilter: ColorFilter.mode(AppColors.primaryColor, BlendMode.srcIn),
                  height: 40.h,
                ),
                Gap(5),
                AppText(
                  text: userName,
                  color: Colors.grey,
                  weight: FontWeight.w400,
                  size: 18,
                ),
              ],
            ),
            const Spacer(),
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 34,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.network(
                  userImage,
                  width: 100.w,
                  height: 120.h,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
