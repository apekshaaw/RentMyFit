import 'package:flutter/material.dart';
import 'package:rent_my_fit/theme/theme.dart';
import 'package:rent_my_fit/view/splash_view.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashView(),
      theme: getApplicationTheme(),
    );
  }
}
