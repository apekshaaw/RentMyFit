import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rent_my_fit/features/auth/domain/entity/user_entity.dart';
import 'package:rent_my_fit/features/auth/domain/repository/user_repository.dart';

class UserRemoteRepositoryImpl implements UserRepository {
  final http.Client client;

  UserRemoteRepositoryImpl(this.client);

  @override
  Future<void> registerUser(UserEntity user) async {
    final response = await client.post(
      Uri.parse('http://192.168.1.67:5000/api/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': user.name,
        'email': user.email,
        'password': user.password,
      }),
    );

    if (response.statusCode != 201) {
      final data = jsonDecode(response.body);
      throw Exception(data['message'] ?? 'Registration failed');
    }
  }

  @override
  Future<UserEntity> loginUser(String email, String password) async {
    final response = await client.post(
      Uri.parse('http://192.168.1.67:5000/api/auth/login'), 
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final user = data['user'];

      return UserEntity(
        id: user['id'] ?? user['_id'],
        name: user['name'],
        email: user['email'],
        password: '', // Hide password for security
      );
    } else {
      final data = jsonDecode(response.body);
      throw Exception(data['message'] ?? 'Login failed');
    }
  }
}
