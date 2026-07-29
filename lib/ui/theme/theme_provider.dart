import 'package:flutter/material.dart';
import 'package:project_nbt/ui/theme/dark_theme.dart';
import 'package:project_nbt/ui/theme/light_theme.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeData get themeData =>
      _themeMode == ThemeMode.light ? lightMode : darkMode;

  set themeData(ThemeData themeData) {
    _themeMode = themeData == lightMode ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }

  ThemeMode get themeMode => _themeMode;

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    print('Theme changed to: $_themeMode'); // Add for debugging
    notifyListeners();
  }
}