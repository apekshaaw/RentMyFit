import 'package:rent_my_fit/features/auth/data/data_source/user_local_datasource.dart';
import 'package:rent_my_fit/features/auth/data/model/user_hive_model.dart';
import 'package:rent_my_fit/features/auth/domain/entity/user_entity.dart';
import 'package:rent_my_fit/features/auth/domain/repository/user_repository.dart';

class UserLocalRepository implements UserRepository {
  final UserLocalDatasource datasource;

  UserLocalRepository(this.datasource);

  @override
  Future<void> registerUser(UserEntity user) async {
    final hiveModel = UserHiveModel.fromEntity(user);
    await datasource.saveUser(hiveModel);
  }

  @override
  Future<UserEntity> loginUser(String email, String password) async {
    final hiveModel = await datasource.getUser(email);
    if (hiveModel == null) {
      throw Exception("User not found");
    }

    if (hiveModel.password != password) {
      throw Exception("Invalid credentials");
    }

    return hiveModel.toEntity();
  }
}
