import 'package:dartz/dartz.dart';
import 'package:hungry_app/core/failure.dart';
import 'package:hungry_app/features/home/domain/entities/product_entity.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<ProductEntity>>> getProducts();
  Future<Either<Failure, List<ToppingEntity>>> getToppings();
  Future<Either<Failure, List<ToppingEntity>>> getOptions();
  Future<Either<Failure, List<ProductEntity>>> searchProducts(String name);
}
