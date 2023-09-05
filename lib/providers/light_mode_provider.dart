import 'package:flutter/material.dart';

class LightMode extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  void changeLightMode() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}
