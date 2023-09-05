import 'package:flutter/material.dart';
import 'package:laravel_smapp/consts/palette.dart';

class CustomTextfield extends StatelessWidget {
  const CustomTextfield({
    super.key,
    required this.controller,
    required this.hintText,
    this.icon,
    this.obscureText,
    this.isPrefixEnabled = true,
    this.validator,
    this.keyboardType,
  });
  final TextEditingController controller;
  final IconData? icon;
  final bool? obscureText;
  final String hintText;
  final bool isPrefixEnabled;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    Palette palette = Palette.fromDarkMode(context);
    return TextFormField(
      validator: validator,
      controller: controller,
      obscureText: obscureText ?? false,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        prefixIcon: isPrefixEnabled ? Icon(icon) : null,
        prefixIconColor: palette.iconColor,
        hintText: hintText,
        hintStyle:
            TextStyle(fontStyle: FontStyle.italic, color: palette.textColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: palette.primaryColor,
      ),
    );
  }
}
