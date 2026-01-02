import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:hungry_app/core/constans/app_colors.dart';
import 'package:hungry_app/core/network/api_error.dart';
import 'package:hungry_app/features/auth/data/auth_repo.dart';
import 'package:hungry_app/features/auth/view/signup_view.dart';
import 'package:hungry_app/root.dart';
import 'package:hungry_app/shared/costum_button.dart';
import 'package:hungry_app/shared/costum_snack.dart';

import 'package:hungry_app/shared/costum_text.dart';
import 'package:hungry_app/shared/costum_textfeild.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isLoding = false;

  final AuthRepo authRepo = AuthRepo();

  /// login
  Future<void> login() async {
    if (formKey.currentState!.validate()) {
      setState(() => isLoding = true);

      try {
        final user = await authRepo.login(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );

        if (user != null) {
          Navigator.push(context, MaterialPageRoute(builder: (c) => Root()));
        }

        setState(() => isLoding = false);
      } catch (e) {
        setState(() => isLoding = false);
        String errorMsg = 'unhanddled error in login';

        if (e is ApiError) {
          errorMsg = e.message;
        }

        /// show error message
        ScaffoldMessenger.of(context).showSnackBar(customSnack(errorMsg));
      }
    }
  }

  @override
  void initState() {
    _emailController.text = 'waleed@gmail.com';
    _passwordController.text = '1234567890';
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
    return PopScope(
      canPop: false,

      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Expanded(
            child: Center(
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Gap(200),

                    //Top Headline
                    SvgPicture.asset(
                      'assets/logo/Hungry_.svg',
                      color: AppColors.primaryColor,
                    ),
                    Gap(7),
                    Center(
                      child: CostumText(
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
                            CostumTextField(
                              controller: _emailController,

                              hintText: 'Email Address',
                              validator: (v) {
                                if (v == null || v.isEmpty) {
                                  return 'please fill the email ';
                                }
                              },
                            ),
                            Gap(15),
                            CostumTextField(
                              controller: _passwordController,
                              suffixIcon: Icon(
                                CupertinoIcons.eye,
                                color: AppColors.primaryColor,
                              ),
                              isPassword: true,

                              hintText: 'Enter Your Password',
                              validator: (v) {
                                if (v == null || v.isEmpty) {
                                  return 'please fill the password ';
                                }
                              },
                            ),
                            Gap(30),

                            // login  bottom
                            isLoding
                                ? CupertinoActivityIndicator(
                                    color: Colors.white,
                                  )
                                : CostumButton(
                                    buttonText: 'Login',

                                    width: 355.w,
                                    buttonColor: Colors.transparent,
                                    textColor: Colors.white,

                                    onTap: login,
                                  ),

                            /// go to sign up
                            Gap(19),

                            CostumButton(
                              buttonText: 'Create Account ?',
                              buttonColor: Colors.white,
                              textColor: AppColors.primaryColor,

                              width: 355.w,

                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (e) {
                                      return SignupView();
                                    },
                                  ),
                                );
                              },
                            ),
                            Gap(20),

                            GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (c) {
                                      return Root();
                                    },
                                  ),
                                );
                              },
                              child: CostumText(
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
          ),
        ),
      ),
    );
  }
}
