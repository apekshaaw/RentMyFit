import 'package:flutter/material.dart';

ThemeData getApplicationTheme() {
  return ThemeData(
    scaffoldBackgroundColor: Colors.white,
    primaryColor: const Color(0xFFab1d79),
    fontFamily: 'AncizarSans',

    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFab1d79),
      centerTitle: true,
      elevation: 0,
      titleTextStyle: TextStyle(
        fontFamily: 'IntroRust',
        fontSize: 20,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          fontFamily: 'AncizarSans',
        ),
        backgroundColor: const Color(0xFFab1d79),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        minimumSize: const Size(double.infinity, 50),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: const Color(0xFFab1d79),
        textStyle: const TextStyle(
          fontFamily: 'AncizarSans',
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    iconTheme: const IconThemeData(
      color: Colors.black,
    ),

    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontFamily: 'IntroRust',
        fontSize: 32,
      ),
      headlineMedium: TextStyle(
        fontFamily: 'IntroRust',
        fontSize: 24,
      ),
    ),
  );
}