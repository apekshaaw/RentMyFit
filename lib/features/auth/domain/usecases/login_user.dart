import '../entity/user_entity.dart';
import '../repository/user_repository.dart';

class LoginUser {
  final UserRepository repository;

  LoginUser(this.repository);

  Future<UserEntity?> call(String email, String password) async {
    return await repository.loginUser(email, password);
  }
}
