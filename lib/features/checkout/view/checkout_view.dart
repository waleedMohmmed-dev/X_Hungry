import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hungry_app/core/constans/app_colors.dart';
import 'package:hungry_app/core/network/api_error.dart';
import 'package:hungry_app/features/auth/data/auth_repo.dart';
import 'package:hungry_app/features/auth/data/user_model.dart';
import 'package:hungry_app/features/checkout/widget/order_detail_widget.dart';
import 'package:hungry_app/features/products/widget/costum_button.dart';
import 'package:hungry_app/shared/costum_text.dart';

class CheckoutView extends StatefulWidget {
  const CheckoutView({super.key, required this.priceTotal});
  final String priceTotal;

  @override
  State<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  String selectedPayment = 'Cash';
  AuthRepo authRepo = AuthRepo();
  UserModel? userModel;

  /// get profile
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
    }
  }

  @override
  void initState() {
    getProfileData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CostumText(
                text: 'Order Summary',
                color: Colors.black,
                size: 20,
                weight: FontWeight.w500,
              ),
              Gap(10),

              OrderDetailWidget(
                order: widget.priceTotal ?? '19.99',
                taxes: '3.50',
                fees: '40.33',
                total: (double.parse(widget.priceTotal) + 3.50 + 40.33)
                    .toStringAsFixed(2),
              ),

              Gap(100),
              CostumText(
                text: 'Payment methods',
                size: 20,
                weight: FontWeight.bold,
              ),
              Gap(20),

              /// cash
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                tileColor: Color(0xff3C2F2F),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 5.h,
                  horizontal: 10.w,
                ),
                title: CostumText(
                  text: 'Cash on Delivery',
                  color: Colors.white,
                  // weight: FontWeight.,
                  size: 18,
                ),
                leading: Image.asset('assets/icons/cash.png', width: 50.w),

                trailing: Radio<String>(
                  activeColor: Colors.white,
                  value: 'Cash ',
                  groupValue: selectedPayment,
                  onChanged: (v) {
                    setState(() {
                      selectedPayment = v!;
                    });
                  },
                ),
                onTap: () {
                  setState(() {
                    selectedPayment = 'cash';
                  });
                },
              ),

              Gap(20),

              /// visa
              userModel?.visa == null
                  ? SizedBox.shrink()
                  : ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      tileColor: Colors.blue.shade900,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 5.h,
                        horizontal: 10.w,
                      ),
                      title: CostumText(
                        text: 'Debit card',
                        color: Colors.white,
                        // weight: FontWeight.bold,
                        size: 18,
                      ),
                      subtitle: CostumText(
                        text: userModel?.visa ?? '3566 **** **** 0505',
                        color: Colors.grey.shade400,

                        weight: FontWeight.w500,
                        size: 13,
                      ),
                      leading: Image.asset('assets/icons/v2.png', width: 59.w),

                      trailing: Radio<String>(
                        activeColor: Colors.white,
                        value: 'Visa ',
                        groupValue: selectedPayment,
                        onChanged: (v) {
                          setState(() {
                            selectedPayment = v!;
                          });
                        },
                      ),
                      onTap: () {
                        setState(() {
                          selectedPayment = 'Visa';
                        });
                      },
                    ),
              Gap(3),
              Row(
                children: [
                  Checkbox(
                    activeColor: Colors.red,
                    value: true,
                    onChanged: (v) {},
                  ),
                  CostumText(
                    text: 'Save card details for future ',
                    weight: FontWeight.w400,
                    size: 16.sp,
                    color: Colors.grey.shade500,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),

      // button sheet
      bottomSheet: Container(
        width: double.infinity,
        height: 126.h,
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          boxShadow: [
            BoxShadow(color: Colors.grey, blurRadius: 10, offset: Offset(0, 0)),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CostumText(text: 'Total ', size: 17, weight: FontWeight.bold),
                Gap(5),
                CostumText(
                  text:
                      '\$ ${(double.parse(widget.priceTotal) + 3.50 + 40.33).toStringAsFixed(2)}',
                  size: 23,
                ),
              ],
            ),

            CostumButton(
              buttonText: 'Pay Now',
              buttonColor: AppColors.primaryColor,
              textColor: Colors.white,

              width: 160.w,
              height: 50.h,
              raidus: 20.r,
              onTap: () {
                /// show dialog
                showDialog(
                  context: context,
                  builder: (contex) {
                    return Dialog(
                      backgroundColor: Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 0,
                          vertical: 0,
                        ),
                        child: Container(
                          width: 340.w,
                          height: 350.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: Column(
                            children: [
                              Gap(27),

                              CircleAvatar(
                                backgroundColor: AppColors.primaryColor,
                                radius: 40,
                                child: Icon(
                                  CupertinoIcons.check_mark,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                              Gap(24),

                              CostumText(
                                text: ' Success !',
                                size: 30,
                                weight: FontWeight.bold,
                                color: AppColors.primaryColor,
                              ),
                              Gap(7),
                              CostumText(
                                text:
                                    'Your payment was successful.\n A receipt for this purchase has\n  been sent to your email.  ',
                                size: 16,
                                weight: FontWeight.w500,
                                color: Colors.grey.shade500,
                              ),
                              Spacer(),
                              CostumButton(
                                buttonText: 'Close ',
                                buttonColor: AppColors.primaryColor,
                                textColor: Colors.white,

                                width: 180.w,
                                height: 50.h,
                                raidus: 13.r,
                                onTap: () {
                                  Navigator.pop(context);
                                },
                              ),
                              Gap(30),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
