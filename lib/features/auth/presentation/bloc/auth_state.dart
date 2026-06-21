import 'package:equatable/equatable.dart';
import 'package:hungry_app/features/auth/domain/entities/user_entity.dart';

class AuthState extends Equatable {
  final UserEntity? user;
  final bool isLoading;
  final bool isSubmitting;
  final bool isGuest;
  final String? errorMessage;
  final String? successMessage;

  const AuthState({
    this.user,
    this.isLoading = false,
    this.isSubmitting = false,
    this.isGuest = false,
    this.errorMessage,
    this.successMessage,
  });

  AuthState copyWith({
    UserEntity? user,
    bool? isLoading,
    bool? isSubmitting,
    bool? isGuest,
    String? errorMessage,
    String? successMessage,
  }) =>
      AuthState(
        user: user ?? this.user,
        isLoading: isLoading ?? this.isLoading,
        isSubmitting: isSubmitting ?? this.isSubmitting,
        isGuest: isGuest ?? this.isGuest,
        errorMessage: errorMessage,
        successMessage: successMessage,
      );

  @override
  List<Object?> get props => [
    user,
    isLoading,
    isSubmitting,
    isGuest,
    errorMessage,
    successMessage,
  ];
}
