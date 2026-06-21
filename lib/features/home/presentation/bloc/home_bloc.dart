import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungry_app/core/usecase.dart';
import 'package:hungry_app/features/home/domain/usecases/get_products_use_case.dart';
import 'package:hungry_app/features/home/presentation/bloc/home_event.dart';
import 'package:hungry_app/features/home/presentation/bloc/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetProductsUseCase _getProductsUseCase;

  HomeBloc({
    required GetProductsUseCase getProductsUseCase,
  })  : _getProductsUseCase = getProductsUseCase,
        super(const HomeState()) {
    on<HomeInitialized>(_onHomeInitialized);
    on<ProductsSearchChanged>(_onSearchChanged);
  }

  Future<void> _onHomeInitialized(
    HomeInitialized event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final result = await _getProductsUseCase(const NoParams());

    result.fold(
      (failure) => emit(state.copyWith(
        isLoading: false,
        errorMessage: failure.message,
      )),
      (products) => emit(state.copyWith(
        isLoading: false,
        allProducts: products,
        filteredProducts: products,
      )),
    );
  }

  void _onSearchChanged(
    ProductsSearchChanged event,
    Emitter<HomeState> emit,
  ) {
    final query = event.query.toLowerCase();
    if (query.isEmpty) {
      emit(state.copyWith(filteredProducts: state.allProducts));
    } else {
      emit(state.copyWith(
        filteredProducts: state.allProducts
            .where((p) => p.name.toLowerCase().startsWith(query))
            .toList(),
      ));
    }
  }
}
