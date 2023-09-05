import 'dart:io';

import 'package:flutter/material.dart';
import 'package:laravel_smapp/consts/global_variables.dart';
import 'package:laravel_smapp/models/api_response.dart';
import 'package:laravel_smapp/models/user_model.dart';
import 'package:laravel_smapp/screens/bottom_nav_bar.dart';
import 'package:laravel_smapp/services/user_service.dart';
import 'package:laravel_smapp/utils/navigate_to.dart';
import 'package:laravel_smapp/utils/pick_image.dart';
import 'package:laravel_smapp/widgets/show_error_message.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> registerUser(
    BuildContext context,
    bool mounted,
    TextEditingController emailTEC,
    TextEditingController usernameTEC,
    TextEditingController passwordTEC,
    File? file,
  ) async {
    _isLoading = true;
    ApiResponse response = await UserService().register(
      emailTEC.text,
      usernameTEC.text,
      passwordTEC.text,
      getStringImage(file) ?? defaultPPUrl,
    );

    if (response.error == null) {
      if (!mounted) return;
      saveAndGoHome(context, mounted, response.data as UserModel);
    } else {
      if (!mounted) return;
      HandleError().showErrorMessage(context, '${response.error}');
    }
    _isLoading = false;
  }

  // login user
  Future<void> loginUser(
    BuildContext context,
    bool mounted,
    TextEditingController emailTEC,
    TextEditingController passwordTEC,
  ) async {
    _isLoading = true;
    ApiResponse response = await UserService().login(
      emailTEC.text,
      passwordTEC.text,
    );

    if (response.error == null) {
      if (!mounted) return;
      saveAndGoHome(context, mounted, response.data as UserModel);
    } else {
      if (!mounted) return;
      HandleError().showErrorMessage(context, '${response.error}');
    }
    _isLoading = false;
  }

  Future<void> saveAndGoHome(
    BuildContext context,
    bool mounted,
    UserModel userModel,
  ) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('token', userModel.token ?? '');
    await pref.setInt('userId', userModel.id ?? 0);
    if (!mounted) return;
    NavigateSkills().pushReplacementTo(context, const MyBottomNavBar());
  }
}
