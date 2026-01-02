import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:gap/gap.dart';
import 'package:hungry_app/core/constans/app_colors.dart';
import 'package:hungry_app/core/network/api_error.dart';
import 'package:hungry_app/features/auth/data/auth_repo.dart';
import 'package:hungry_app/features/auth/data/user_model.dart';
import 'package:hungry_app/features/home/data/models/product_model.dart';
import 'package:hungry_app/features/home/data/repo/product_repo.dart';
import 'package:hungry_app/features/home/widget/card_widget.dart';

import 'package:hungry_app/features/home/widget/categories_widget.dart';

import 'package:hungry_app/features/products/view/products_datails_view.dart';

import 'package:hungry_app/features/home/widget/search_feild.dart';
import 'package:hungry_app/features/home/widget/user_header.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  ProductRepo productRepo = ProductRepo();

  List<ProductModel>? products;
  List<ProductModel>? allProducts;
  bool isLoading = false;
  UserModel? userModel;
  AuthRepo authRepo = AuthRepo();
  final TextEditingController _searchController = TextEditingController();

  /// get products
  Future<void> getProducts() async {
    final res = await productRepo.getProducts();
    setState(() {
      allProducts = res;
      products = res;
    });
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
      // ScaffoldMessenger.of(context).showSnackBar(customSnack(errorMsg));
    }
  }

  @override
  void initState() {
    getProfileData();
    getProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      displacement: 70,
      color: Colors.white,
      backgroundColor: AppColors.primaryColor,
      onRefresh: () => getProfileData(),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Skeletonizer(
          enabled: products == null,

          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black12,
              toolbarHeight: 0,
              scrolledUnderElevation: 0.0,
            ),
            backgroundColor: Colors.white,
            body: products == null || isLoading
                ? Center(child: CupertinoActivityIndicator())
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Gap(30),

                          /// header
                          UserHeader(
                            userName: userModel?.name ?? 'Waleed',
                            userImage:
                                userModel?.image ??
                                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS5TPu3HoTZkTyxzVY6h3fuKo-nPU85G5u4Vw&s',
                          ),
                          Gap(17),

                          /// search
                          SearchFeild(
                            controller: _searchController,

                            onChanged: (value) {
                              /// Search by Logic
                              final query = value.toLowerCase();
                              setState(() {
                                products = allProducts
                                    ?.where(
                                      (p) => p.name.toLowerCase().startsWith(
                                        query,
                                      ),
                                    )
                                    .toList();
                              });
                            },
                          ),
                          Gap(25),

                          /// categories
                          CategoriesWidget(),

                          Gap(20),

                          /// GridView widget
                          GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            itemCount: products!.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.70,
                                  mainAxisSpacing: 1,
                                ),
                            itemBuilder: (context, index) {
                              final product = products?[index];

                              if (product == null) {
                                return CupertinoActivityIndicator();
                              }

                              return GestureDetector(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (c) => ProductsDetailsView(
                                      /// send data to next page
                                      productId: product.id,
                                      productImage: product.image,

                                      productPrice: product.price,
                                    ),
                                  ),
                                ),
                                child: CardWidget(
                                  image: product.image,
                                  text: product.name,
                                  desc: product.desc,
                                  rate: product.rate,
                                ),
                              );
                            },
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
