import 'package:dartz/dartz.dart';
import 'package:hungry_app/core/failure.dart';
import 'package:hungry_app/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> login(String email, String password);
  Future<Either<Failure, UserEntity>> signup(String name, String email, String password);
  Future<Either<Failure, UserEntity>> getProfile();
  Future<Either<Failure, UserEntity>> updateProfile({
    required String name,
    required String email,
    required String address,
    String? visa,
    String? imagePath,
  });
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, UserEntity?>> autoLogin();
  Future<void> continueAsGuest();
  bool get isGuest;
  bool get isLoggedIn;
  UserEntity? get currentUser;
}
