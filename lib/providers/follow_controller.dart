import 'package:flutter/material.dart';
import 'package:laravel_smapp/consts/global_variables.dart';
import 'package:laravel_smapp/models/api_response.dart';
import 'package:laravel_smapp/screens/auth/login_screen.dart';
import 'package:laravel_smapp/services/follow_service.dart';
import 'package:laravel_smapp/services/shared_preference.dart';
import 'package:laravel_smapp/utils/navigate_to.dart';
import 'package:laravel_smapp/widgets/show_error_message.dart';

class FollowController extends ChangeNotifier {
  Future<void> followOrUnfollow(
    BuildContext context,
    bool mounted,
    int userId,
  ) async {
    ApiResponse response =
        await FollowService().followOrUnfollow(userId: userId);

    if (response.error == null) {
      if (!mounted) return;
      HandleError().showErrorMessage(context, response.data as String);
    } else if (response.error == unauthorized) {
      if (!mounted) return;
      logoutAndPushLogin(context);
    } else {
      if (!mounted) return;
      HandleError().showErrorMessage(context, '${response.error}');
    }
  }

  void logoutAndPushLogin(BuildContext context) {
    SharedPreference().logout().then((value) => {
          NavigateSkills().pushReplacementTo(
            context,
            const LoginScreen(),
          ),
        });
  }
}
