import 'package:hive/hive.dart';
import 'package:rent_my_fit/features/auth/data/model/user_hive_model.dart';

class UserLocalDatasource {
  static const String _userBoxName = 'user_box';

  Future<void> saveUser(UserHiveModel user) async {
    final box = await Hive.openBox<UserHiveModel>(_userBoxName);
    await box.put(user.email, user); 
    await box.close();
  }

  Future<UserHiveModel?> getUser(String username) async {
    final box = await Hive.openBox<UserHiveModel>(_userBoxName);
    final user = box.get(username);
    await box.close();
    return user;
  }
}
