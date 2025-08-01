class CartItem {
  final String productId;
  final String name;
  final String imageUrl;
  final double price;
  final int quantity;

  CartItem({
    required this.productId,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.quantity,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    final product = json['product'];
    return CartItem(
      productId: product['_id'],
      name: product['name'],
      imageUrl: product['image'] ?? '',  // match your backend field
      price: (product['price'] as num).toDouble(),
      quantity: json['quantity'],
    );
  }
}
