import 'package:flutter/material.dart';
import 'package:laravel_smapp/consts/palette.dart';

class CustomCircleAvatar extends StatelessWidget {
  const CustomCircleAvatar({
    super.key,
    this.isBorderEnabled = false,
    required this.image,
  });
  final bool isBorderEnabled;
  final DecorationImage? image;

  @override
  Widget build(BuildContext context) {
    final Palette palette = Palette.fromDarkMode(context);
    return Container(
      height: isBorderEnabled ? 90 : 50,
      width: isBorderEnabled ? 90 : 50,
      decoration: BoxDecoration(
        image: image,
        color: palette.black,
        borderRadius: BorderRadius.circular(360),
        border: isBorderEnabled
            ? Border.all(color: palette.primaryColor, width: 3)
            : null,
      ),
    );
  }
}
