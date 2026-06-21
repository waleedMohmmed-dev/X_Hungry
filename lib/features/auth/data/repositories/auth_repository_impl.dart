import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:hungry_app/core/failure.dart';
import 'package:hungry_app/core/network/api_error.dart';
import 'package:hungry_app/core/network/api_exceptions.dart';
import 'package:hungry_app/core/utils/pref_helper.dart';
import 'package:hungry_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:hungry_app/features/auth/data/models/user_model.dart';
import 'package:hungry_app/features/auth/domain/entities/user_entity.dart';
import 'package:hungry_app/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl(this._remoteDataSource);

  bool _isGuest = false;
  UserModel? _currentUser;

  @override
  bool get isGuest => _isGuest;

  @override
  bool get isLoggedIn => !_isGuest && _currentUser != null;

  @override
  UserEntity? get currentUser => _currentUser?.toEntity();

  @override
  Future<Either<Failure, UserEntity>> login(String email, String password) async {
    try {
      final user = await _remoteDataSource.login(email, password);
      if (user.token != null) {
        await PrefHelper.saveToken(user.token!);
      }
      _isGuest = false;
      _currentUser = user;
      return Right(user.toEntity());
    } on ApiError catch (e) {
      return Left(ServerFailure(e.message));
    } on DioException catch (e) {
      return Left(ServerFailure(ApiExceptions.handleError(e).message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signup(String name, String email, String password) async {
    try {
      final user = await _remoteDataSource.signup(name, email, password);
      if (user.token != null) {
        await PrefHelper.saveToken(user.token!);
      }
      _isGuest = false;
      _currentUser = user;
      return Right(user.toEntity());
    } on ApiError catch (e) {
      return Left(ServerFailure(e.message));
    } on DioException catch (e) {
      return Left(ServerFailure(ApiExceptions.handleError(e).message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getProfile() async {
    try {
      final token = await PrefHelper.getToken();
      if (token == null || token == 'guest') {
        return const Left(ServerFailure('Not logged in'));
      }
      final user = await _remoteDataSource.getProfile();
      _currentUser = user;
      return Right(user.toEntity());
    } on ApiError catch (e) {
      return Left(ServerFailure(e.message));
    } on DioException catch (e) {
      return Left(ServerFailure(ApiExceptions.handleError(e).message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateProfile({
    required String name,
    required String email,
    required String address,
    String? visa,
    String? imagePath,
  }) async {
    try {
      final user = await _remoteDataSource.updateProfile(
        name: name,
        email: email,
        address: address,
        visa: visa,
        imagePath: imagePath,
      );
      _currentUser = user;
      return Right(user.toEntity());
    } on ApiError catch (e) {
      return Left(ServerFailure(e.message));
    } on DioException catch (e) {
      return Left(ServerFailure(ApiExceptions.handleError(e).message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await _remoteDataSource.logout();
      await PrefHelper.clearToken();
      _currentUser = null;
      _isGuest = true;
      return const Right(null);
    } catch (e) {
      await PrefHelper.clearToken();
      _currentUser = null;
      _isGuest = true;
      return const Right(null);
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> autoLogin() async {
    final token = await PrefHelper.getToken();
    if (token == null || token == 'guest') {
      _isGuest = true;
      _currentUser = null;
      return const Right(null);
    }

    _isGuest = false;
    try {
      final result = await getProfile();
      return result.fold(
        (failure) {
          PrefHelper.clearToken();
          _isGuest = true;
          _currentUser = null;
          return const Right(null);
        },
        (user) => Right(user),
      );
    } catch (e) {
      await PrefHelper.clearToken();
      _isGuest = true;
      _currentUser = null;
      return const Right(null);
    }
  }

  @override
  Future<void> continueAsGuest() async {
    _isGuest = true;
    _currentUser = null;
    await PrefHelper.saveToken('guest');
  }
}
