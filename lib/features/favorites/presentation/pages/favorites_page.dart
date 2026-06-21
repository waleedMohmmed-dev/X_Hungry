import 'package:hungry_app/core/imports/core_imports.dart';
import 'package:hungry_app/core/imports/packages_imports.dart';
import 'package:hungry_app/core/injection/injection.dart';
import 'package:hungry_app/core/shared/widgets/app_text.dart';
import 'package:hungry_app/core/theme/app_theme.dart';
import 'package:hungry_app/features/favorites/presentation/bloc/favorite_bloc.dart';
import 'package:hungry_app/features/favorites/presentation/bloc/favorite_event.dart';
import 'package:hungry_app/features/favorites/presentation/bloc/favorite_state.dart';
import 'package:hungry_app/features/home/presentation/widgets/card_widget.dart';
import 'package:hungry_app/features/products/presentation/bloc/product_details_bloc.dart';
import 'package:hungry_app/features/products/presentation/pages/products_details_page.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        toolbarHeight: 0,
      ),
      body: BlocBuilder<FavoriteBloc, FavoriteState>(
        builder: (context, state) {
          if (state.isLoading && state.favoriteProducts.isEmpty) {
            return const Center(child: CupertinoActivityIndicator());
          }
          return RefreshIndicator(
            displacement: 70,
            color: Colors.white,
            backgroundColor: AppColors.primaryColor,
            onRefresh: () async {
              context.read<FavoriteBloc>().add(const FavoritesRequested());
            },
            child: state.favoriteProducts.isEmpty
                ? ListView(
                    children: [
                      SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                      Center(
                        child: AppText(
                          text: 'No favorites yet',
                          size: 16.sp,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: GridView.builder(
                      padding: const EdgeInsets.only(top: 30, bottom: 120),
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: state.favoriteProducts.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.70,
                        mainAxisSpacing: 1,
                      ),
                      itemBuilder: (context, index) {
                        final product = state.favoriteProducts[index];
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
                          child: CardWidget(
                            image: product.image,
                            text: product.name,
                            desc: product.desc,
                            rate: product.rate,
                            isFavorite: state.favoriteIds.contains(product.id),
                            onFavoriteToggle: () {
                              context.read<FavoriteBloc>().add(FavoriteToggled(product.id));
                            },
                          ),
                        );
                      },
                    ),
                  ),
          );
        },
      ),
    );
  }
}
