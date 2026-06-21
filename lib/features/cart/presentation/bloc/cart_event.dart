import 'package:equatable/equatable.dart';
import 'package:hungry_app/features/cart/domain/entities/cart_entity.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class CartLoaded extends CartEvent {
  const CartLoaded();
}

class CartItemAdded extends CartEvent {
  final CartRequestEntity item;

  const CartItemAdded(this.item);

  @override
  List<Object?> get props => [item];
}

class CartItemRemoved extends CartEvent {
  final int itemId;

  const CartItemRemoved(this.itemId);

  @override
  List<Object?> get props => [itemId];
}

class CartQuantityIncreased extends CartEvent {
  final int index;

  const CartQuantityIncreased(this.index);

  @override
  List<Object?> get props => [index];
}

class CartQuantityDecreased extends CartEvent {
  final int index;

  const CartQuantityDecreased(this.index);

  @override
  List<Object?> get props => [index];
}
