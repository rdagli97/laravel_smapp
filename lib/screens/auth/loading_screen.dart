import 'package:flutter/material.dart';
import 'package:laravel_smapp/consts/global_variables.dart';
import 'package:laravel_smapp/models/api_response.dart';
import 'package:laravel_smapp/screens/auth/login_screen.dart';
import 'package:laravel_smapp/screens/bottom_nav_bar.dart';
import 'package:laravel_smapp/services/shared_preference.dart';
import 'package:laravel_smapp/services/user_service.dart';
import 'package:laravel_smapp/utils/navigate_to.dart';
import 'package:laravel_smapp/widgets/show_error_message.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  Future<void> _loadUserInfo() async {
    String token = await SharedPreference().getToken();
    if (token == '') {
      goToLoginScreen();
    } else {
      ApiResponse response = await UserService().getUserDetails();
      if (response.error == null) {
        goToHomeScreen();
      } else if (response.error == unauthorized) {
        goToLoginScreen();
      } else {
        if (!mounted) return;
        HandleError().showErrorMessage(context, '${response.error}');
      }
    }
  }

  void goToLoginScreen() {
    NavigateSkills().pushReplacementTo(
      context,
      const LoginScreen(),
    );
  }

  void goToHomeScreen() {
    NavigateSkills().pushReplacementTo(
      context,
      const MyBottomNavBar(),
    );
  }

  @override
  void initState() {
    _loadUserInfo();
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
