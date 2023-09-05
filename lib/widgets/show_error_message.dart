import 'package:flutter/material.dart';
import 'package:laravel_smapp/widgets/custom_text.dart';

class HandleError {
  showErrorMessage(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(milliseconds: 1000),
        backgroundColor: Colors.grey,
        content: CustomText(text: text),
      ),
    );
  }
}
