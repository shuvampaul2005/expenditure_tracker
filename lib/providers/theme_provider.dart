import 'package:flutter/material.dart';
import '../theme.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false; // Track theme state
  ThemeData _themeData = AppTheme.lightTheme;

  ThemeData get themeData => _themeData;
  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    _themeData = _isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme;
    notifyListeners(); // Notify UI to rebuild
  }
}
