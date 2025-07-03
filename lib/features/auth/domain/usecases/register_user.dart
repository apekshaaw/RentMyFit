import '../entity/user_entity.dart';
import '../repository/user_repository.dart';

class RegisterUser {
  final UserRepository repository;

  RegisterUser(this.repository);

  Future<void> call(UserEntity user) async {
    return await repository.registerUser(user);
  }
}
