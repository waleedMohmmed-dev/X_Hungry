import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class ProfileInit extends ProfileEvent {
  const ProfileInit();
}

class ProfileLoadRequested extends ProfileEvent {
  const ProfileLoadRequested();
}

class ProfileUpdateRequested extends ProfileEvent {
  final String name;
  final String email;
  final String address;
  final String? visa;
  final String? imagePath;

  const ProfileUpdateRequested({
    required this.name,
    required this.email,
    required this.address,
    this.visa,
    this.imagePath,
  });

  @override
  List<Object?> get props => [name, email, address, visa, imagePath];
}

class ProfileLogoutRequested extends ProfileEvent {
  const ProfileLogoutRequested();
}
