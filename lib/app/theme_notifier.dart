import 'package:flutter/material.dart';

/// Handles app-wide theme toggling between light and dark.
class ThemeNotifier extends ValueNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.light);

  /// Toggle between Light and Dark themes
  void toggleTheme() {
    value = (value == ThemeMode.light) ? ThemeMode.dark : ThemeMode.light;
  }
}

/// ✅ Global instance to be accessed from anywhere in the app
final themeNotifier = ThemeNotifier();
