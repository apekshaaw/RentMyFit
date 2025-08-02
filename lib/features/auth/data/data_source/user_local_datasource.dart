import 'package:hive/hive.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../model/user_hive_model.dart';

class UserLocalDatasource {
  final Box<UserHiveModel> userBox;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  UserLocalDatasource(this.userBox);

  /// Save a new user
  Future<void> saveUser(UserHiveModel user) async {
    await userBox.put(user.email, user); // Use email as key
  }

  /// Fetch a user by email
  Future<UserHiveModel?> getUser(String email) async {
    return userBox.get(email);
  }

  /// Fetch the currently logged-in user (assume last entry is current user)
  Future<UserHiveModel?> getCurrentUser() async {
    if (userBox.isEmpty) return null;
    return userBox.values.last;
  }

  /// Update user
  Future<void> updateUser(UserHiveModel user) async {
    await user.save();
  }

  /// ✅ Retrieve token for API requests
  Future<String?> getToken() async {
  final user = await getCurrentUser();
  return user?.token;
}
}
