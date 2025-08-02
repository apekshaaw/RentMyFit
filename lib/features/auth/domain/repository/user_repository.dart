import '../entity/user_entity.dart' as user_entity;
import '../../../profile/domain/entity/profile_entity.dart' as profile_entity;

abstract class UserRepository {
  /// Registers a new user locally or remotely
  Future<void> registerUser(user_entity.UserEntity user);

  /// Logs in a user and returns their data
  Future<user_entity.UserEntity> loginUser(String email, String password);

  /// Fetch the current logged-in user's profile
  Future<profile_entity.ProfileEntity?> getProfile();

  /// Update the current logged-in user's profile
  Future<void> updateProfile(profile_entity.ProfileEntity profile);
}
