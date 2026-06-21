import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:hungry_app/core/failure.dart';
import 'package:hungry_app/core/usecase.dart';
import 'package:hungry_app/features/home/domain/entities/product_entity.dart';
import 'package:hungry_app/features/home/domain/repositories/product_repository.dart';

class SearchProductsUseCase implements UseCase<List<ProductEntity>, SearchParams> {
  final ProductRepository repository;

  SearchProductsUseCase(this.repository);

  @override
  Future<Either<Failure, List<ProductEntity>>> call(SearchParams params) {
    return repository.searchProducts(params.name);
  }
}

class SearchParams extends Equatable {
  final String name;

  const SearchParams({required this.name});

  @override
  List<Object?> get props => [name];
}
