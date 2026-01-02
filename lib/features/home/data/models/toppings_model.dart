class ToppingModel {
  int id;
  String name;
  String image;
  ToppingModel({required this.id, required this.name, required this.image});
  factory ToppingModel.fromJson(Map<String, dynamic> josn) {
    return ToppingModel(
      id: josn['id'],
      name: josn['name'],
      image: josn['image'],
    );
  }
}
