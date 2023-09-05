import 'package:flutter/material.dart';

class AddPadding {
  static EdgeInsets symmetric({
    double horizontal = 0.0,
    double vertical = 0.0,
  }) {
    return EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical);
  }

  static EdgeInsets all(double all) {
    return EdgeInsets.all(all);
  }
}
