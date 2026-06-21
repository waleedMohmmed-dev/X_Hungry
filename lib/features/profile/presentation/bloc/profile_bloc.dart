import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungry_app/core/usecase.dart';
import 'package:hungry_app/features/auth/domain/usecases/auto_login_use_case.dart';
import 'package:hungry_app/features/auth/domain/usecases/get_profile_use_case.dart';
import 'package:hungry_app/features/auth/domain/usecases/logout_use_case.dart';
import 'package:hungry_app/features/auth/domain/usecases/update_profile_use_case.dart';
import 'package:hungry_app/features/profile/presentation/bloc/profile_event.dart';
import 'package:hungry_app/features/profile/presentation/bloc/profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfileUseCase _getProfileUseCase;
  final UpdateProfileUseCase _updateProfileUseCase;
  final LogoutUseCase _logoutUseCase;
  final AutoLoginUseCase _autoLoginUseCase;

  ProfileBloc({
    required GetProfileUseCase getProfileUseCase,
    required UpdateProfileUseCase updateProfileUseCase,
    required LogoutUseCase logoutUseCase,
    required AutoLoginUseCase autoLoginUseCase,
  })  : _getProfileUseCase = getProfileUseCase,
        _updateProfileUseCase = updateProfileUseCase,
        _logoutUseCase = logoutUseCase,
        _autoLoginUseCase = autoLoginUseCase,
        super(const ProfileState()) {
    on<ProfileInit>(_onProfileInit);
    on<ProfileLoadRequested>(_onProfileLoadRequested);
    on<ProfileUpdateRequested>(_onProfileUpdateRequested);
    on<ProfileLogoutRequested>(_onProfileLogoutRequested);
  }

  Future<void> _onProfileInit(
    ProfileInit event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final result = await _autoLoginUseCase(const NoParams());

    result.fold(
      (failure) => emit(state.copyWith(
        isLoading: false,
        isGuest: true,
      )),
      (user) {
        if (user != null) {
          emit(state.copyWith(
            isLoading: false,
            user: user,
            isGuest: false,
          ));
        } else {
          emit(state.copyWith(
            isLoading: false,
            isGuest: true,
          ));
        }
      },
    );

    if (!state.isGuest) {
      final profileResult = await _getProfileUseCase(const NoParams());
      profileResult.fold(
        (failure) => emit(state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        )),
        (user) => emit(state.copyWith(
          isLoading: false,
          user: user,
        )),
      );
    }
  }

  Future<void> _onProfileLoadRequested(
    ProfileLoadRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final result = await _getProfileUseCase(const NoParams());

    result.fold(
      (failure) => emit(state.copyWith(
        isLoading: false,
        errorMessage: failure.message,
      )),
      (user) => emit(state.copyWith(
        isLoading: false,
        user: user,
      )),
    );
  }

  Future<void> _onProfileUpdateRequested(
    ProfileUpdateRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(isSubmitting: true));

    final result = await _updateProfileUseCase(
      UpdateProfileParams(
        name: event.name,
        email: event.email,
        address: event.address,
        visa: event.visa,
        imagePath: event.imagePath,
      ),
    );

    result.fold(
      (failure) => emit(state.copyWith(
        isSubmitting: false,
        errorMessage: failure.message,
      )),
      (user) => emit(state.copyWith(
        isSubmitting: false,
        user: user,
        successMessage: 'Profile updated successfully',
      )),
    );
  }

  Future<void> _onProfileLogoutRequested(
    ProfileLogoutRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(isSubmitting: true));

    final result = await _logoutUseCase(const NoParams());

    result.fold(
      (failure) => emit(state.copyWith(
        isSubmitting: false,
        errorMessage: failure.message,
      )),
      (_) => emit(const ProfileState(isGuest: true)),
    );
  }
}
