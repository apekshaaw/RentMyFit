import '../../../home/data/models/product_model.dart';
import '../../domain/entity/cart_item_entity.dart';

class CartItemModel extends CartItemEntity {
  CartItemModel({
    required String id,
    required String name,
    required String imageUrl,
    required double price,
    required String size,
    required int quantity,
  }) : super(
          id: id,
          name: name,
          imageUrl: imageUrl,
          price: price,
          size: size,
          quantity: quantity,
        );

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
