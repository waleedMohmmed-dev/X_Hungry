import 'package:dartz/dartz.dart';
import 'package:hungry_app/core/failure.dart';
import 'package:hungry_app/core/usecase.dart';
import 'package:hungry_app/features/favorites/domain/repositories/favorite_repository.dart';
import 'package:hungry_app/features/home/domain/entities/product_entity.dart';

class GetFavoritesUseCase implements UseCase<List<ProductEntity>, NoParams> {
  final FavoriteRepository repository;

  GetFavoritesUseCase(this.repository);

  @override
  Future<Either<Failure, List<ProductEntity>>> call(NoParams params) {
    return repository.getFavorites();
  }
}
