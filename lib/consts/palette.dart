import 'package:flutter/material.dart';
import 'package:laravel_smapp/providers/light_mode_provider.dart';
import 'package:provider/provider.dart';

class Palette {
  Color bgColor;
  Color primaryColor;
  Color iconColor;
  Color white;
  Color textColor;
  Color buttonColor;
  Color black;
  Color blue;
  Color pink;
  Color green;

  Palette({
    required this.bgColor,
    required this.primaryColor,
    required this.iconColor,
    required this.white,
    required this.textColor,
    required this.buttonColor,
    required this.black,
    required this.blue,
    required this.pink,
    required this.green,
  });

  factory Palette.fromDarkMode(BuildContext context) {
    bool isDarkMode = Provider.of<LightMode>(context, listen: true).isDarkMode;

    if (isDarkMode) {
      return Palette(
        bgColor: Colors.grey.shade800,
        primaryColor: Colors.grey.shade600,
        iconColor: Colors.white54,
        white: Colors.white,
        textColor: Colors.white60,
        buttonColor: Colors.grey.shade400,
        black: Colors.black,
        blue: const Color(0xff00f2ea),
        pink: const Color(0xffff0050),
        green: Colors.green,
      );
    } else {
      return Palette(
        bgColor: Colors.grey.shade100,
        primaryColor: Colors.grey.shade200,
        iconColor: Colors.black54,
        white: Colors.white,
        textColor: Colors.black87,
        buttonColor: Colors.grey.shade400,
        black: Colors.black,
        blue: const Color(0xff00f2ea),
        pink: const Color(0xffff0050),
        green: Colors.green,
      );
    }
  }
}
