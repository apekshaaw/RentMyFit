import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../entity/user_entity.dart';
import '../repository/user_repository.dart';

class LoginUser {
  final UserRepository repository;
  final FlutterSecureStorage _storage = const FlutterSecureStorage(); // ✅ Secure storage

  LoginUser(this.repository);

  Future<UserEntity?> call(String email, String password) async {
    final user = await repository.loginUser(email, password);

    if (user.token != null) {
      await _storage.write(key: 'token', value: user.token); // ✅ Save token
    }

    return user;
  }
}
