import 'package:equatable/equatable.dart';

abstract class ProductDetailsEvent extends Equatable {
  const ProductDetailsEvent();

  @override
  List<Object?> get props => [];
}

class ProductDetailsInitialized extends ProductDetailsEvent {
  const ProductDetailsInitialized();
}

class SpicyChanged extends ProductDetailsEvent {
  final double value;

  const SpicyChanged({required this.value});

  @override
  List<Object?> get props => [value];
}

class ToppingToggled extends ProductDetailsEvent {
  final int id;

  const ToppingToggled({required this.id});

  @override
  List<Object?> get props => [id];
}

class OptionToggled extends ProductDetailsEvent {
  final int id;

  const OptionToggled({required this.id});

  @override
  List<Object?> get props => [id];
}
