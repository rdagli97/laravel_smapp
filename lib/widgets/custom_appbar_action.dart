import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../consts/palette.dart';
import '../providers/light_mode_provider.dart';

class CustomAppBarAction extends StatelessWidget {
  const CustomAppBarAction({super.key});

  @override
  Widget build(BuildContext context) {
    final Palette palette = Palette.fromDarkMode(context);
    bool isDarkMode = Provider.of<LightMode>(context, listen: true).isDarkMode;
    return IconButton(
      onPressed: () {
        context.read<LightMode>().changeLightMode();
      },
      icon: isDarkMode
          ? Icon(
              Icons.light_mode,
              color: palette.iconColor,
            )
          : Icon(
              Icons.dark_mode,
              color: palette.iconColor,
            ),
    );
  }
}
