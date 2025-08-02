import 'package:rent_my_fit/features/auth/domain/repository/user_repository.dart';
import 'package:rent_my_fit/features/profile/domain/entity/profile_entity.dart';

class GetProfile {
  final UserRepository repository;

  GetProfile(this.repository);

  /// Returns the current user’s profile, or null if none.
  Future<ProfileEntity?> call() {
    return repository.getProfile();
  }
}
