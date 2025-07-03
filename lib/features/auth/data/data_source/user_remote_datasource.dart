import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rent_my_fit/features/auth/data/model/user_hive_model.dart';

class UserRemoteDatasource {
  final http.Client client;

  UserRemoteDatasource({required this.client});

  Future<UserHiveModel> register(String name, String email, String password) async {
    final response = await client.post(
      Uri.parse('http://localhost:5000/api/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'name': name, 'email': email, 'password': password}),
    );

    final body = json.decode(response.body);

    if (response.statusCode == 201) {
      return UserHiveModel(
        name: name,
        email: email,
        password: password,
      );
    } else {
      throw Exception(body['message'] ?? 'Registration failed');
    }
  }

  Future<UserHiveModel> login(String email, String password) async {
    final response = await client.post(
      Uri.parse('http://localhost:5000/api/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );

    final body = json.decode(response.body);

    if (response.statusCode == 200) {
      return UserHiveModel(
        name: body['user']['name'],
        email: body['user']['email'],
        password: password, // optional: save or not
      );
    } else {
      throw Exception(body['message'] ?? 'Login failed');
    }
  }
}
