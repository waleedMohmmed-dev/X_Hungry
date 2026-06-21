class CartItemEntity {
  final int itemId;
  final int productId;
  final String name;
  final String image;
  final int quantity;
  final String price;
  final double spicy;

  const CartItemEntity({
    required this.itemId,
    required this.productId,
    required this.name,
    required this.image,
    required this.quantity,
    required this.price,
    required this.spicy,
  });
}

class CartEntity {
  final int id;
  final String totalPrice;
  final List<CartItemEntity> items;

  const CartEntity({
    required this.id,
    required this.totalPrice,
    required this.items,
  });
}

class CartRequestEntity {
  final int productId;
  final int qty;
  final double spicy;
  final List<int> toppings;
  final List<int> options;

  const CartRequestEntity({
    required this.productId,
    required this.qty,
    required this.spicy,
    required this.toppings,
    required this.options,
  });
}
