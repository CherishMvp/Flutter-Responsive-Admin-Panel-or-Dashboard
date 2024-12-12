import 'package:flutter/material.dart';

class LocaleController extends ChangeNotifier {
  Locale? _locale;

  Locale? get locale => _locale;

  void init(Locale locale) {
    _locale = locale;
  }

  void change(Locale locale) {
    if (_locale.toString() != locale.toString()) {
      _locale = locale;
      notifyListeners();
    }
  }
}
