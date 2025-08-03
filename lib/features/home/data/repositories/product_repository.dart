// lib/features/home/data/repositories/product_repository_impl.dart

import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:rent_my_fit/core/network/api_config.dart';
import 'package:rent_my_fit/features/home/data/models/product_model.dart';

abstract class ProductRepository {
  Future<List<ProductModel>> fetchProducts();
  Future<void> addProduct(ProductModel product, File imageFile);
  Future<void> deleteProduct(String productId);
  Future<void> updateProduct(ProductModel product, File? newImage);

  // ✅ Wishlist-related methods
  Future<List<ProductModel>> fetchWishlist();
  Future<void> toggleWishlist(String productId);
}

class ProductRepositoryImpl implements ProductRepository {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  ProductRepositoryImpl();

  /// Helper to read the stored JWT
  Future<String?> _getToken() async {
    return await _storage.read(key: 'token');
  }

  @override
  Future<List<ProductModel>> fetchProducts() async {
    final base = await ApiConfig.baseUrl;
    final uri  = Uri.parse('$base/products');
    final res  = await http.get(uri);

    if (res.statusCode == 200) {
      final List<dynamic> data = jsonDecode(res.body);
      return data.map((json) => ProductModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch products');
    }
  }

  @override
  Future<void> addProduct(ProductModel product, File imageFile) async {
    final base  = await ApiConfig.baseUrl;
    final uri   = Uri.parse('$base/products');
    final token = await _getToken();
    if (token == null) throw Exception('No token found. Please log in again.');

    final request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..fields['name']        = product.name
      ..fields['description'] = product.description
      ..fields['price']       = product.price.toString()
      ..fields['category']    = product.category
      ..fields['sizes']       = jsonEncode(product.sizes)
      ..files.add(await http.MultipartFile.fromPath('image', imageFile.path));

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);

    if (response.statusCode != 201) {
      throw Exception('Failed to add product: ${response.body}');
    }
  }

  @override
  Future<void> deleteProduct(String productId) async {
    final base  = await ApiConfig.baseUrl;
    final token = await _getToken();
    if (token == null) throw Exception('No token found. Please log in again.');

    final res = await http.delete(
      Uri.parse('$base/products/$productId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (res.statusCode != 200) {
      throw Exception('Failed to delete product');
    }
  }

  @override
  Future<void> updateProduct(ProductModel product, File? newImage) async {
    final base  = await ApiConfig.baseUrl;
    final token = await _getToken();
    if (token == null) throw Exception('No token found. Please log in again.');

    final uri = Uri.parse('$base/products/${product.id}');
    final request = http.MultipartRequest('PUT', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..fields['name']        = product.name
      ..fields['description'] = product.description
      ..fields['price']       = product.price.toString()
      ..fields['category']    = product.category
      ..fields['sizes']       = jsonEncode(product.sizes);

    if (newImage != null) {
      request.files.add(await http.MultipartFile.fromPath('image', newImage.path));
    }

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);

    if (response.statusCode != 200) {
      throw Exception('Failed to update product: ${response.body}');
    }
  }

  // ✅ Wishlist: Fetch user's wishlist products
  @override
  Future<List<ProductModel>> fetchWishlist() async {
    final base  = await ApiConfig.baseUrl;
    final token = await _getToken();
    if (token == null) throw Exception('No token found. Please log in again.');

    final res = await http.get(
      Uri.parse('$base/auth/wishlist'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (res.statusCode == 200) {
      final List<dynamic> data = jsonDecode(res.body);
      return data.map((json) => ProductModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch wishlist');
    }
  }

  // ✅ Wishlist: Toggle add/remove from wishlist
  @override
  Future<void> toggleWishlist(String productId) async {
    final base  = await ApiConfig.baseUrl;
    final token = await _getToken();
    if (token == null) throw Exception('No token found. Please log in again.');

    final res = await http.post(
      Uri.parse('$base/auth/wishlist'),
      headers: {
        'Content-Type' : 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'productId': productId}),
    );

    if (res.statusCode != 200) {
      throw Exception('Failed to update wishlist: ${res.body}');
    }
  }
}
