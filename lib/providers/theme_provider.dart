import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeProvider({
    ThemeMode initialMode = ThemeMode.system,
  }) : _themeMode = initialMode;

  ThemeMode _themeMode;

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  void setThemeMode(ThemeMode mode) {
    if (_themeMode == mode) return;
    _themeMode = mode;
    notifyListeners();
  }

  void toggleTheme() {
    if (_themeMode == ThemeMode.dark) {
      setThemeMode(ThemeMode.light);
    } else {
      setThemeMode(ThemeMode.dark);
    }
  }
}

class AppTheme {
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF4C6FFF),
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: const Color(0xFFF8F8FB),
    cardColor: Colors.white,
    appBarTheme: const AppBarTheme(
      surfaceTintColor: Colors.transparent,
      elevation: 0,
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF4C6FFF),
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: const Color(0xFF0E1116),
    cardColor: const Color(0xFF1A1E23),
    appBarTheme: const AppBarTheme(
      surfaceTintColor: Colors.transparent,
      elevation: 0,
    ),
  );
}


