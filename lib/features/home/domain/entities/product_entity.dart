class ProductEntity {
  final int id;
  final String name;
  final String desc;
  final String image;
  final String price;
  final String rate;

  const ProductEntity({
    required this.id,
    required this.name,
    required this.desc,
    required this.image,
    required this.price,
    required this.rate,
  });
}

class ToppingEntity {
  final int id;
  final String name;
  final String image;

  const ToppingEntity({
    required this.id,
    required this.name,
    required this.image,
  });
}
