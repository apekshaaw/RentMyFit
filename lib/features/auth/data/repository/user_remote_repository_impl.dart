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
      Uri.parse('http://10.0.2.2:5000/api/auth/register'),
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
  final isAdminLogin = email == 'admin@rentmyfit.com' && password == 'admin1234';

  final response = await client.post(
    Uri.parse(isAdminLogin
        ? 'http://10.0.2.2:5000/api/auth/admin-login'
        : 'http://10.0.2.2:5000/api/auth/login'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'email': email, 'password': password}),
  );

  final data = jsonDecode(response.body);

  if (response.statusCode == 200) {
    final user = data['user'];

    return UserEntity(
      id: user['id'] ?? user['_id'],
      name: user['name'],
      email: user['email'],
      password: '',
      isAdmin: user['isAdmin'] ?? false,
      token: data['token'], // ✅ Attach the token here
    );
  } else {
    throw Exception(data['message'] ?? 'Login failed');
  }
}


}
