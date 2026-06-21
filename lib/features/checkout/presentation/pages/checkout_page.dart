import 'package:hungry_app/core/imports/core_imports.dart';
import 'package:hungry_app/core/imports/packages_imports.dart';
import 'package:hungry_app/core/theme/app_theme.dart';
import 'package:hungry_app/core/shared/widgets/app_text.dart';
import 'package:hungry_app/features/checkout/presentation/widgets/order_detail_widget.dart';

class CheckoutPage extends StatefulWidget {
  final String priceTotal;

  const CheckoutPage({super.key, required this.priceTotal});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String selectedPayment = 'Cash';

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
              AppText(
                text: 'Order Summary',
                color: Colors.black,
                size: 20,
                weight: FontWeight.w500,
              ),
              Gap(10),
              OrderDetailWidget(
                order: widget.priceTotal,
                taxes: '3.50',
                fees: '40.33',
                total: (double.parse(widget.priceTotal) + 3.50 + 40.33).toStringAsFixed(2),
              ),
              Gap(100),
              AppText(text: 'Payment methods', size: 20, weight: FontWeight.bold),
              Gap(20),
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                tileColor: const Color(0xff3C2F2F),
                contentPadding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
                title: AppText(text: 'Cash on Delivery', color: Colors.white, size: 18),
                leading: Image.asset('assets/icons/cash.png', width: 50.w),
                trailing: Radio<String>(
                  activeColor: Colors.white,
                  value: 'Cash ',
                  groupValue: selectedPayment,
                  onChanged: (v) => setState(() => selectedPayment = v!),
                ),
                onTap: () => setState(() => selectedPayment = 'cash'),
              ),
              Gap(20),
              Gap(3),
              Row(
                children: [
                  Checkbox(
                    activeColor: Colors.red,
                    value: true,
                    onChanged: (v) {},
                  ),
                  AppText(
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
      bottomSheet: Container(
        width: double.infinity,
        height: 126.h,
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          boxShadow: [
            BoxShadow(color: Colors.grey, blurRadius: 10, offset: const Offset(0, 0)),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(text: 'Total ', size: 17, weight: FontWeight.bold),
                Gap(5),
                AppText(
                  text: '\$ ${(double.parse(widget.priceTotal) + 3.50 + 40.33).toStringAsFixed(2)}',
                  size: 23,
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) {
                    return Dialog(
                      backgroundColor: Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
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
                                child: const Icon(
                                  CupertinoIcons.check_mark,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                              Gap(24),
                              AppText(
                                text: ' Success !',
                                size: 30,
                                weight: FontWeight.bold,
                                color: AppColors.primaryColor,
                              ),
                              Gap(7),
                              AppText(
                                text: 'Your payment was successful.\n A receipt for this purchase has\n  been sent to your email.  ',
                                size: 16,
                                weight: FontWeight.w500,
                                color: Colors.grey.shade500,
                              ),
                              const Spacer(),
                              ElevatedButton(
                                onPressed: () => Navigator.pop(context),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(13.r),
                                  ),
                                  fixedSize: Size(180.w, 50.h),
                                ),
                                child: const Text('Close ', style: TextStyle(color: Colors.white)),
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
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r),
                ),
                fixedSize: Size(160.w, 50.h),
              ),
              child: const Text('Pay Now', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
