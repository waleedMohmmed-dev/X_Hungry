import 'package:hungry_app/core/imports/core_imports.dart';
import 'package:hungry_app/core/imports/packages_imports.dart';
import 'package:hungry_app/core/injection/injection.dart';
import 'package:hungry_app/core/theme/app_theme.dart';
import 'package:hungry_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:hungry_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:hungry_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:hungry_app/features/auth/presentation/pages/signup_page.dart';
import 'package:hungry_app/core/shared/widgets/app_text.dart';
import 'package:hungry_app/core/shared/widgets/app_text_field.dart';
import 'package:hungry_app/core/shared/widgets/app_button.dart';
import 'package:hungry_app/core/shared/widgets/app_snack_bar.dart';
import 'package:hungry_app/root.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _emailController.text = 'wellltext@gmail.com';
    _passwordController.text = '22222222';
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthBloc>()..add(const AutoLoginRequested()),
      child: PopScope(
        canPop: false,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            backgroundColor: Colors.white,
            body: BlocListener<AuthBloc, AuthState>(
              listenWhen: (prev, curr) =>
                  prev.errorMessage != curr.errorMessage ||
                  prev.user != curr.user,
              listener: (context, state) {
                if (state.errorMessage != null) {
                  ScaffoldMessenger.of(context).showSnackBar(appSnackBar(state.errorMessage!));
                }
                if (state.user != null) {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const Root()));
                }
              },
              child: BlocBuilder<AuthBloc, AuthState>(
                buildWhen: (prev, curr) => prev.isLoading != curr.isLoading,
                builder: (context, state) {
                  return Expanded(
                    child: Center(
                      child: Form(
                        key: formKey,
                        child: Column(
                          children: [
                            Gap(200),
                            SvgPicture.asset('assets/logo/Hungry_.svg', colorFilter: ColorFilter.mode(AppColors.primaryColor, BlendMode.srcIn)),
                            Gap(7),
                            Center(
                              child: AppText(
                                text: 'Welcome Back Discover The Fast Food ',
                                color: AppColors.primaryColor,
                                weight: FontWeight.w500,
                                size: 17.sp,
                              ),
                            ),
                            Gap(90),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.all(20.w),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30.r),
                                    topRight: Radius.circular(30.r),
                                  ),
                                  color: AppColors.primaryColor,
                                ),
                                child: Column(
                                  children: [
                                    Gap(30),
                                    AppTextField(
                                      controller: _emailController,
                                      hintText: 'Email Address',
                                      validator: (v) {
                                        if (v == null || v.isEmpty) return 'please fill the email ';
                                        return null;
                                      },
                                    ),
                                    Gap(15),
                                    AppTextField(
                                      controller: _passwordController,
                                      suffixIcon: Icon(
                                        CupertinoIcons.eye,
                                        color: AppColors.primaryColor,
                                      ),
                                      isPassword: true,
                                      hintText: 'Enter Your Password',
                                      validator: (v) {
                                        if (v == null || v.isEmpty) return 'please fill the password ';
                                        return null;
                                      },
                                    ),
                                    Gap(30),
                                    state.isLoading
                                        ? const CupertinoActivityIndicator(color: Colors.white)
                                        : AppButton(
                                            buttonText: 'Login',
                                            width: 355.w,
                                            buttonColor: Colors.transparent,
                                            textColor: Colors.white,
                                            onTap: () {
                                              if (formKey.currentState!.validate()) {
                                                context.read<AuthBloc>().add(
                                                  LoginSubmitted(
                                                    email: _emailController.text.trim(),
                                                    password: _passwordController.text.trim(),
                                                  ),
                                                );
                                              }
                                            },
                                          ),
                                    Gap(19),
                                    AppButton(
                                      buttonText: 'Create Account ?',
                                      buttonColor: Colors.white,
                                      textColor: AppColors.primaryColor,
                                      width: 355.w,
                                      onTap: () {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(builder: (_) => const SignupPage()),
                                        );
                                      },
                                    ),
                                    Gap(20),
                                    GestureDetector(
                                      onTap: () {
                                        context.read<AuthBloc>().add(const GuestLoginRequested());
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(builder: (_) => const Root()),
                                        );
                                      },
                                      child: AppText(
                                        text: 'Continue as a guest ?',
                                        size: 15.sp,
                                        color: Colors.orange,
                                        weight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
