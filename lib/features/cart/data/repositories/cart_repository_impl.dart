import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:hungry_app/core/failure.dart';
import 'package:hungry_app/core/network/api_error.dart';
import 'package:hungry_app/features/cart/data/datasources/cart_remote_data_source.dart';
import 'package:hungry_app/features/cart/data/models/cart_model.dart';
import 'package:hungry_app/features/cart/domain/entities/cart_entity.dart';
import 'package:hungry_app/features/cart/domain/repositories/cart_repository.dart';

class CartRepositoryImpl implements CartRepository {
  final CartRemoteDataSource _remoteDataSource;

  CartRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, void>> addToCart(CartRequestEntity item) async {
    try {
      final cartModel = CartModel(
        productId: item.productId,
        qty: item.qty,
        spicy: item.spicy,
        toppings: item.toppings,
        options: item.options,
      );
      await _remoteDataSource.addToCart(CartRequestModel(items: [cartModel]).toJson());
      return const Right(null);
    } on ApiError catch (e) {
      return Left(ServerFailure(e.message));
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Network error'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CartEntity>> getCart() async {
    try {
      final response = await _remoteDataSource.getCart();
      return Right(response.toEntity());
    } on ApiError catch (e) {
      return Left(ServerFailure(e.message));
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Network error'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeCartItem(int id) async {
    try {
      await _remoteDataSource.removeCartItem(id);
      return const Right(null);
    } on ApiError catch (e) {
      return Left(ServerFailure(e.message));
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Network error'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
