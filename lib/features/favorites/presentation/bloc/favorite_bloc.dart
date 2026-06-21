import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungry_app/core/usecase.dart';
import 'package:hungry_app/features/favorites/domain/usecases/get_favorites_use_case.dart';
import 'package:hungry_app/features/favorites/domain/usecases/toggle_favorite_use_case.dart';
import 'package:hungry_app/features/favorites/presentation/bloc/favorite_event.dart';
import 'package:hungry_app/features/favorites/presentation/bloc/favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final ToggleFavoriteUseCase _toggleFavoriteUseCase;
  final GetFavoritesUseCase _getFavoritesUseCase;

  FavoriteBloc({
    required ToggleFavoriteUseCase toggleFavoriteUseCase,
    required GetFavoritesUseCase getFavoritesUseCase,
  })  : _toggleFavoriteUseCase = toggleFavoriteUseCase,
        _getFavoritesUseCase = getFavoritesUseCase,
        super(const FavoriteState()) {
    on<FavoritesRequested>(_onFavoritesRequested);
    on<FavoriteToggled>(_onFavoriteToggled);
  }

  Future<void> _onFavoritesRequested(
    FavoritesRequested event,
    Emitter<FavoriteState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final result = await _getFavoritesUseCase(const NoParams());

    result.fold(
      (failure) => emit(state.copyWith(
        isLoading: false,
        errorMessage: failure.message,
      )),
      (products) => emit(state.copyWith(
        isLoading: false,
        favoriteProducts: products,
        favoriteIds: products.map((p) => p.id).toSet(),
      )),
    );
  }

  Future<void> _onFavoriteToggled(
    FavoriteToggled event,
    Emitter<FavoriteState> emit,
  ) async {
    final previousIds = Set<int>.from(state.favoriteIds);
    final isCurrentlyFavorite = previousIds.contains(event.productId);

    if (isCurrentlyFavorite) {
      previousIds.remove(event.productId);
    } else {
      previousIds.add(event.productId);
    }
    emit(state.copyWith(favoriteIds: previousIds));

    final result = await _toggleFavoriteUseCase(
      ToggleFavoriteParams(productId: event.productId),
    );

    result.fold(
      (failure) {
        final reverted = Set<int>.from(state.favoriteIds);
        if (isCurrentlyFavorite) {
          reverted.add(event.productId);
        } else {
          reverted.remove(event.productId);
        }
        emit(state.copyWith(
          favoriteIds: reverted,
          errorMessage: failure.message,
        ));
      },
      (_) {
        if (isCurrentlyFavorite) {
          final updatedProducts = state.favoriteProducts
              .where((p) => p.id != event.productId)
              .toList();
          emit(state.copyWith(favoriteProducts: updatedProducts));
        } else {
          add(const FavoritesRequested());
        }
      },
    );
  }
}
