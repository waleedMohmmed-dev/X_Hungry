import 'package:dartz/dartz.dart';
import 'package:hungry_app/core/failure.dart';
import 'package:hungry_app/features/cart/domain/entities/cart_entity.dart';

abstract class CartRepository {
  Future<Either<Failure, void>> addToCart(CartRequestEntity item);
  Future<Either<Failure, CartEntity>> getCart();
  Future<Either<Failure, void>> removeCartItem(int id);
}
