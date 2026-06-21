import 'package:equatable/equatable.dart';

abstract class FavoriteEvent extends Equatable {
  const FavoriteEvent();

  @override
  List<Object?> get props => [];
}

class FavoritesRequested extends FavoriteEvent {
  const FavoritesRequested();
}

class FavoriteToggled extends FavoriteEvent {
  final int productId;

  const FavoriteToggled(this.productId);

  @override
  List<Object?> get props => [productId];
}
