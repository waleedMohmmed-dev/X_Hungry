import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:hungry_app/core/failure.dart';
import 'package:hungry_app/core/usecase.dart';
import 'package:hungry_app/features/cart/domain/repositories/cart_repository.dart';

class RemoveCartItemUseCase implements UseCase<void, RemoveCartParams> {
  final CartRepository repository;

  RemoveCartItemUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(RemoveCartParams params) {
    return repository.removeCartItem(params.itemId);
  }
}

class RemoveCartParams extends Equatable {
  final int itemId;

  const RemoveCartParams({required this.itemId});

  @override
  List<Object?> get props => [itemId];
}
