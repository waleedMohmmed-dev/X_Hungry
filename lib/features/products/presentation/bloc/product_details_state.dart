import 'package:equatable/equatable.dart';
import 'package:hungry_app/features/home/domain/entities/product_entity.dart';

enum ProductDetailsStatus { initial, loading, loaded, error }

class ProductDetailsState extends Equatable {
  final ProductDetailsStatus status;
  final List<ToppingEntity> toppings;
  final List<ToppingEntity> options;
  final double spicyValue;
  final List<int> selectedToppings;
  final List<int> selectedOptions;
  final String? errorMessage;

  const ProductDetailsState({
    this.status = ProductDetailsStatus.initial,
    this.toppings = const [],
    this.options = const [],
    this.spicyValue = 0.5,
    this.selectedToppings = const [],
    this.selectedOptions = const [],
    this.errorMessage,
  });

  ProductDetailsState copyWith({
    ProductDetailsStatus? status,
    List<ToppingEntity>? toppings,
    List<ToppingEntity>? options,
    double? spicyValue,
    List<int>? selectedToppings,
    List<int>? selectedOptions,
    String? errorMessage,
  }) =>
      ProductDetailsState(
        status: status ?? this.status,
        toppings: toppings ?? this.toppings,
        options: options ?? this.options,
        spicyValue: spicyValue ?? this.spicyValue,
        selectedToppings: selectedToppings ?? this.selectedToppings,
        selectedOptions: selectedOptions ?? this.selectedOptions,
        errorMessage: errorMessage,
      );

  @override
  List<Object?> get props => [
        status,
        toppings,
        options,
        spicyValue,
        selectedToppings,
        selectedOptions,
        errorMessage,
      ];
}
