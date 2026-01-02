import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hungry_app/core/constans/app_colors.dart';
import 'package:hungry_app/core/network/api_error.dart';
import 'package:hungry_app/features/cart/data/cart_model.dart';
import 'package:hungry_app/features/cart/data/cart_repo.dart';
import 'package:hungry_app/features/home/data/models/toppings_model.dart';
import 'package:hungry_app/features/home/data/repo/product_repo.dart';
import 'package:hungry_app/features/products/widget/costum_button.dart';
import 'package:hungry_app/features/products/widget/toppings_widget.dart';
import 'package:hungry_app/features/products/widget/slider_widget.dart';
import 'package:hungry_app/shared/costum_text.dart';

import '../../cart/data/cart_model.dart' show CartModel;

class ProductsDetailsView extends StatefulWidget {
  const ProductsDetailsView({
    super.key,
    required this.productId,
    required this.productImage,
    required this.productPrice,
  });
  final String productImage;
  final int productId;
  final String productPrice;

  @override
  State<ProductsDetailsView> createState() => _ProductsDetailsViewState();
}

class _ProductsDetailsViewState extends State<ProductsDetailsView> {
  double value = 0.5;

  List<int> selectedToppings = [];
  List<int> selectedOptions = [];

  List<ToppingModel>? toppings;
  List<ToppingModel>? options;
  bool isLoding = false;
  ProductRepo productRepo = ProductRepo();

  /// get Toppings
  Future<void> getToppings() async {
    final res = await productRepo.getToppings();
    setState(() {
      toppings = res;
    });
  }

  /// get options
  Future<void> getOptions() async {
    final res = await productRepo.getOptions();
    setState(() {
      options = res;
    });
  }

  /// cart method
  CartRepo cartRepo = CartRepo();
  @override
  void initState() {
    getToppings();
    getOptions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        elevation: 0,
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.network(widget.productImage, width: 160.w),
                  Spacer(),
                  Column(
                    children: [
                      CostumText(
                        text:
                            'Customize Your Burger \nto Your Tastes. Ultimate \nExperience',
                        weight: FontWeight.w500,
                        size: 14,
                      ),

                      // slider
                      SliderWidget(
                        value: value,

                        onChanged: (v) {
                          setState(() {
                            value = v;
                          });
                        },
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CostumText(text: 'Cold 🥶'),
                          Gap(60),
                          CostumText(text: ' 🌶️Hot '),
                        ],
                      ),
                    ],
                  ),
                ],
              ),

              Gap(10),
              CostumText(text: 'Topings', size: 20.sp, weight: FontWeight.bold),
              Gap(10),

              ///TOPPINGS
              SingleChildScrollView(
                clipBehavior: Clip.none,
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(toppings?.length ?? 4, (index) {
                    final topping = toppings?[index];

                    final id = topping?.id ?? 1;
                    if (topping == null) {
                      return CupertinoActivityIndicator();
                    }
                    final isSelcted = selectedToppings.contains(id);

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ToppingsWidget(
                        downColor: isSelcted
                            ? AppColors.primaryColor.withOpacity(0.3)
                            : Colors.black,
                        addButtonColor: Colors.red,
                        image: topping.image,
                        text: topping.name,
                        onAdd: () {
                          /// selected topping
                          setState(() {
                            if (isSelcted) {
                              selectedToppings.remove(id);
                            } else {
                              selectedToppings.add(id);
                            }
                          });
                        },
                      ),
                    );
                  }),
                ),
              ),

              Gap(10),
              CostumText(
                text: 'Side Options',
                size: 20.sp,
                weight: FontWeight.bold,
              ),
              Gap(10),

              /// SIDE OPTIONS
              SingleChildScrollView(
                clipBehavior: Clip.none,
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(options?.length ?? 4, (index) {
                    final option = options?[index];

                    final id = option?.id ?? 1;

                    if (option == null) {
                      return CupertinoActivityIndicator();
                    }

                    final isSelcted = selectedOptions.contains(id);

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ToppingsWidget(
                        downColor: isSelcted
                            ? AppColors.primaryColor.withOpacity(0.3)
                            : Colors.black,
                        addButtonColor: AppColors.primaryColor,
                        text: option.name,
                        image: option.image,
                        onAdd: () {
                          // selected option
                          setState(() {
                            if (isSelcted) {
                              selectedOptions.remove(id);
                            } else {
                              selectedOptions.add(id);
                            }
                          });
                        },
                      ),
                    );
                  }),
                ),
              ),
              Gap(120),

              Gap(200),
            ],
          ),
        ),
      ),

      /// bottom sheet
      bottomSheet: Container(
        width: double.infinity,
        height: 110.h,
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
                CostumText(
                  text: 'Total price',
                  size: 17.sp,
                  weight: FontWeight.w500,
                ),
                Gap(5),
                CostumText(
                  text: '\$ ${widget.productPrice}' ?? '0.0',
                  size: 25.sp,
                  weight: FontWeight.bold,
                ),
              ],
            ),

            /// add to cart button
            CostumButton(
              widget: isLoding
                  ? CupertinoActivityIndicator(color: Colors.white)
                  : Icon(
                      CupertinoIcons.cart_badge_plus,
                      size: 24.sp,
                      color: Colors.white,
                    ),
              gap: 20,
              buttonText: 'Add To Cart',
              buttonColor: AppColors.primaryColor,
              textColor: Colors.white,

              width: 200.w,
              height: 50.h,
              raidus: 20.r,
              onTap: () async {
                /// add to cart logic
                setState(() => isLoding = true);

                try {
                  final cartItem = CartModel(
                    productId: widget.productId,
                    qty: 1,
                    spicy: value,
                    toppings: selectedToppings,
                    options: selectedOptions,
                  );
                  await cartRepo.addToCart(CartRequestModel(items: [cartItem]));

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      behavior: SnackBarBehavior.floating,
                      clipBehavior: Clip.none,
                      content: Row(
                        children: [
                          Icon(CupertinoIcons.info, color: Colors.white),
                          Gap(30),
                          CostumText(
                            color: Colors.red.shade900,
                            weight: FontWeight.w700,
                            size: 14.sp,
                            text: 'Item Added To Cart Successfully',
                          ),
                        ],
                      ),
                    ),
                  );

                  setState(() => isLoding = false);
                } catch (e) {
                  setState(() => isLoding = false);
                  throw ApiError(message: e.toString());
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
