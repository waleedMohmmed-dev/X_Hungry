import 'package:dartz/dartz.dart';
import 'package:hungry_app/core/failure.dart';
import 'package:hungry_app/features/home/domain/entities/product_entity.dart';

abstract class FavoriteRepository {
  Future<Either<Failure, String>> toggleFavorite(int productId);
  Future<Either<Failure, List<ProductEntity>>> getFavorites();
}
