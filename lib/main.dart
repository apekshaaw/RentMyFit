import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rent_my_fit/app/app.dart';
import 'package:rent_my_fit/app/service_locator.dart';
import 'package:rent_my_fit/features/auth/data/model/user_hive_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(UserHiveModelAdapter());

  await init(); 

  runApp(const App());
}
