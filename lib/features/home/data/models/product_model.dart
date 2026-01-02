class ProductModel {
  int id;
  String name;
  String desc;
  String image;
  String price;
  String rate;

  ProductModel({
    required this.id,
    required this.name,
    required this.desc,
    required this.image,
    required this.price,
    required this.rate,
  });

  factory ProductModel.fromJson(Map<String, dynamic> josn) {
    return ProductModel(
      id: josn['id'],
      name: josn['name'],
      desc: josn['description'],
      image: josn['image'],
      price: josn['price'],
      rate: josn['rating'],
    );
  }
}
