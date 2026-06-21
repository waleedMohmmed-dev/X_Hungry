import 'package:hungry_app/features/auth/domain/entities/user_entity.dart';

class UserModel {
  final String name;
  final String email;
  final String? image;
  final String? token;
  final String? visa;
  final String? address;

  UserModel({
    required this.name,
    required this.email,
    this.image,
    this.token,
    this.address,
    this.visa,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'],
      email: json['email'],
      image: json['image'],
      token: json['token'],
      address: json['address'],
      visa: json['Visa'],
    );
  }

  UserEntity toEntity() {
    return UserEntity(
      name: name,
      email: email,
      image: image,
      token: token,
      address: address,
      visa: visa,
    );
  }
}
