import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:hungry_app/core/failure.dart';
import 'package:hungry_app/core/usecase.dart';
import 'package:hungry_app/features/auth/domain/entities/user_entity.dart';
import 'package:hungry_app/features/auth/domain/repositories/auth_repository.dart';

class UpdateProfileUseCase implements UseCase<UserEntity, UpdateProfileParams> {
  final AuthRepository repository;

  UpdateProfileUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(UpdateProfileParams params) {
    return repository.updateProfile(
      name: params.name,
      email: params.email,
      address: params.address,
      visa: params.visa,
      imagePath: params.imagePath,
    );
  }
}

class UpdateProfileParams extends Equatable {
  final String name;
  final String email;
  final String address;
  final String? visa;
  final String? imagePath;

  const UpdateProfileParams({
    required this.name,
    required this.email,
    required this.address,
    this.visa,
    this.imagePath,
  });

  @override
  List<Object?> get props => [name, email, address, visa, imagePath];
}
