import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:hungry_app/core/failure.dart';
import 'package:hungry_app/core/network/api_error.dart';
import 'package:hungry_app/features/favorites/data/datasources/favorite_remote_data_source.dart';
import 'package:hungry_app/features/favorites/domain/repositories/favorite_repository.dart';
import 'package:hungry_app/features/home/domain/entities/product_entity.dart';

class FavoriteRepositoryImpl implements FavoriteRepository {
  final FavoriteRemoteDataSource _remoteDataSource;

  FavoriteRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, String>> toggleFavorite(int productId) async {
    try {
      final res = await _remoteDataSource.toggleFavorite(productId);
      return Right(res['message'] as String);
    } on ApiError catch (e) {
      return Left(ServerFailure(e.message));
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Network error'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getFavorites() async {
    try {
      final models = await _remoteDataSource.getFavorites();
      return Right(models.map((m) => m.toEntity()).toList());
    } on ApiError catch (e) {
      return Left(ServerFailure(e.message));
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Network error'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
