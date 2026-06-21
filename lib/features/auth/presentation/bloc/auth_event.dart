import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class LoginSubmitted extends AuthEvent {
  final String email;
  final String password;

  const LoginSubmitted({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class SignupSubmitted extends AuthEvent {
  final String name;
  final String email;
  final String password;

  const SignupSubmitted({required this.name, required this.email, required this.password});

  @override
  List<Object?> get props => [name, email, password];
}

class ProfileLoaded extends AuthEvent {
  const ProfileLoaded();
}

class ProfileUpdated extends AuthEvent {
  final String name;
  final String email;
  final String address;
  final String? visa;
  final String? imagePath;

  const ProfileUpdated({
    required this.name,
    required this.email,
    required this.address,
    this.visa,
    this.imagePath,
  });

  @override
  List<Object?> get props => [name, email, address, visa, imagePath];
}

class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}

class AutoLoginRequested extends AuthEvent {
  const AutoLoginRequested();
}

class GuestLoginRequested extends AuthEvent {
  const GuestLoginRequested();
}

class AuthChecked extends AuthEvent {
  final bool isGuest;

  const AuthChecked({required this.isGuest});

  @override
  List<Object?> get props => [isGuest];
}
