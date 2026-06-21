import 'package:equatable/equatable.dart';
import 'package:hungry_app/features/cart/domain/entities/cart_entity.dart';

class CartState extends Equatable {
  final CartEntity? cart;
  final bool isLoading;
  final bool isRemoving;
  final List<int> quantities;
  final String? errorMessage;

  const CartState({
    this.cart,
    this.isLoading = false,
    this.isRemoving = false,
    this.quantities = const [],
    this.errorMessage,
  });

  CartState copyWith({
    CartEntity? cart,
    bool? isLoading,
    bool? isRemoving,
    List<int>? quantities,
    String? errorMessage,
  }) =>
      CartState(
        cart: cart ?? this.cart,
        isLoading: isLoading ?? this.isLoading,
        isRemoving: isRemoving ?? this.isRemoving,
        quantities: quantities ?? this.quantities,
        errorMessage: errorMessage,
      );

  @override
  List<Object?> get props => [cart, isLoading, isRemoving, quantities, errorMessage];
}
