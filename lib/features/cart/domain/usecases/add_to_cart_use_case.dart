import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:hungry_app/core/failure.dart';
import 'package:hungry_app/core/usecase.dart';
import 'package:hungry_app/features/cart/domain/entities/cart_entity.dart';
import 'package:hungry_app/features/cart/domain/repositories/cart_repository.dart';

class AddToCartUseCase implements UseCase<void, AddToCartParams> {
  final CartRepository repository;

  AddToCartUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(AddToCartParams params) {
    return repository.addToCart(params.item);
  }
}

class AddToCartParams extends Equatable {
  final CartRequestEntity item;

  const AddToCartParams({required this.item});

  @override
  List<Object?> get props => [item];
}
