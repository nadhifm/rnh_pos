class Cart {
  final String id;
  final String name;
  final String imageUrl;
  final int price;
  final int stock;
  int quantity;

  Cart({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.stock,
    required this.quantity,
  });
}
