import 'package:hungry_app/core/imports/core_imports.dart';
import 'package:hungry_app/core/imports/packages_imports.dart';
import 'package:hungry_app/core/theme/app_theme.dart';
import 'package:hungry_app/core/shared/widgets/app_text.dart';
import 'package:hungry_app/features/products/presentation/bloc/product_details_bloc.dart';
import 'package:hungry_app/features/products/presentation/bloc/product_details_event.dart';
import 'package:hungry_app/features/products/presentation/bloc/product_details_state.dart';
import 'package:hungry_app/features/products/presentation/widgets/slider_widget.dart';
import 'package:hungry_app/features/products/presentation/widgets/selectable_items_list.dart';
import 'package:hungry_app/features/products/presentation/widgets/product_bottom_sheet.dart';

class ProductsDetailsPage extends StatefulWidget {
  final int productId;
  final String productImage;
  final String productPrice;

  const ProductsDetailsPage({
    super.key,
    required this.productId,
    required this.productImage,
    required this.productPrice,
  });

  @override
  State<ProductsDetailsPage> createState() => _ProductsDetailsPageState();
}

class _ProductsDetailsPageState extends State<ProductsDetailsPage> {
  @override
  void initState() {
    super.initState();
    context.read<ProductDetailsBloc>().add(const ProductDetailsInitialized());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductDetailsBloc, ProductDetailsState>(
      buildWhen: (prev, curr) => prev.status != curr.status,
      builder: (context, state) {
        final isLoading =
            state.status == ProductDetailsStatus.loading ||
            state.status == ProductDetailsStatus.initial;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            scrolledUnderElevation: 0,
            elevation: 0,
          ),
          body: isLoading
              ? const Center(child: CupertinoActivityIndicator())
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Image.network(widget.productImage, width: 160.w),
                            const Spacer(),
                            Column(
                              children: [
                                AppText(
                                  text:
                                      'Customize Your Burger \nto Your Tastes. Ultimate \nExperience',
                                  weight: FontWeight.w500,
                                  size: 14,
                                ),
                                BlocBuilder<ProductDetailsBloc, ProductDetailsState>(
                                  buildWhen: (prev, curr) => prev.spicyValue != curr.spicyValue,
                                  builder: (context, state) => SliderWidget(
                                    value: state.spicyValue,
                                    onChanged: (v) =>
                                        context.read<ProductDetailsBloc>().add(SpicyChanged(value: v)),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    const AppText(text: 'Cold 🥶'),
                                    Gap(60),
                                    const AppText(text: ' 🌶️Hot '),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        Gap(10),
                        AppText(
                          text: 'Topings',
                          size: 20.sp,
                          weight: FontWeight.bold,
                        ),
                        Gap(10),
                        BlocBuilder<ProductDetailsBloc, ProductDetailsState>(
                          buildWhen: (prev, curr) =>
                              prev.selectedToppings != curr.selectedToppings,
                          builder: (context, state) => SelectableItemsList(
                            items: state.toppings,
                            selectedIds: state.selectedToppings,
                            addButtonColor: Colors.red,
                            onToggle: (id) =>
                                context.read<ProductDetailsBloc>().add(ToppingToggled(id: id)),
                          ),
                        ),
                        Gap(10),
                        AppText(
                          text: 'Side Options',
                          size: 20.sp,
                          weight: FontWeight.bold,
                        ),
                        Gap(10),
                        BlocBuilder<ProductDetailsBloc, ProductDetailsState>(
                          buildWhen: (prev, curr) =>
                              prev.selectedOptions != curr.selectedOptions,
                          builder: (context, state) => SelectableItemsList(
                            items: state.options,
                            selectedIds: state.selectedOptions,
                            addButtonColor: AppColors.primaryColor,
                            onToggle: (id) =>
                                context.read<ProductDetailsBloc>().add(OptionToggled(id: id)),
                          ),
                        ),
                        Gap(120),
                        Gap(200),
                      ],
                    ),
                  ),
                ),
          bottomSheet: BlocBuilder<ProductDetailsBloc, ProductDetailsState>(
            buildWhen: (prev, curr) =>
                prev.spicyValue != curr.spicyValue ||
                prev.selectedToppings != curr.selectedToppings ||
                prev.selectedOptions != curr.selectedOptions,
            builder: (context, state) => ProductBottomSheet(
              productId: widget.productId,
              productPrice: widget.productPrice,
              spicy: state.spicyValue,
              toppings: state.selectedToppings,
              options: state.selectedOptions,
            ),
          ),
        );
      },
    );
  }
}
