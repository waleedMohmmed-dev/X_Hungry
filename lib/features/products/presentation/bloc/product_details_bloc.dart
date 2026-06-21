import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungry_app/core/usecase.dart';
import 'package:hungry_app/features/home/domain/entities/product_entity.dart';
import 'package:hungry_app/features/home/domain/usecases/get_options_use_case.dart';
import 'package:hungry_app/features/home/domain/usecases/get_toppings_use_case.dart';
import 'package:hungry_app/features/products/presentation/bloc/product_details_event.dart';
import 'package:hungry_app/features/products/presentation/bloc/product_details_state.dart';

class ProductDetailsBloc extends Bloc<ProductDetailsEvent, ProductDetailsState> {
  final GetToppingsUseCase _getToppingsUseCase;
  final GetOptionsUseCase _getOptionsUseCase;

  ProductDetailsBloc({
    required GetToppingsUseCase getToppingsUseCase,
    required GetOptionsUseCase getOptionsUseCase,
  })  : _getToppingsUseCase = getToppingsUseCase,
        _getOptionsUseCase = getOptionsUseCase,
        super(const ProductDetailsState()) {
    on<ProductDetailsInitialized>(_onInitialized);
    on<SpicyChanged>(_onSpicyChanged);
    on<ToppingToggled>(_onToppingToggled);
    on<OptionToggled>(_onOptionToggled);
  }

  Future<void> _onInitialized(
    ProductDetailsInitialized event,
    Emitter<ProductDetailsState> emit,
  ) async {
    emit(state.copyWith(status: ProductDetailsStatus.loading));

    final toppingsResult = await _getToppingsUseCase(const NoParams());
    final optionsResult = await _getOptionsUseCase(const NoParams());

    final toppings = toppingsResult.fold((_) => <ToppingEntity>[], (data) => data);
    final options = optionsResult.fold((_) => <ToppingEntity>[], (data) => data);

    if (toppingsResult.isLeft() && optionsResult.isLeft()) {
      emit(state.copyWith(
        status: ProductDetailsStatus.error,
        errorMessage: toppingsResult.fold((f) => f.message, (_) => null),
      ));
    } else {
      emit(state.copyWith(
        status: ProductDetailsStatus.loaded,
        toppings: toppings,
        options: options,
      ));
    }
  }

  void _onSpicyChanged(
    SpicyChanged event,
    Emitter<ProductDetailsState> emit,
  ) {
    emit(state.copyWith(spicyValue: event.value));
  }

  void _onToppingToggled(
    ToppingToggled event,
    Emitter<ProductDetailsState> emit,
  ) {
    final id = event.id;
    final updated = List<int>.from(state.selectedToppings);
    if (updated.contains(id)) {
      updated.remove(id);
    } else {
      updated.add(id);
    }
    emit(state.copyWith(selectedToppings: updated));
  }

  void _onOptionToggled(
    OptionToggled event,
    Emitter<ProductDetailsState> emit,
  ) {
    final id = event.id;
    final updated = List<int>.from(state.selectedOptions);
    if (updated.contains(id)) {
      updated.remove(id);
    } else {
      updated.add(id);
    }
    emit(state.copyWith(selectedOptions: updated));
  }
}
