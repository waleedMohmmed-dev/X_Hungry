import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:hungry_app/core/failure.dart';
import 'package:hungry_app/core/network/api_error.dart';
import 'package:hungry_app/features/home/data/datasources/product_remote_data_source.dart';
import 'package:hungry_app/features/home/domain/entities/product_entity.dart';
import 'package:hungry_app/features/home/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource _remoteDataSource;

  ProductRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<ProductEntity>>> getProducts() async {
    try {
      final models = await _remoteDataSource.getProducts();
      return Right(models.map((m) => m.toEntity()).toList());
    } on ApiError catch (e) {
      return Left(ServerFailure(e.message));
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Network error'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ToppingEntity>>> getToppings() async {
    try {
      final models = await _remoteDataSource.getToppings();
      return Right(models.map((m) => m.toEntity()).toList());
    } on ApiError catch (e) {
      return Left(ServerFailure(e.message));
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Network error'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ToppingEntity>>> getOptions() async {
    try {
      final models = await _remoteDataSource.getOptions();
      return Right(models.map((m) => m.toEntity()).toList());
    } on ApiError catch (e) {
      return Left(ServerFailure(e.message));
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Network error'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> searchProducts(String name) async {
    try {
      final models = await _remoteDataSource.searchProducts(name);
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
