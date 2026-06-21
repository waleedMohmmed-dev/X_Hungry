import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungry_app/core/usecase.dart';
import 'package:hungry_app/features/cart/domain/usecases/add_to_cart_use_case.dart';
import 'package:hungry_app/features/cart/domain/usecases/get_cart_use_case.dart';
import 'package:hungry_app/features/cart/domain/usecases/remove_cart_item_use_case.dart';
import 'package:hungry_app/features/cart/presentation/bloc/cart_event.dart';
import 'package:hungry_app/features/cart/presentation/bloc/cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final GetCartUseCase _getCartUseCase;
  final AddToCartUseCase _addToCartUseCase;
  final RemoveCartItemUseCase _removeCartItemUseCase;

  CartBloc({
    required GetCartUseCase getCartUseCase,
    required AddToCartUseCase addToCartUseCase,
    required RemoveCartItemUseCase removeCartItemUseCase,
  })  : _getCartUseCase = getCartUseCase,
        _addToCartUseCase = addToCartUseCase,
        _removeCartItemUseCase = removeCartItemUseCase,
        super(const CartState()) {
    on<CartLoaded>(_onCartLoaded);
    on<CartItemAdded>(_onCartItemAdded);
    on<CartItemRemoved>(_onCartItemRemoved);
    on<CartQuantityIncreased>(_onQuantityIncreased);
    on<CartQuantityDecreased>(_onQuantityDecreased);
  }

  Future<void> _onCartLoaded(
    CartLoaded event,
    Emitter<CartState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final result = await _getCartUseCase(const NoParams());

    result.fold(
      (failure) => emit(state.copyWith(
        isLoading: false,
        errorMessage: failure.message,
      )),
      (cart) => emit(state.copyWith(
        isLoading: false,
        cart: cart,
        quantities: List.generate(cart.items.length, (_) => 1),
      )),
    );
  }

  Future<void> _onCartItemAdded(
    CartItemAdded event,
    Emitter<CartState> emit,
  ) async {
    final result = await _addToCartUseCase(AddToCartParams(item: event.item));
    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (_) => add(const CartLoaded()),
    );
  }

  Future<void> _onCartItemRemoved(
    CartItemRemoved event,
    Emitter<CartState> emit,
  ) async {
    emit(state.copyWith(isRemoving: true));

    final result = await _removeCartItemUseCase(RemoveCartParams(itemId: event.itemId));

    result.fold(
      (failure) => emit(state.copyWith(
        isRemoving: false,
        errorMessage: failure.message,
      )),
      (_) {
        add(const CartLoaded());
        emit(state.copyWith(isRemoving: false));
      },
    );
  }

  void _onQuantityIncreased(
    CartQuantityIncreased event,
    Emitter<CartState> emit,
  ) {
    final quantities = List<int>.from(state.quantities);
    quantities[event.index]++;
    emit(state.copyWith(quantities: quantities));
  }

  void _onQuantityDecreased(
    CartQuantityDecreased event,
    Emitter<CartState> emit,
  ) {
    final quantities = List<int>.from(state.quantities);
    if (quantities[event.index] > 1) {
      quantities[event.index]--;
    }
    emit(state.copyWith(quantities: quantities));
  }
}
