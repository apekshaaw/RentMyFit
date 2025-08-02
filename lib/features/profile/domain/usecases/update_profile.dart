import 'package:rent_my_fit/features/auth/domain/repository/user_repository.dart';
import 'package:rent_my_fit/features/profile/domain/entity/profile_entity.dart';

class UpdateProfile {
  final UserRepository repository;

  UpdateProfile(this.repository);

  /// Sends updated profile data to repo
  Future<void> call(ProfileEntity profile) {
    return repository.updateProfile(profile);
  }
}
