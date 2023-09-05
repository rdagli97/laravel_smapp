import 'package:flutter/material.dart';
import 'package:laravel_smapp/screens/bottom_nav_bar.dart';
import 'package:laravel_smapp/utils/navigate_to.dart';

class UpdateScreen extends StatefulWidget {
  const UpdateScreen({super.key});

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  @override
  void initState() {
    Future.delayed(
      const Duration(seconds: 2),
      () {
        NavigateSkills().pushReplacementTo(
          context,
          const MyBottomNavBar(),
        );
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
