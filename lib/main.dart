import 'package:flutter/material.dart';
import 'package:rent_my_fit/app/app.dart';
import 'package:rent_my_fit/app/service_locator.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await init(); // initialize GetIt here

  runApp(const App());
}
