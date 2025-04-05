import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeProvider() {
    _loadThemePreference();
  }

  // Load the theme preference from local storage
  _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    notifyListeners();
  }

  // Toggle the theme and save the preference
  void toggleTheme(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = isDark;
    await prefs.setBool('isDarkMode', _isDarkMode);
    notifyListeners();
  }
}
