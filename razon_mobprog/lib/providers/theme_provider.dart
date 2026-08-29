import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

// EDIT FIX Enhancement 2: This file previously contained a duplicate copy of
// CommentService (identical to services/comment_service.dart) instead of the
// ThemeProvider class that main.dart and settings_screen.dart both expect.
// That caused `ThemeProvider()` in main.dart to fail to compile. Rebuilt as
// the real ThemeProvider below, and it now persists the user's dark-mode
// preference via shared_preferences so the "user preference" toggle on the
// new Settings screen survives an app restart.
class ThemeProvider extends ChangeNotifier {
  static const String _themeKey = 'isDarkMode';

  bool _isDark = false;

  bool get isDark => _isDark;

  ThemeProvider() {
    _loadTheme();
  }

  // EDIT FIX Enhancement 2: load saved preference on startup.
  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _isDark = prefs.getBool(_themeKey) ?? false;
    notifyListeners();
  }

  // EDIT FIX Enhancement 2: toggle + persist so Settings screen's
  // "Dark Mode" switch actually sticks between sessions.
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
