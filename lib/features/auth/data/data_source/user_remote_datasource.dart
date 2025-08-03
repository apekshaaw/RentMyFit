import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:rent_my_fit/core/network/api_config.dart';
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
    final base = await ApiConfig.baseUrl;
    final uri  = Uri.parse('$base/auth/register');

    final response = await client.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'name': name, 'email': email, 'password': password}),
    );

    final body = json.decode(response.body);
    if (response.statusCode == 201) {
      return UserHiveModel(
        name: name,
        email: email,
        password: password,
        token: '',
      );
    } else {
      throw Exception(body['message'] ?? 'Registration failed');
    }
  }

  Future<UserHiveModel> login(String email, String password) async {
    final base = await ApiConfig.baseUrl;
    final uri = Uri.parse('$base/auth/login');
    print('👉 POST login to: $uri');

    final response = await client.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );

    final body = json.decode(response.body);
    if (response.statusCode == 200) {
      final token = body['token'] as String;
      await secureStorage.write(key: 'token', value: token);

      return UserHiveModel(
        name: body['user']['name'] as String,
        email: body['user']['email'] as String,
        password: password,
        token: token,
      );
    } else {
      throw Exception(body['message'] ?? 'Login failed');
    }
  }

  Future<ProfileEntity> fetchProfile() async {
    final base = await ApiConfig.baseUrl;
    final token = await secureStorage.read(key: 'token');
    final uri = Uri.parse('$base/auth/profile');

    final response = await client.get(
      uri,
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
    final base = await ApiConfig.baseUrl;
    final token = await secureStorage.read(key: 'token');
    final model = UserModel.fromEntity(entity);

    // Debug
    print('Sending updated profile: ${json.encode(model.toJson())}');

    final uri = Uri.parse('$base/auth/profile');
    final response = await client.put(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(model.toJson()),
    );

    if (response.statusCode == 200) {
      return;
    } else {
      try {
        final body = json.decode(response.body);
        throw Exception(body['message'] ?? 'Failed to update profile');
      } catch (_) {
        throw Exception('Unexpected server response: ${response.body}');
      }
    }
  }
}
