import 'package:rent_my_fit/features/auth/data/data_source/user_local_datasource.dart';
import 'package:rent_my_fit/features/auth/data/model/user_hive_model.dart';
import 'package:rent_my_fit/features/auth/domain/entity/user_entity.dart' as user_entity;
import 'package:rent_my_fit/features/profile/domain/entity/profile_entity.dart' as profile_entity;
import 'package:rent_my_fit/features/auth/domain/repository/user_repository.dart';

class UserLocalRepository implements UserRepository {
  final UserLocalDatasource datasource;

  UserLocalRepository(this.datasource);

  @override
  Future<void> registerUser(user_entity.UserEntity user) async {
    final hiveModel = UserHiveModel.fromEntity(user);
    await datasource.saveUser(hiveModel);
  }

  @override
  Future<user_entity.UserEntity> loginUser(String email, String password) async {
    final hiveModel = await datasource.getUser(email);
    if (hiveModel == null) {
      throw Exception("User not found");
    }

    if (hiveModel.password != password) {
      throw Exception("Invalid credentials");
    }

    return hiveModel.toEntity();
  }

  /// Fetch the current logged-in user's profile
  @override
  Future<profile_entity.ProfileEntity?> getProfile() async {
    // Assuming you store the current user email somewhere or last logged-in user
    final hiveModel = await datasource.getCurrentUser();
    if (hiveModel == null) return null;

    return profile_entity.ProfileEntity(
  name: hiveModel.name,
  email: hiveModel.email,
);

  }

  /// Update the current logged-in user's profile
  @override
  Future<void> updateProfile(profile_entity.ProfileEntity profile) async {
    final hiveModel = await datasource.getCurrentUser();
    if (hiveModel == null) {
      throw Exception("No logged-in user to update");
    }

    // Update Hive object
    hiveModel
      ..name = profile.name
      ..email = profile.email;
    await hiveModel.save();
  }
}
