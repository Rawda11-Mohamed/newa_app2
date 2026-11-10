import 'package:flutter/material.dart';

class AppSettingsProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  Locale _locale = const Locale('en');

  ThemeMode get themeMode => _themeMode;
  Locale get locale => _locale;
  String get selectedLanguage =>
      _locale.languageCode == 'ar' ? 'Arabic' : 'English';
  bool get isDark => _themeMode == ThemeMode.dark;

  void changeTheme(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void changeLanguage(String language) {
    switch (language.toLowerCase()) {
      case 'arabic':
      case 'ar':
        _locale = const Locale('ar');
        break;
      case 'english':
      case 'en':
      default:
        _locale = const Locale('en');
        break;
    }
    notifyListeners();
  }
}
