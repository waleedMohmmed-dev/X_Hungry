import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:hungry_app/core/failure.dart';
import 'package:hungry_app/core/usecase.dart';
import 'package:hungry_app/features/favorites/domain/repositories/favorite_repository.dart';

class ToggleFavoriteUseCase implements UseCase<String, ToggleFavoriteParams> {
  final FavoriteRepository repository;

  ToggleFavoriteUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(ToggleFavoriteParams params) {
    return repository.toggleFavorite(params.productId);
  }
}

class ToggleFavoriteParams extends Equatable {
  final int productId;

  const ToggleFavoriteParams({required this.productId});

  @override
  List<Object?> get props => [productId];
}
