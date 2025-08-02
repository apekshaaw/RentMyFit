import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:rent_my_fit/features/auth/data/model/user_hive_model.dart';
import 'package:rent_my_fit/features/profile/data/models/user_model.dart';
import 'package:rent_my_fit/features/profile/domain/entity/profile_entity.dart';

class UserRemoteDatasource {
  final http.Client client;
  final FlutterSecureStorage secureStorage;

  UserRemoteDatasource({required this.client, required this.secureStorage});

  Future<UserHiveModel> register(
    String name,
    String email,
    String password,
  ) async {
    final response = await client.post(
      Uri.parse('http://localhost:5000/api/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'name': name, 'email': email, 'password': password,}),
    );

    final body = json.decode(response.body);

    if (response.statusCode == 201) {
      return UserHiveModel(name: name, email: email, password: password, token: '',);
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
      // Save token securely
      final token = body['token'];
      await secureStorage.write(key: 'token', value: token);

      return UserHiveModel(
        name: body['user']['name'],
        email: body['user']['email'],
        password: password,
        token: token
      );
    } else {
      throw Exception(body['message'] ?? 'Login failed');
    }
  }

  Future<ProfileEntity> fetchProfile() async {
    final token = await secureStorage.read(key: 'token');
    final response = await client.get(
      Uri.parse('http://localhost:5000/api/auth/profile'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final body = json.decode(response.body);

    if (response.statusCode == 200) {
      final userModel = UserModel.fromJson(body['user'] ?? body);
      return userModel.toEntity();
    } else {
      throw Exception(body['message'] ?? 'Failed to load profile');
    }
  }

  Future<void> updateProfile(ProfileEntity entity) async {
  final token = await secureStorage.read(key: 'token');
  final model = UserModel.fromEntity(entity);

  // 👇 Debug print to log the request body
  print("Sending updated profile: ${json.encode(model.toJson())}");

  final response = await client.put(
    Uri.parse('http://localhost:5000/api/auth/profile'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: json.encode(model.toJson()),
  );

  if (response.statusCode == 200) {
    // Success - do nothing or handle accordingly
    return;
  } else {
    // Attempt to decode error or show raw error message
    try {
      final body = json.decode(response.body);
      throw Exception(body['message'] ?? 'Failed to update profile');
    } catch (e) {
      throw Exception('Unexpected server response: ${response.body}');
    }
  }
}
}
