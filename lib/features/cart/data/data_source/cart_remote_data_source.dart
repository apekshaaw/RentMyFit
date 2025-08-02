import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rent_my_fit/app/service_locator.dart';
import 'package:rent_my_fit/core/network/api_base_url.dart';
import '../../domain/entity/cart_item_entity.dart';
import '../model/cart_item_model.dart';
import 'package:rent_my_fit/features/auth/data/data_source/user_local_datasource.dart';


class CartRemoteDataSource {
  final baseUrl = '${getBaseUrl()}/auth/cart'; 

  Future<String?> _getToken() async {
    return await sl<UserLocalDatasource>().getToken(); // uses FlutterSecureStorage
  }

  Future<List<CartItemEntity>> getCart() async {
  final token = await _getToken();
  print('Token: $token'); // ✅

  final response = await http.get(
    Uri.parse(baseUrl),
    headers: {'Authorization': 'Bearer $token'},
  );

  print('Cart GET status: ${response.statusCode}');
  print('Cart response: ${response.body}');

  if (response.statusCode == 200) {
    final List decoded = json.decode(response.body);
    return decoded.map((e) => CartItemModel.fromJson(e)).toList();
  } else {
    throw Exception('Failed to fetch cart');
  }
}


  Future<void> addToCart(CartItemEntity item) async {
    final token = await _getToken();
    await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(CartItemModel(
        id: item.id,
        name: item.name,
        imageUrl: item.imageUrl,
        price: item.price,
        size: item.size,
        quantity: item.quantity,
      ).toJson()),
    );
  }

  Future<void> removeFromCart(String productId) async {
    final token = await _getToken();
    await http.delete(
      Uri.parse('$baseUrl/$productId'),
      headers: {'Authorization': 'Bearer $token'},
    );
  }

  Future<void> updateCartItem(String productId, int quantity) async {
    final token = await _getToken();
    await http.put(
      Uri.parse('$baseUrl/$productId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({'quantity': quantity}),
    );
  }
}
