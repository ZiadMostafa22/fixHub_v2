import 'package:flutter/material.dart';

class LocalizationService {
  static const List<Locale> supportedLocales = [
    Locale('en', 'US'),
    Locale('ar', 'SA'),
  ];

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = [
    // Localization delegates will be added when needed
  ];

  static Locale currentLocale = const Locale('en', 'US');

  static Future<void> initialize() async {
    // TODO: Load saved locale from SharedPreferences
    // For now, default to English
    currentLocale = const Locale('en', 'US');
  }

  static Future<void> setLocale(Locale locale) async {
    if (supportedLocales.contains(locale)) {
      currentLocale = locale;
      // TODO: Save to SharedPreferences
    }
  }

  static bool isRTL() {
    return currentLocale.languageCode == 'ar';
  }

  static TextDirection getTextDirection() {
    return isRTL() ? TextDirection.rtl : TextDirection.ltr;
  }
}
