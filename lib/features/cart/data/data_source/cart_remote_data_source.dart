// lib/features/cart/data/data_source/cart_remote_data_source.dart

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:rent_my_fit/app/service_locator.dart';
import 'package:rent_my_fit/core/network/api_config.dart';
import 'package:rent_my_fit/features/auth/data/data_source/user_local_datasource.dart';
import 'package:rent_my_fit/features/cart/domain/entity/cart_item_entity.dart';
import '../model/cart_item_model.dart';

class CartRemoteDataSource {
  CartRemoteDataSource();

  /// Read stored JWT for Authorization header
  Future<String?> _getToken() async {
    return await sl<UserLocalDatasource>().getToken();
  }

  /// Fetch the current cart items
  Future<List<CartItemEntity>> getCart() async {
    final base  = await ApiConfig.baseUrl;
    final token = await _getToken();
    print('Token: $token');

    final uri = Uri.parse('$base/auth/cart');
    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );

    print('Cart GET status: ${response.statusCode}');
    print('Cart response: ${response.body}');

    if (response.statusCode == 200) {
      final List decoded = json.decode(response.body);
      return decoded
          .map((e) => CartItemModel.fromJson(e))
          .toList();
    } else {
      throw Exception('Failed to fetch cart');
    }
  }

  /// Add one item to cart
  Future<void> addToCart(CartItemEntity item) async {
    final base  = await ApiConfig.baseUrl;
    final token = await _getToken();

    final uri = Uri.parse('$base/auth/cart');
    final body = CartItemModel(
      id:       item.id,
      name:     item.name,
      imageUrl: item.imageUrl,
      price:    item.price,
      size:     item.size,
      quantity: item.quantity,
    ).toJson();

    final response = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type' : 'application/json',
      },
      body: json.encode(body),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to add to cart');
    }
  }

  /// Remove an item by productId
  Future<void> removeFromCart(String productId) async {
    final base  = await ApiConfig.baseUrl;
    final token = await _getToken();

    final uri = Uri.parse('$base/auth/cart/$productId');
    final response = await http.delete(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to remove from cart');
    }
  }

  /// Update the quantity of an existing cart item
  Future<void> updateCartItem(String productId, int quantity) async {
    final base  = await ApiConfig.baseUrl;
    final token = await _getToken();

    final uri = Uri.parse('$base/auth/cart/$productId');
    final response = await http.put(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type' : 'application/json',
      },
      body: json.encode({'quantity': quantity}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update cart item');
    }
  }
}
