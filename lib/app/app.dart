import 'package:flutter/material.dart';
import '../features/splash/presentation/view/splash_view.dart';
import 'theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Adora',
      debugShowCheckedModeBanner: false,
      theme: getApplicationTheme(),
      home: const SplashView(),
    );
  }
}
