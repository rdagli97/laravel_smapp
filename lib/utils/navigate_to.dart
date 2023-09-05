import 'package:flutter/material.dart';

class NavigateSkills {
  Future<void> pushTo(BuildContext context, Widget widget) async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => widget),
    );
  }

  Future<void> pushReplacementTo(BuildContext context, Widget widget) async {
    await Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => widget),
    );
  }
}
