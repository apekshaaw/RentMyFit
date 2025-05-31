import 'package:flutter/material.dart';
import 'view/splash_view.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashView(),
      theme: ThemeData(
        primaryColor: const Color(0xFFab1d79),
        fontFamily: 'AncizarSans',
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFab1d79),
          centerTitle: true,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFab1d79),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: const Color(0xFFab1d79)),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(fontFamily: 'IntroRust', fontSize: 32),
          headlineMedium: TextStyle(fontFamily: 'IntroRust', fontSize: 24),
        ),
      ),
    );
  }
}
