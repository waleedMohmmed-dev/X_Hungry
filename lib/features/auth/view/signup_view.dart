import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:hungry_app/core/constans/app_colors.dart';
import 'package:hungry_app/core/network/api_error.dart';
import 'package:hungry_app/features/auth/data/auth_repo.dart';
import 'package:hungry_app/features/auth/view/login_view.dart';
import 'package:hungry_app/features/products/widget/costum_button.dart';
import 'package:hungry_app/root.dart';
import 'package:hungry_app/shared/costum_snack.dart';

import 'package:hungry_app/shared/costum_text.dart';
import 'package:hungry_app/shared/costum_textfeild.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final AuthRepo authRepo = AuthRepo();

  Future<void> singUp() async {
    if (_formKey.currentState!.validate()) {
      try {
        final user = await authRepo.signup(
          _nameController.text.trim(),
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );

        if (user != null) {
          Navigator.push(context, MaterialPageRoute(builder: (c) => Root()));
        }
      } catch (e) {
        String errorMsg = ' Error in Register';

        if (e is ApiError) {
          errorMsg = e.message;
        }

        /// snackbar
        ScaffoldMessenger.of(context).showSnackBar(customSnack(errorMsg));
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();

    _passwordController.dispose();
    _nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Gap(130),
                SvgPicture.asset(
                  'assets/logo/Hungry_.svg',
                  color: AppColors.primaryColor,
                ),
                Gap(5),
                CostumText(
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
                        CostumTextField(
                          controller: _nameController,
                          width: 355.w,
                          hintText: 'Enter Your Name ',
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return 'please fill the email ';
                            }
                          },
                        ),
                        Gap(20),
                        CostumTextField(
                          controller: _emailController,

                          width: 355.w,
                          hintText: 'Enter Your Email',
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return 'Please Enter Your Email ';
                            }
                          },
                        ),
                        Gap(20),
                        CostumTextField(
                          controller: _passwordController,
                          isPassword: true,

                          hintText: 'Enter Your Passwored  ',
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return 'Please Enter Your Password';
                            }
                          },
                        ),

                        Gap(40),
                        CostumButton(
                          onTap: singUp,

                          buttonText: 'Sing Up',
                          buttonColor: Colors.transparent,
                          textColor: Colors.white,
                        ),
                        // go to login
                        Gap(25),

                        CostumButton(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (c) {
                                  return LoginView();
                                },
                              ),
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
        ),
      ),
    );
  }
}
