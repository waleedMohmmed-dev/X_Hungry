import 'package:dartz/dartz.dart';
import 'package:hungry_app/core/failure.dart';
import 'package:hungry_app/core/usecase.dart';
import 'package:hungry_app/features/home/domain/entities/product_entity.dart';
import 'package:hungry_app/features/home/domain/repositories/product_repository.dart';

class GetToppingsUseCase implements UseCase<List<ToppingEntity>, NoParams> {
  final ProductRepository repository;

  GetToppingsUseCase(this.repository);

  @override
  Future<Either<Failure, List<ToppingEntity>>> call(NoParams params) {
    return repository.getToppings();
  }
}
