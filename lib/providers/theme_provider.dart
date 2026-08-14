import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeMode get themeMode {
    return _isDarkMode
        ? ThemeMode.dark
        : ThemeMode.light;
  }

  Future<void> loadTheme() async {
    final prefs =
    await SharedPreferences.getInstance();

    _isDarkMode =
        prefs.getBool('is_dark_mode') ?? false;

    notifyListeners();
  }

  Future<void> toggleTheme(
      bool isDark,
      ) async {
    _isDarkMode = isDark;

    notifyListeners();

    final prefs =
    await SharedPreferences.getInstance();

    await prefs.setBool(
      'is_dark_mode',
      isDark,
    );
  }
}