import 'package:hungry_app/core/imports/core_imports.dart';
import 'package:hungry_app/core/imports/packages_imports.dart';
import 'package:hungry_app/core/theme/app_theme.dart';
import 'package:hungry_app/core/shared/widgets/app_button.dart';
import 'package:hungry_app/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:hungry_app/features/cart/presentation/bloc/cart_event.dart';
import 'package:hungry_app/features/cart/presentation/bloc/cart_state.dart';
import 'package:hungry_app/features/cart/presentation/widgets/cart_item_widget.dart';
import 'package:hungry_app/features/checkout/presentation/pages/checkout_page.dart';
import 'package:hungry_app/features/auth/presentation/pages/login_page.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();
    context.read<CartBloc>().add(const CartLoaded());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      buildWhen: (prev, curr) =>
          prev.cart != curr.cart ||
          prev.isLoading != curr.isLoading ||
          prev.isRemoving != curr.isRemoving ||
          prev.quantities != curr.quantities,
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final cart = state.cart;
        if (cart == null || cart.items.isEmpty) {
          return _buildGuestMode(context);
        }

        return RefreshIndicator(
          displacement: 80,
          color: Colors.white,
          backgroundColor: AppColors.primaryColor,
          onRefresh: () async {
            context.read<CartBloc>().add(const CartLoaded());
          },
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: const Center(child: Text('My Cart', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20))),
              scrolledUnderElevation: 0,
              toolbarHeight: 20,
            ),
            backgroundColor: Colors.white,
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 40),
                itemCount: cart.items.length,
                itemBuilder: (context, index) {
                  final item = cart.items[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: CartItemWidget(
                      isLoading: state.isRemoving,
                      image: item.image,
                      text: item.name,
                      des: 'Spicy ${item.spicy}',
                      number: state.quantities.length > index ? state.quantities[index] : 1,
                      onAdd: () => context.read<CartBloc>().add(CartQuantityIncreased(index)),
                      onMinus: () => context.read<CartBloc>().add(CartQuantityDecreased(index)),
                      onRemove: () {
                        context.read<CartBloc>().add(CartItemRemoved(item.itemId));
                      },
                    ),
                  );
                },
              ),
            ),
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
                boxShadow: [BoxShadow(blurRadius: 14, color: Colors.grey.shade800)],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Total', style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w500)),
                      Text('\$${cart.totalPrice}', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  AppButton(
                    buttonText: 'Checkout',
                    buttonColor: AppColors.primaryColor,
                    textColor: Colors.white,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CheckoutPage(priceTotal: cart.totalPrice),
                        ),
                      );
                    },
                    width: 160.w,
                    height: 50.h,
                    borderRadius: 20.r,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildGuestMode(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(child: Text('Guest Mode')),
          const Gap(20),
          AppButton(
            onTap: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LoginPage()),
            ),
            buttonText: 'Go to Login',
          ),
        ],
      ),
    );
  }
}
