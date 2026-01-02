import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:hungry_app/core/constans/app_colors.dart';
import 'package:hungry_app/core/network/api_error.dart';
import 'package:hungry_app/features/auth/data/auth_repo.dart';
import 'package:hungry_app/features/auth/data/user_model.dart';
import 'package:hungry_app/features/auth/view/login_view.dart';
import 'package:hungry_app/features/auth/widgets/costum_textfield_profile_widget.dart';
import 'package:hungry_app/features/products/widget/costum_button.dart';
import 'package:hungry_app/shared/costum_snack.dart';
import 'package:hungry_app/shared/costum_text.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _visa = TextEditingController();

  bool isGuest = false;

  String? selectedImage;
  bool isLoadingUpdate = false;
  bool isLoadingLogout = false;
  UserModel? userModel;
  AuthRepo authRepo = AuthRepo();

  /// Auto Login
  Future<void> autoLogin() async {
    final user = await authRepo.autoLogin();
    setState(() => isGuest = authRepo.isGuest);
    if (user != null) setState(() => userModel = user);
  }

  /// get profile data
  Future<void> getProfileData() async {
    try {
      final user = await authRepo.getProfileData();
      setState(() {
        userModel = user;
      });
    } catch (e) {
      String errorMsg = 'Error in Profile';
      if (e is ApiError) {
        errorMsg = e.message;
      }
      ScaffoldMessenger.of(context).showSnackBar(customSnack(errorMsg));
    }
  }

  /// update profile
  Future<void> updateProfileData() async {
    try {
      setState(() => isLoadingUpdate = true);
      final user = await authRepo.updateProfileData(
        name: _name.text.trim(),
        email: _email.text.trim(),
        address: _address.text.trim(),
        imagePath: selectedImage,
        visa: _visa.text.trim(),
      );

      setState(() => isLoadingUpdate = false);
      setState(() => userModel = user);
      await getProfileData();
    } catch (e) {
      setState(() => isLoadingUpdate = false);
      String errorMsg = 'Failed to update profile';
      if (e is ApiError) errorMsg = e.message;
    }
  }

  /// logout
  Future<void> logout() async {
    try {
      setState(() => isLoadingLogout = true);
      await authRepo.logout();
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (c) => LoginView()),
      );
      setState(() => isLoadingLogout = false);
    } catch (e) {
      setState(() => isLoadingLogout = false);
      print(e.toString());
    }
  }

  /// pick image
  Future<void> pickImage() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedImage != null) {
      setState(() {
        selectedImage = pickedImage.path;
      });
    }
  }

  @override
  void initState() {
    autoLogin();
    getProfileData().then((v) {
      /// then mean get data is done
      _name.text = userModel?.name.toString() ?? 'Knuckles';
      _email.text = userModel?.email.toString() ?? 'Knuckles@gmail.com';
      _address.text = userModel?.address == null
          ? "55 Dubai, UAE"
          : userModel!.address!;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!isGuest) {
      return RefreshIndicator(
        displacement: 40,
        color: Colors.white,
        backgroundColor: AppColors.primaryColor,
        onRefresh: () async => await getProfileData(),
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              toolbarHeight: 0.0,
              backgroundColor: Colors.white,
              scrolledUnderElevation: 0.0,
            ),

            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: SingleChildScrollView(
                clipBehavior: Clip.none,
                child: Skeletonizer(
                  enabled: userModel == null,
                  containersColor: AppColors.primaryColor.withOpacity(0.3),
                  child: Column(
                    children: [
                      Gap(10),

                      /// topheadline
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.popUntil(
                              context,
                              (route) => route.isFirst,
                            ),
                            child: Icon(
                              Icons.arrow_back,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 0,
                            ),
                            child: Icon(CupertinoIcons.settings_solid),
                          ),
                        ],
                      ),

                      /// image
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(width: 1, color: Colors.black),
                          color: Colors.grey.shade300,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(1),
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            padding: const EdgeInsets.all(3),
                            child: Container(
                              height: 100.h,
                              width: 100.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  width: 1,
                                  color: AppColors.primaryColor,
                                ),
                                color: Colors.grey.shade100,
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: selectedImage != null
                                  ? Image.file(
                                      File(selectedImage!),
                                      fit: BoxFit.cover,
                                    )
                                  : (userModel?.image != null &&
                                        userModel!.image!.isNotEmpty)
                                  ? Image.network(
                                      userModel!.image!,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, err, builder) =>
                                          Icon(Icons.person),
                                    )
                                  : Icon(Icons.person),
                            ),
                          ),
                        ),
                      ),
                      Gap(10),

                      /// uplode && remove
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          /// upload
                          GestureDetector(
                            onTap: pickImage,
                            child: Card(
                              elevation: 0.0,
                              color: const Color.fromARGB(255, 6, 78, 13),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 30,
                                  vertical: 8,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CostumText(
                                      text: 'Upload',
                                      weight: FontWeight.w500,
                                      color: Colors.white,
                                      size: 13,
                                    ),
                                    Gap(10),
                                    Icon(
                                      CupertinoIcons.camera,
                                      size: 17,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          /// remove
                          GestureDetector(
                            onTap: pickImage,
                            child: Card(
                              elevation: 0.0,
                              color: const Color.fromARGB(255, 111, 2, 40),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 30,
                                  vertical: 8,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CostumText(
                                      text: 'Remove',
                                      weight: FontWeight.w500,
                                      color: Colors.white,
                                      size: 13,
                                    ),
                                    Gap(10),
                                    Icon(
                                      CupertinoIcons.trash,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Gap(20),

                      /// Form
                      CostumTextfieldProfileWidget(
                        controller: _name,
                        label: 'Name',
                      ),
                      Gap(25),
                      CostumTextfieldProfileWidget(
                        controller: _email,
                        label: 'Email',
                      ),
                      Gap(25),
                      CostumTextfieldProfileWidget(
                        controller: _address,
                        label: 'Address',
                      ),
                      Gap(20),
                      Divider(),
                      Gap(10),

                      /// visa card
                      userModel?.visa == null
                          ? CostumTextfieldProfileWidget(
                              controller: _visa,
                              textInputType: TextInputType.number,
                              label: 'add VISA CARD',
                            )
                          : Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 15,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.blue.shade900,
                                    Colors.blue.shade900,
                                    Colors.blue.shade500,
                                    Colors.blue.shade900,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Image.asset(
                                    'assets/icons/visa_card.png',
                                    width: 50.w,
                                    color: Colors.white,
                                  ),
                                  Gap(20),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CostumText(
                                        text: 'Debit Card',
                                        color: Colors.white,
                                        size: 14,
                                      ),
                                      CostumText(
                                        text:
                                            userModel?.visa ??
                                            "**** **** **** 9857",
                                        color: Colors.white,
                                        size: 12,
                                      ),
                                    ],
                                  ),

                                  Spacer(),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(40),
                                    ),
                                    child: CostumText(
                                      text: 'Default',
                                      color: Colors.grey.shade800,
                                      size: 12,
                                      weight: FontWeight.w500,
                                    ),
                                  ),
                                  Gap(8),
                                  Icon(
                                    CupertinoIcons.check_mark_circled_solid,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),

                      Gap(5),

                      SizedBox(
                        height: 70.h,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            /// Edit
                            Expanded(
                              child: GestureDetector(
                                onTap: updateProfileData,
                                child: Container(
                                  height: 50.h,
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: isLoadingUpdate
                                      ? CupertinoActivityIndicator(
                                          color: Colors.white,
                                        )
                                      : Center(
                                          child: CostumText(
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

                            /// logout
                            Expanded(
                              child: GestureDetector(
                                onTap: logout,
                                child: Container(
                                  height: 50.h,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: AppColors.primaryColor,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: isLoadingLogout
                                      ? CupertinoActivityIndicator(
                                          color: AppColors.primaryColor,
                                        )
                                      : Center(
                                          child: CostumText(
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
                      ),
                      Gap(300),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    } else if (isGuest) {
      return Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(child: Text('Guest Mode')),
            Gap(20),
            CostumButton(
              onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (c) => LoginView()),
              ),
              buttonText: 'Go to Login',
            ),
          ],
        ),
      );
    }
    return SizedBox();
  }
}
