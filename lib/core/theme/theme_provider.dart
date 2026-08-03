import 'package:flutter/material.dart';

class ThemeNotifier extends ChangeNotifier {
  Brightness _brightness = Brightness.dark;
  Brightness get brightness => _brightness;
  bool get isDark => _brightness == Brightness.dark;

  void toggleTheme() {
    _brightness = _brightness == Brightness.dark ? Brightness.light : Brightness.dark;
    notifyListeners();
  }

  void setDark(bool dark) {
    _brightness = dark ? Brightness.dark : Brightness.light;
    notifyListeners();
  }
}
