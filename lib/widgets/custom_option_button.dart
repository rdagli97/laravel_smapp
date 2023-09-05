import 'package:flutter/material.dart';
import 'package:laravel_smapp/consts/palette.dart';
import 'package:laravel_smapp/utils/add_padding.dart';

class CustomOptionButton extends StatelessWidget {
  const CustomOptionButton({
    super.key,
    this.color,
    this.child,
    required this.onTap,
  });
  final Color? color;
  final Widget? child;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    Palette palette = Palette.fromDarkMode(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: AddPadding.symmetric(horizontal: 15, vertical: 13),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: color ?? palette.blue,
        ),
        child: Center(child: child),
      ),
    );
  }
}
