import 'package:dartz/dartz.dart';
import 'package:hungry_app/core/failure.dart';
import 'package:hungry_app/core/usecase.dart';
import 'package:hungry_app/features/auth/domain/repositories/auth_repository.dart';

class ContinueAsGuestUseCase implements UseCase<void, NoParams> {
  final AuthRepository repository;

  ContinueAsGuestUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    await repository.continueAsGuest();
    return const Right(null);
  }
}
