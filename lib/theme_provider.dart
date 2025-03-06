import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData;

  ThemeProvider(this._themeData);

  ThemeData get themeData => _themeData;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  Future<void> toggleTheme(bool isDark) async {
    var prefs = await SharedPreferences.getInstance();
    if (isDark) {
      _themeData = ThemeData.dark();
      await prefs.setBool('isDarkMode', true);
    } else {
      _themeData = ThemeData.light();
      await prefs.setBool('isDarkMode', false);
    }
    notifyListeners();
  }

  Future<void> loadThemeFromPrefs() async {
    var prefs = await SharedPreferences.getInstance();
    bool isDarkMode = prefs.getBool('isDarkMode') ?? false;
    _themeData = isDarkMode ? ThemeData.dark() : ThemeData.light();
    notifyListeners();
  }
}
