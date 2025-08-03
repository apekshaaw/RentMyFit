import 'package:rent_my_fit/features/auth/data/data_source/user_remote_datasource.dart';
import 'package:rent_my_fit/features/auth/domain/entity/user_entity.dart';
import 'package:rent_my_fit/features/profile/domain/entity/profile_entity.dart';
import 'package:rent_my_fit/features/auth/domain/repository/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDatasource remoteDatasource;

  UserRepositoryImpl({required this.remoteDatasource});

  @override
  Future<void> registerUser(UserEntity user) async {
    await remoteDatasource.register(user.name, user.email, user.password);
  }

  @override
  Future<UserEntity> loginUser(String email, String password) async {
    final model = await remoteDatasource.login(email, password);
    return UserEntity(name: model.name, email: model.email, password: model.password);
  }

  @override
  Future<ProfileEntity?> getProfile() async {
    return await remoteDatasource.fetchProfile();
  }

  @override
  Future<void> updateProfile(ProfileEntity profile) async {
    await remoteDatasource.updateProfile(profile);
  }
}
