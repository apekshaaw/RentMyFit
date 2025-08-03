import '../../../home/data/models/product_model.dart';
import '../../domain/entity/cart_item_entity.dart';

class CartItemModel extends CartItemEntity {
  CartItemModel({
    required super.id,
    required super.name,
    required super.imageUrl,
    required super.price,
    required super.size,
    required super.quantity,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id'],
      name: json['name'],
      imageUrl: json['imageUrl'],
      price: (json['price'] as num).toDouble(),
      size: json['size'],
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'price': price,
      'size': size,
      'quantity': quantity,
    };
  }

  // Factory method to convert from ProductModel + selected size + quantity
  factory CartItemModel.fromProduct(ProductModel product, String size, int quantity) {
    return CartItemModel(
      id: product.id,
      name: product.name,
      imageUrl: product.imageUrl,
      price: product.price,
      size: size,
      quantity: quantity,
    );
  }
}
