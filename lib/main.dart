import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rent_my_fit/app/service_locator.dart';
import 'package:rent_my_fit/features/auth/data/model/user_hive_model.dart';
import 'package:rent_my_fit/app/theme_notifier.dart';
import 'package:rent_my_fit/app/app.dart';
import 'package:proximity_sensor/proximity_sensor.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(UserHiveModelAdapter());
  await Hive.openBox<UserHiveModel>('userBox');
  await init();

  // Enable the “screen off” mode (required for some Android devices)
  ProximitySensor.setProximityScreenOff(true)
      .onError((e, s) => debugPrint('Could not enable screen-off: $e'));

  // Listen for proximity events
  ProximitySensor.events.listen((int event) {
  final isNear = event > 0;
  debugPrint('[Proximity] raw:$event  isNear:$isNear');
    themeNotifier.value = isNear 
    ? ThemeMode.dark 
    : ThemeMode.light;
});
  runApp(const App());
}
