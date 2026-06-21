import 'package:hungry_app/core/imports/core_imports.dart';
import 'package:hungry_app/core/imports/packages_imports.dart';
import 'package:hungry_app/core/injection/injection.dart';
import 'package:hungry_app/core/theme/app_theme.dart';
import 'package:hungry_app/features/home/presentation/bloc/home_bloc.dart';
import 'package:hungry_app/features/home/presentation/bloc/home_event.dart';
import 'package:hungry_app/features/home/presentation/bloc/home_state.dart';
import 'package:hungry_app/features/home/presentation/widgets/user_header.dart';
import 'package:hungry_app/features/home/presentation/widgets/search_field.dart';
import 'package:hungry_app/features/home/presentation/widgets/categories_widget.dart';
import 'package:hungry_app/features/favorites/presentation/bloc/favorite_bloc.dart';
import 'package:hungry_app/features/favorites/presentation/bloc/favorite_event.dart';
import 'package:hungry_app/features/favorites/presentation/bloc/favorite_state.dart';
import 'package:hungry_app/features/home/presentation/widgets/card_widget.dart';
import 'package:hungry_app/features/products/presentation/bloc/product_details_bloc.dart';
import 'package:hungry_app/features/products/presentation/pages/products_details_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(const HomeInitialized());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (prev, curr) =>
          prev.isLoading != curr.isLoading ||
          prev.filteredProducts != curr.filteredProducts,
      builder: (context, state) {
        return RefreshIndicator(
          displacement: 70,
          color: Colors.white,
          backgroundColor: AppColors.primaryColor,
          onRefresh: () async {
            context.read<HomeBloc>().add(const HomeInitialized());
          },
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Skeletonizer(
              enabled: state.isLoading,
              child: Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.black12,
                  toolbarHeight: 0,
                  scrolledUnderElevation: 0,
                ),
                backgroundColor: Colors.white,
                body: state.isLoading
                    ? const Center(child: CupertinoActivityIndicator())
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Gap(30),
                              const UserHeaderWidget(),
                              Gap(17),
                              SearchField(
                                controller: _searchController,
                                onChanged: (value) {
                                  context.read<HomeBloc>().add(ProductsSearchChanged(value));
                                },
                              ),
                              Gap(25),
                              const CategoriesWidget(),
                              Gap(20),
                              GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.zero,
                                itemCount: state.filteredProducts.length,
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.70,
                                  mainAxisSpacing: 1,
                                ),
                                itemBuilder: (context, index) {
                                  final product = state.filteredProducts[index];
                                  return GestureDetector(
                                    onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => BlocProvider(
                                          create: (_) => sl<ProductDetailsBloc>(),
                                          child: ProductsDetailsPage(
                                            productId: product.id,
                                            productImage: product.image,
                                            productPrice: product.price,
                                          ),
                                        ),
                                      ),
                                    ),
                                    child: BlocBuilder<FavoriteBloc, FavoriteState>(
                                      builder: (context, favState) {
                                        final isFav = favState.favoriteIds.contains(product.id);
                                        return CardWidget(
                                          image: product.image,
                                          text: product.name,
                                          desc: product.desc,
                                          rate: product.rate,
                                          isFavorite: isFav,
                                          onFavoriteToggle: () {
                                            context.read<FavoriteBloc>().add(
                                              FavoriteToggled(product.id),
                                            );
                                          },
                                        );
                                      },
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
      },
    );
  }
}
