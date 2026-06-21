import 'package:hungry_app/core/imports/core_imports.dart';
import 'package:hungry_app/core/imports/packages_imports.dart';
import 'package:hungry_app/core/theme/app_theme.dart';
import 'package:hungry_app/core/shared/widgets/app_text.dart';
import 'package:hungry_app/features/cart/domain/entities/cart_entity.dart';
import 'package:hungry_app/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:hungry_app/features/cart/presentation/bloc/cart_event.dart';

class ProductBottomSheet extends StatelessWidget {
  final int productId;
  final String productPrice;
  final double spicy;
  final List<int> toppings;
  final List<int> options;

  const ProductBottomSheet({
    super.key,
    required this.productId,
    required this.productPrice,
    required this.spicy,
    required this.toppings,
    required this.options,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 110.h,
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 10,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                text: 'Total price',
                size: 17.sp,
                weight: FontWeight.w500,
              ),
              Gap(5),
              AppText(
                text: '\$ $productPrice',
                size: 25.sp,
                weight: FontWeight.bold,
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              final cartItem = CartRequestEntity(
                productId: productId,
                qty: 1,
                spicy: spicy,
                toppings: toppings,
                options: options,
              );
              context.read<CartBloc>().add(CartItemAdded(cartItem));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  clipBehavior: Clip.none,
                  content: Row(
                    children: [
                      const Icon(CupertinoIcons.info, color: Colors.white),
                      Gap(30),
                      AppText(
                        color: Colors.red.shade900,
                        weight: FontWeight.w700,
                        size: 14.sp,
                        text: 'Item Added To Cart Successfully',
                      ),
                    ],
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
              fixedSize: Size(200.w, 50.h),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  CupertinoIcons.cart_badge_plus,
                  size: 24,
                  color: Colors.white,
                ),
                Gap(20),
                Text(
                  'Add To Cart',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
