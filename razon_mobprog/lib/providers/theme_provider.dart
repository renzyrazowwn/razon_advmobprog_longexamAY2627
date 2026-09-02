import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';

class ThemeProvider extends ChangeNotifier {
  static const String _themeKey = 'isDarkMode';

// Enhancement 2
// holds the app state for light/dark mode
  bool _isDark = false;

  bool get isDark => _isDark;

// initializes theme provider and loads saved preference
  ThemeProvider() {
    _loadTheme();
  }

  // loads theme preference from shared preferences
  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _isDark = prefs.getBool(_themeKey) ?? false;
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isDark = !_isDark;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, _isDark);
  }

  ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: Colors.white,
      primaryColor: PEACE_PRIMARY,
      colorScheme: ColorScheme.fromSeed(
        seedColor: PEACE_PRIMARY,
        brightness: Brightness.light,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: PEACE_DARK_PRIMARY,
        elevation: 0,
      ),
      useMaterial3: true,
    );
  }

  ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF121212),
      primaryColor: PEACE_SECONDARY,
      colorScheme: ColorScheme.fromSeed(
        seedColor: PEACE_SECONDARY,
        brightness: Brightness.dark,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1E1E1E),
        foregroundColor: PEACE_TEXT_COLOR_WHITE,
        elevation: 0,
      ),
      useMaterial3: true,
    );
  }
}
