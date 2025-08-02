class CartItemEntity {
  final String id; // product id
  final String name;
  final String imageUrl;
  final double price;
  final String size;
  final int quantity;

  CartItemEntity({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.size,
    required this.quantity,
  });
}
