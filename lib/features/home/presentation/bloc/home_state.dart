import 'package:equatable/equatable.dart';
import 'package:hungry_app/features/home/domain/entities/product_entity.dart';

class HomeState extends Equatable {
  final List<ProductEntity> allProducts;
  final List<ProductEntity> filteredProducts;
  final bool isLoading;
  final String? errorMessage;

  const HomeState({
    this.allProducts = const [],
    this.filteredProducts = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  HomeState copyWith({
    List<ProductEntity>? allProducts,
    List<ProductEntity>? filteredProducts,
    bool? isLoading,
    String? errorMessage,
  }) =>
      HomeState(
        allProducts: allProducts ?? this.allProducts,
        filteredProducts: filteredProducts ?? this.filteredProducts,
        isLoading: isLoading ?? this.isLoading,
        errorMessage: errorMessage,
      );

  @override
  List<Object?> get props => [allProducts, filteredProducts, isLoading, errorMessage];
}
