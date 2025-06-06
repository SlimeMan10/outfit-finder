import 'package:flutter/material.dart';

class LocaleChangeNotifier extends ChangeNotifier {
  Locale _locale = const Locale('en');
  Locale get locale => _locale;
  
  void setLocale(Locale locale) {
    _locale = locale;
    notifyListeners();
  }
} 