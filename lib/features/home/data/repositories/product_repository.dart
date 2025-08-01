import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
  final String baseUrl;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  ProductRepositoryImpl({required this.baseUrl});

  @override
  Future<List<ProductModel>> fetchProducts() async {
    final res = await http.get(Uri.parse('$baseUrl/products'));

    if (res.statusCode == 200) {
      final List<dynamic> data = jsonDecode(res.body);
      return data.map((json) => ProductModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch products');
    }
  }

  @override
  Future<void> addProduct(ProductModel product, File imageFile) async {
    final uri = Uri.parse('$baseUrl/products');
    final request = http.MultipartRequest('POST', uri);

    final token = await _storage.read(key: 'token');
    if (token == null) throw Exception('No token found. Please log in again.');

    request.fields['name'] = product.name;
    request.fields['description'] = product.description;
    request.fields['price'] = product.price.toString();
    request.fields['category'] = product.category;
    request.fields['sizes'] = jsonEncode(product.sizes);

    request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));
    request.headers['Authorization'] = 'Bearer $token';

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode != 201) {
      throw Exception('Failed to add product: ${response.body}');
    }
  }

  @override
  Future<void> deleteProduct(String productId) async {
    final token = await _storage.read(key: 'token');
    if (token == null) throw Exception('No token found. Please log in again.');

    final res = await http.delete(
      Uri.parse('$baseUrl/products/$productId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (res.statusCode != 200) {
      throw Exception('Failed to delete product');
    }
  }

  @override
  Future<void> updateProduct(ProductModel product, [File? newImage]) async {
    final uri = Uri.parse('$baseUrl/products/${product.id}');
    final request = http.MultipartRequest('PUT', uri);

    final token = await _storage.read(key: 'token');
    if (token == null) throw Exception('No token found. Please log in again.');

    request.fields['name'] = product.name;
    request.fields['description'] = product.description;
    request.fields['price'] = product.price.toString();
    request.fields['category'] = product.category;
    request.fields['sizes'] = jsonEncode(product.sizes);

    if (newImage != null) {
      request.files.add(await http.MultipartFile.fromPath('image', newImage.path));
    }

    request.headers['Authorization'] = 'Bearer $token';

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode != 200) {
      print('Response Body: ${response.body}');
      throw Exception('Failed to update product: ${response.body}');
    }
  }

  // ✅ Wishlist: Fetch user's wishlist products
  @override
  Future<List<ProductModel>> fetchWishlist() async {
    final token = await _storage.read(key: 'token');
    if (token == null) throw Exception('No token found. Please log in again.');

    final res = await http.get(
      Uri.parse('$baseUrl/auth/wishlist'),
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
    final token = await _storage.read(key: 'token');
    if (token == null) throw Exception('No token found. Please log in again.');

    final res = await http.post(
      Uri.parse('$baseUrl/auth/wishlist'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'productId': productId}),
    );

    if (res.statusCode != 200) {
      throw Exception('Failed to update wishlist: ${res.body}');
    }
  }
}
