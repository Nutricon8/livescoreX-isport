import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/*class ThemeProvider {
  static const String _themeModeKey = 'themeMode';

  // Get the saved theme mode from SharedPreferences
  static Future<ThemeMode> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt(_themeModeKey) ?? ThemeMode.system.index;
    return ThemeMode.values[themeIndex];
  }

  // Save the theme mode to SharedPreferences
  static Future<void> setThemeMode(ThemeMode themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeModeKey, themeMode.index);
  }
}*/


// Helper class for managing theme persistence
class ThemeProvider {
  static const String themeKey = 'theme_mode';

  // Get the saved theme mode from SharedPreferences
  static Future<ThemeMode> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt(themeKey) ?? 0; // Default to light mode
    return ThemeMode.values[themeIndex];
  }

  // Save the theme mode to SharedPreferences
  static Future<void> setThemeMode(ThemeMode themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(themeKey, themeMode.index);
  }
}