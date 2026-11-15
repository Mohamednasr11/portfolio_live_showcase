import 'package:flutter/material.dart';

enum AppLanguage { english, arabic }

class LanguageController extends ChangeNotifier {
  static final LanguageController instance = LanguageController._();

  LanguageController._();

  AppLanguage _currentLanguage = AppLanguage.english;

  AppLanguage get currentLanguage => _currentLanguage;
  bool get isArabic => _currentLanguage == AppLanguage.arabic;
  TextDirection get textDirection =>
      isArabic ? TextDirection.rtl : TextDirection.ltr;

  void toggleLanguage() {
    _currentLanguage = _currentLanguage == AppLanguage.english
        ? AppLanguage.arabic
        : AppLanguage.english;
    notifyListeners();
  }

  void setLanguage(AppLanguage language) {
    if (_currentLanguage != language) {
      _currentLanguage = language;
      notifyListeners();
    }
  }
}
