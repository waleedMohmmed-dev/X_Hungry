import 'package:hungry_app/core/imports/core_imports.dart';
import 'package:hungry_app/core/imports/packages_imports.dart';
import 'package:hungry_app/core/injection/injection.dart';
import 'package:hungry_app/core/theme/app_theme.dart';
import 'package:hungry_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:hungry_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:hungry_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:hungry_app/features/auth/presentation/pages/login_page.dart';
import 'package:hungry_app/core/shared/widgets/app_text.dart';
import 'package:hungry_app/core/shared/widgets/app_text_field.dart';
import 'package:hungry_app/core/shared/widgets/app_button.dart';
import 'package:hungry_app/core/shared/widgets/app_snack_bar.dart';
import 'package:hungry_app/root.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthBloc>(),
      child: PopScope(
        canPop: false,
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
                return Center(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Gap(130),
                        SvgPicture.asset('assets/logo/Hungry_.svg', colorFilter: ColorFilter.mode(AppColors.primaryColor, BlendMode.srcIn)),
                        Gap(5),
                        AppText(
                          text: 'Welcom to  Hungry App Ago!',
                          color: AppColors.primaryColor,
                          size: 17.sp,
                          weight: FontWeight.w700,
                        ),
                        Gap(70),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(20.r),
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
                                  controller: _nameController,
                                  width: 355.w,
                                  hintText: 'Enter Your Name ',
                                  validator: (v) {
                                    if (v == null || v.isEmpty) return 'please fill the email ';
                                    return null;
                                  },
                                ),
                                Gap(20),
                                AppTextField(
                                  controller: _emailController,
                                  width: 355.w,
                                  hintText: 'Enter Your Email',
                                  validator: (v) {
                                    if (v == null || v.isEmpty) return 'Please Enter Your Email ';
                                    return null;
                                  },
                                ),
                                Gap(20),
                                AppTextField(
                                  controller: _passwordController,
                                  isPassword: true,
                                  hintText: 'Enter Your Passwored  ',
                                  validator: (v) {
                                    if (v == null || v.isEmpty) return 'Please Enter Your Password';
                                    return null;
                                  },
                                ),
                                Gap(40),
                                AppButton(
                                  onTap: () {
                                    if (_formKey.currentState!.validate()) {
                                      context.read<AuthBloc>().add(
                                        SignupSubmitted(
                                          name: _nameController.text.trim(),
                                          email: _emailController.text.trim(),
                                          password: _passwordController.text.trim(),
                                        ),
                                      );
                                    }
                                  },
                                  buttonText: 'Sing Up',
                                  buttonColor: Colors.transparent,
                                  textColor: Colors.white,
                                ),
                                Gap(25),
                                AppButton(
                                  onTap: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (_) => const LoginPage()),
                                    );
                                  },
                                  buttonColor: Colors.white,
                                  textColor: AppColors.primaryColor,
                                  buttonText: 'Go To Login ?',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
