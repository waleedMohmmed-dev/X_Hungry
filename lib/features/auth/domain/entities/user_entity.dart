class UserEntity {
  final String name;
  final String email;
  final String? image;
  final String? token;
  final String? visa;
  final String? address;

  const UserEntity({
    required this.name,
    required this.email,
    this.image,
    this.token,
    this.address,
    this.visa,
  });
}
