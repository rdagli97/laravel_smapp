import 'package:flutter/material.dart';
import 'package:laravel_smapp/consts/palette.dart';
import 'package:laravel_smapp/utils/add_padding.dart';
import 'package:laravel_smapp/widgets/custom_text.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.width,
    this.height,
    required this.text,
    required this.onTap,
    this.fontWeight,
    this.radius = 12,
    this.color,
  });
  final double? width;
  final double? height;
  final String text;
  final Function()? onTap;
  final FontWeight? fontWeight;
  final double radius;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    Palette palette = Palette.fromDarkMode(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: AddPadding.symmetric(horizontal: 15, vertical: 13),
        width: width ?? MediaQuery.of(context).size.width,
        height: height,
        decoration: BoxDecoration(
          color: color ?? palette.buttonColor,
          borderRadius: BorderRadius.circular(radius),
        ),
        child: Center(
          child: CustomText(
            text: text,
            fontWeight: fontWeight,
            color: palette.primaryColor,
          ),
        ),
      ),
    );
  }
}
