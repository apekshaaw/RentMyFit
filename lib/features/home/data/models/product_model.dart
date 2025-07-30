class ProductModel {
  final String id;
  final String name;
  final String description;
  final String category; // "clothing" or "shoes"
  final List<String> sizes;
  final String imageUrl;
  final double price;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.sizes,
    required this.imageUrl,
    required this.price,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      sizes: List<String>.from(json['sizes'] ?? []),
      imageUrl: json['imageUrl'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'category': category,
      'sizes': sizes,
      'imageUrl': imageUrl,
      'price': price,
    };
  }
}
