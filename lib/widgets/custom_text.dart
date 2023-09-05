import 'package:flutter/material.dart';
import 'package:laravel_smapp/consts/palette.dart';

class CustomText extends StatelessWidget {
  const CustomText({
    super.key,
    required this.text,
    this.fontSize,
    this.fontStyle,
    this.fontWeight,
    this.isClickable = false,
    this.onTap,
    this.color,
    this.overflow,
    this.maxLine,
  });
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final FontStyle? fontStyle;
  final bool? isClickable;
  final Function()? onTap;
  final Color? color;
  final TextOverflow? overflow;
  final int? maxLine;

  @override
  Widget build(BuildContext context) {
    Palette palette = Palette.fromDarkMode(context);
    return isClickable == false
        ? Text(
            text,
            overflow: overflow,
            maxLines: maxLine ?? 1,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: fontWeight,
              fontStyle: fontStyle,
              color: color ?? palette.textColor,
            ),
          )
        : GestureDetector(
            onTap: onTap,
            child: Text(
              text,
              overflow: overflow,
              maxLines: maxLine ?? 1,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: fontWeight,
                fontStyle: fontStyle,
                color: color ?? palette.textColor,
              ),
            ),
          );
  }
}
