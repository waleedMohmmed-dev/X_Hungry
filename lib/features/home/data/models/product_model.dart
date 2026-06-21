import 'package:hungry_app/features/home/domain/entities/product_entity.dart';

class ProductModel {
  final int id;
  final String name;
  final String desc;
  final String image;
  final String price;
  final String rate;

  ProductModel({
    required this.id,
    required this.name,
    required this.desc,
    required this.image,
    required this.price,
    required this.rate,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      desc: json['description'],
      image: json['image'],
      price: json['price'],
      rate: json['rating'],
    );
  }

  ProductEntity toEntity() => ProductEntity(
        id: id,
        name: name,
        desc: desc,
        image: image,
        price: price,
        rate: rate,
      );
}
