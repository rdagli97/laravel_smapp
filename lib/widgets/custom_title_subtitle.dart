import 'package:flutter/material.dart';
import 'package:laravel_smapp/utils/add_space.dart';
import 'package:laravel_smapp/widgets/custom_text.dart';

class TitleAndSubtitleColumnWidget extends StatelessWidget {
  const TitleAndSubtitleColumnWidget({
    super.key,
    required this.title,
    required this.subTitle,
    this.isClickable,
    this.onTap,
  });
  final String title;
  final String subTitle;
  final bool? isClickable;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return isClickable ?? false
        ? GestureDetector(
            onTap: onTap,
            child: Column(
              children: [
                CustomText(
                  text: title,
                  fontWeight: FontWeight.bold,
                ),
                AddSpace().vertical(3),
                CustomText(
                  text: subTitle,
                  fontWeight: FontWeight.w300,
                ),
              ],
            ),
          )
        : Column(
            children: [
              CustomText(
                text: title,
                fontWeight: FontWeight.bold,
              ),
              AddSpace().vertical(3),
              CustomText(
                text: subTitle,
                fontWeight: FontWeight.w300,
              ),
            ],
          );
  }
}
