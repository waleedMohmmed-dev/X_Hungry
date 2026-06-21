import 'package:equatable/equatable.dart';
import 'package:hungry_app/features/home/domain/entities/product_entity.dart';

class FavoriteState extends Equatable {
  final Set<int> favoriteIds;
  final List<ProductEntity> favoriteProducts;
  final bool isLoading;
  final String? errorMessage;

  const FavoriteState({
    this.favoriteIds = const {},
    this.favoriteProducts = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  FavoriteState copyWith({
    Set<int>? favoriteIds,
    List<ProductEntity>? favoriteProducts,
    bool? isLoading,
    String? errorMessage,
  }) =>
      FavoriteState(
        favoriteIds: favoriteIds ?? this.favoriteIds,
        favoriteProducts: favoriteProducts ?? this.favoriteProducts,
        isLoading: isLoading ?? this.isLoading,
        errorMessage: errorMessage ?? this.errorMessage,
      );

  @override
  List<Object?> get props => [favoriteIds, favoriteProducts, isLoading, errorMessage];
}
