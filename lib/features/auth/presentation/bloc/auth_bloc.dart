import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungry_app/core/usecase.dart';
import 'package:hungry_app/features/auth/domain/usecases/login_use_case.dart';
import 'package:hungry_app/features/auth/domain/usecases/signup_use_case.dart';
import 'package:hungry_app/features/auth/domain/usecases/get_profile_use_case.dart';
import 'package:hungry_app/features/auth/domain/usecases/update_profile_use_case.dart';
import 'package:hungry_app/features/auth/domain/usecases/logout_use_case.dart';
import 'package:hungry_app/features/auth/domain/usecases/auto_login_use_case.dart';
import 'package:hungry_app/features/auth/domain/usecases/continue_as_guest_use_case.dart';
import 'package:hungry_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:hungry_app/features/auth/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase _loginUseCase;
  final SignupUseCase _signupUseCase;
  final GetProfileUseCase _getProfileUseCase;
  final UpdateProfileUseCase _updateProfileUseCase;
  final LogoutUseCase _logoutUseCase;
  final AutoLoginUseCase _autoLoginUseCase;
  final ContinueAsGuestUseCase _continueAsGuestUseCase;

  AuthBloc({
    required LoginUseCase loginUseCase,
    required SignupUseCase signupUseCase,
    required GetProfileUseCase getProfileUseCase,
    required UpdateProfileUseCase updateProfileUseCase,
    required LogoutUseCase logoutUseCase,
    required AutoLoginUseCase autoLoginUseCase,
    required ContinueAsGuestUseCase continueAsGuestUseCase,
  })  : _loginUseCase = loginUseCase,
        _signupUseCase = signupUseCase,
        _getProfileUseCase = getProfileUseCase,
        _updateProfileUseCase = updateProfileUseCase,
        _logoutUseCase = logoutUseCase,
        _autoLoginUseCase = autoLoginUseCase,
        _continueAsGuestUseCase = continueAsGuestUseCase,
        super(const AuthState()) {
    on<LoginSubmitted>(_onLoginSubmitted);
    on<SignupSubmitted>(_onSignupSubmitted);
    on<ProfileLoaded>(_onProfileLoaded);
    on<ProfileUpdated>(_onProfileUpdated);
    on<LogoutRequested>(_onLogoutRequested);
    on<AutoLoginRequested>(_onAutoLoginRequested);
    on<GuestLoginRequested>(_onGuestLoginRequested);
    on<AuthChecked>(_onAuthChecked);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    final result = await _loginUseCase(
      LoginParams(email: event.email, password: event.password),
    );

    result.fold(
      (failure) => emit(state.copyWith(
        isLoading: false,
        errorMessage: failure.message,
      )),
      (user) => emit(state.copyWith(
        isLoading: false,
        user: user,
        isGuest: false,
      )),
    );
  }

  Future<void> _onSignupSubmitted(
    SignupSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    final result = await _signupUseCase(
      SignupParams(name: event.name, email: event.email, password: event.password),
    );

    result.fold(
      (failure) => emit(state.copyWith(
        isLoading: false,
        errorMessage: failure.message,
      )),
      (user) => emit(state.copyWith(
        isLoading: false,
        user: user,
        isGuest: false,
      )),
    );
  }

  Future<void> _onProfileLoaded(
    ProfileLoaded event,
    Emitter<AuthState> emit,
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

  Future<void> _onProfileUpdated(
    ProfileUpdated event,
    Emitter<AuthState> emit,
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

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(isSubmitting: true));

    final result = await _logoutUseCase(const NoParams());

    result.fold(
      (failure) => emit(state.copyWith(
        isSubmitting: false,
        errorMessage: failure.message,
      )),
      (_) => emit(const AuthState(isGuest: true)),
    );
  }

  Future<void> _onAutoLoginRequested(
    AutoLoginRequested event,
    Emitter<AuthState> emit,
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
  }

  Future<void> _onGuestLoginRequested(
    GuestLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _continueAsGuestUseCase(const NoParams());
    emit(state.copyWith(isGuest: true, user: null));
  }

  void _onAuthChecked(AuthChecked event, Emitter<AuthState> emit) {
    emit(state.copyWith(isGuest: event.isGuest));
  }
}
