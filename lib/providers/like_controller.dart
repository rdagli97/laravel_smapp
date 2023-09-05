import 'package:flutter/material.dart';
import 'package:laravel_smapp/consts/global_variables.dart';
import 'package:laravel_smapp/models/api_response.dart';
import 'package:laravel_smapp/providers/post_controller.dart';
import 'package:laravel_smapp/screens/auth/login_screen.dart';
import 'package:laravel_smapp/services/like_service.dart';
import 'package:laravel_smapp/services/shared_preference.dart';
import 'package:laravel_smapp/utils/navigate_to.dart';
import 'package:laravel_smapp/widgets/show_error_message.dart';
import 'package:provider/provider.dart';

class LikeController extends ChangeNotifier {
  // like
  Future<void> handlePostLike(
      BuildContext context, bool mounted, int postId) async {
    ApiResponse response = await LikeService().likeOrUnlike(postId: postId);

    if (response.error == null) {
      if (!mounted) return;
      context.read<PostController>().retrievePosts(context, mounted);
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
