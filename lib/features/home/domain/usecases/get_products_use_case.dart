import 'package:dartz/dartz.dart';
import 'package:hungry_app/core/failure.dart';
import 'package:hungry_app/core/usecase.dart';
import 'package:hungry_app/features/home/domain/entities/product_entity.dart';
import 'package:hungry_app/features/home/domain/repositories/product_repository.dart';

class GetProductsUseCase implements UseCase<List<ProductEntity>, NoParams> {
  final ProductRepository repository;

  GetProductsUseCase(this.repository);

  @override
  Future<Either<Failure, List<ProductEntity>>> call(NoParams params) {
    return repository.getProducts();
  }
}
