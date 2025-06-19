import 'package:hive/hive.dart';
import 'package:rent_my_fit/features/auth/domain/entity/user_entity.dart';

part 'user_hive_model.g.dart';

@HiveType(typeId: 0)
class UserHiveModel extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String email;

  @HiveField(2)
  String password;

  UserHiveModel({
    required this.name,
    required this.email,
    required this.password,
  });

  UserEntity toEntity() {
    return UserEntity(
      name: name,
      email: email,
      password: password,
    );
  }

  factory UserHiveModel.fromEntity(UserEntity entity) {
    return UserHiveModel(
      name: entity.name,
      email: entity.email,
      password: entity.password,
    );
  }
}
