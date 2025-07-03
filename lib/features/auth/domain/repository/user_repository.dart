import '../entity/user_entity.dart';

abstract class UserRepository {
  Future<void> registerUser(UserEntity user);
  Future<UserEntity> loginUser(String email, String password);
}
