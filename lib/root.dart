import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hungry_app/core/theme/app_theme.dart';
import 'package:hungry_app/features/favorites/presentation/pages/favorites_page.dart';
import 'package:hungry_app/features/home/presentation/pages/home_page.dart';
import 'package:hungry_app/features/cart/presentation/pages/cart_page.dart';
import 'package:hungry_app/features/orderHistory/presentation/pages/order_history_page.dart';
import 'package:hungry_app/features/profile/presentation/pages/profile_page.dart';

class Root extends StatefulWidget {
  const Root({super.key});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  int currentScreen = 0;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
          body: IndexedStack(
            index: currentScreen,
            children: const [
              HomePage(),
              CartPage(),
              FavoritesPage(),
              OrderHistoryPage(),
              ProfilePage(),
            ],
          ),
          bottomNavigationBar: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: BottomNavigationBar(
              currentIndex: currentScreen,
              onTap: (index) {
                setState(() => currentScreen = index);
              },
              elevation: 0,
              backgroundColor: AppColors.primaryColor,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.grey.shade500,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.cart),
                  label: 'Cart',
                ),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.heart),
                  label: 'Favorites',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.local_restaurant_sharp),
                  label: 'Order History',
                ),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.person),
                  label: 'Profile',
                ),
              ],
            ),
          ),
        ),
      );
  }
}
