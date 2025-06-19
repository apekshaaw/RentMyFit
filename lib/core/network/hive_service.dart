import 'package:hive/hive.dart';

class HiveService {
  Future<Box<T>> openBox<T>(String boxName) async {
    return await Hive.openBox<T>(boxName);
  }

  Future<void> closeBox(Box box) async {
    await box.close();
  }
}
