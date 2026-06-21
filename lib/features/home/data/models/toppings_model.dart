import 'package:hungry_app/features/home/domain/entities/product_entity.dart';

class ToppingModel {
  final int id;
  final String name;
  final String image;

  ToppingModel({required this.id, required this.name, required this.image});

  factory ToppingModel.fromJson(Map<String, dynamic> json) {
    return ToppingModel(
      id: json['id'],
      name: json['name'],
      image: json['image'],
    );
  }

  ToppingEntity toEntity() => ToppingEntity(
        id: id,
        name: name,
        image: image,
      );
}
