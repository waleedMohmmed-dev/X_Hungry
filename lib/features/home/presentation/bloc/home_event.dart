import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class HomeInitialized extends HomeEvent {
  const HomeInitialized();
}

class ProductsSearchChanged extends HomeEvent {
  final String query;

  const ProductsSearchChanged(this.query);

  @override
  List<Object?> get props => [query];
}
