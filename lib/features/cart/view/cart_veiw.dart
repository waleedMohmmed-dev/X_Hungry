import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hungry_app/core/constans/app_colors.dart';
import 'package:hungry_app/features/auth/data/auth_repo.dart';
import 'package:hungry_app/features/auth/data/user_model.dart';
import 'package:hungry_app/features/auth/view/login_view.dart';
import 'package:hungry_app/features/cart/data/cart_model.dart';
import 'package:hungry_app/features/cart/data/cart_repo.dart';

import 'package:hungry_app/features/cart/widget/cart_item_widget.dart';
import 'package:hungry_app/features/checkout/view/checkout_view.dart';
import 'package:hungry_app/shared/costum_button.dart';
import 'package:hungry_app/shared/costum_text.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CartVeiw extends StatefulWidget {
  const CartVeiw({super.key});

  @override
  State<CartVeiw> createState() => _CartVeiwState();
}

class _CartVeiwState extends State<CartVeiw> {
  late List<int> quantitiys;

  GetCartResponse? cartResponse;
  UserModel? userModel;
  AuthRepo authRepo = AuthRepo();
  CartRepo cartRepo = CartRepo();
  bool isLoding = false;
  bool isLodingRemove = false;
  bool isGuest = false;

  /// get cart
  Future<void> getCartData() async {
    try {
      if (!mounted) return;
      setState(() => isLoding = true);

      final res = await cartRepo.getCartData();
      if (!mounted) return;
      final itemCount = res?.cartData.items.length;
      setState(() {
        cartResponse = res;
        quantitiys = List.generate(itemCount!, (_) => 1);
        isLoding = false;
      });
    } catch (e) {
      if (!mounted) return setState(() => isLoding = false);
      print(e.toString());
    }
  }

  /// delete from cart
  Future<void> removeCartItem(int id) async {
    try {
      setState(() => isLodingRemove = true);

      await cartRepo.removeCartItem(id);
      getCartData();
      setState(() => isLodingRemove = false);
    } catch (e) {
      print(e.toString());
      setState(() => isLodingRemove = false);
    }
  }

  /// auto login
  Future<void> autoLogin() async {
    final user = await authRepo.autoLogin();
    setState(() => isGuest = authRepo.isGuest);
    if (user != null) setState(() => userModel = user);
  }

  @override
  void initState() {
    getCartData();
    autoLogin();
    super.initState();
  }

  void onAdd(int index) {
    setState(() {
      quantitiys[index]++;
    });
  }

  void onMinus(int index) {
    setState(() {
      if (quantitiys[index] > 1) {
        quantitiys[index]--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!isGuest) {
      return Skeletonizer(
        enabled: cartResponse == null,
        child: RefreshIndicator(
          displacement: 80,
          color: Colors.white,
          backgroundColor: AppColors.primaryColor,
          onRefresh: () => getCartData(),
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: Center(
                child: const CostumText(
                  text: 'My Cart',
                  color: Colors.black,
                  weight: FontWeight.bold,
                  size: 20,
                ),
              ),

              scrolledUnderElevation: 0,
              toolbarHeight: 20,
            ),
            backgroundColor: Colors.white,

            body: isLoding
                ? Center(child: CupertinoActivityIndicator())
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: ListView.builder(
                      padding: EdgeInsets.only(top: 40),
                      itemCount: cartResponse?.cartData.items.length ?? 0,
                      itemBuilder: (context, index) {
                        final item = cartResponse!.cartData.items[index];

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),

                          child: CartItemWidget(
                            isLoding: isLodingRemove,
                            image: item.image,
                            text: item.name,
                            des: 'Spicy ${item.spicy}',
                            number: quantitiys[index],
                            onAdd: () => onAdd(index),
                            onMinus: () => onMinus(index),
                            onRemove: () => removeCartItem(item.itemId),
                          ),
                        );
                      },
                    ),
                  ),

            /// bottomSheet
            bottomSheet: Container(
              width: double.infinity,
              height: 90.h,
              padding: EdgeInsets.all(20.r),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.r),
                  topRight: Radius.circular(30.r),
                ),
                boxShadow: [
                  BoxShadow(blurRadius: 14, color: Colors.grey.shade800),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CostumText(
                        text: 'Total',
                        size: 17.sp,
                        weight: FontWeight.w500,
                      ),

                      CostumText(
                        text:
                            '\$${cartResponse?.cartData.totalPrice}' ?? '0.00',

                        size: 20.sp,
                        weight: FontWeight.bold,
                      ),
                    ],
                  ),
                  CostumButton(
                    buttonText: 'Checkout',
                    buttonColor: AppColors.primaryColor,
                    textColor: Colors.white,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (c) => CheckoutView(
                            priceTotal:
                                cartResponse?.cartData.totalPrice ?? '1',
                          ),
                        ),
                      );
                    },
                    width: 160.w,
                    height: 50.h,
                    bordersRadius: 20.r,
                  ),
                ],
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

    return Container();
  }
}
