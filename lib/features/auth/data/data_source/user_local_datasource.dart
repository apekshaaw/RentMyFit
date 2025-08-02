import 'package:hive/hive.dart';
import '../model/user_hive_model.dart';

class UserLocalDatasource {
  final Box<UserHiveModel> userBox;

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
    // Get the last saved user (simple approach)
    return userBox.values.last;
  }

  /// Optionally update an existing user
  Future<void> updateUser(UserHiveModel user) async {
    await user.save();
  }
}
