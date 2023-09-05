import 'package:flutter/material.dart';
import 'package:laravel_smapp/consts/global_variables.dart';
import 'package:laravel_smapp/models/api_response.dart';
import 'package:laravel_smapp/models/user_model.dart';
import 'package:laravel_smapp/screens/auth/login_screen.dart';
import 'package:laravel_smapp/services/comment_service.dart';
import 'package:laravel_smapp/services/shared_preference.dart';
import 'package:laravel_smapp/utils/navigate_to.dart';
import 'package:laravel_smapp/widgets/show_error_message.dart';

class CommentController extends ChangeNotifier {
  List<dynamic> _commentList = [];
  List<dynamic> get commentList => _commentList;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  int _userId = 0;
  int get userId => _userId;

  int _editCommentId = 0;
  int get editCommentId => _editCommentId;

  UserModel? _user;
  UserModel? get user => _user;

  // get comment of this post
  Future<void> getComments(
    BuildContext context,
    bool mounted,
    int? postId,
  ) async {
    _isLoading = true;
    _userId = await SharedPreference().getUserId();

    ApiResponse response =
        await CommentService().getComments(postId: postId ?? 0);

    if (response.error == null) {
      _commentList = response.data as List<dynamic>;
    } else if (response.error == unauthorized) {
      if (!mounted) return;
      logoutAndGoLoginScreen(context);
    } else {
      if (!mounted) return;
      HandleError().showErrorMessage(context, '${response.error}');
    }
    _isLoading = false;
    notifyListeners();
  }

  // create comment
  Future<void> createComment(BuildContext context, bool mounted, int? postId,
      TextEditingController commentController) async {
    _isLoading = true;
    ApiResponse response = await CommentService().createComment(
      postId: postId ?? 0,
      comment: commentController.text,
    );

    if (response.error == null) {
      commentController.clear();
      if (!mounted) return;
      getComments(context, mounted, postId);
    } else if (response.error == unauthorized) {
      if (!mounted) return;
      logoutAndGoLoginScreen(context);
    } else {
      if (!mounted) return;
      HandleError().showErrorMessage(context, '${response.error}');
    }
    _isLoading = false;
    notifyListeners();
  }

  // delete comment
  Future<void> deleteComment(
      BuildContext context, bool mounted, int commentId, int? postId) async {
    _isLoading = true;
    ApiResponse response = await CommentService().deleteComment(
      commentId: _editCommentId,
    );

    if (response.error == null) {
      if (!mounted) return;
      getComments(context, mounted, postId);
    } else if (response.error == unauthorized) {
      if (!mounted) return;
      logoutAndGoLoginScreen(context);
    } else {
      if (!mounted) return;
      HandleError().showErrorMessage(context, '${response.error}');
    }
    _isLoading = false;
    notifyListeners();
  }

  //

  void logoutAndGoLoginScreen(BuildContext context) {
    SharedPreference().logout().then(
          (value) => NavigateSkills().pushReplacementTo(
            context,
            const LoginScreen(),
          ),
        );
  }

  void initialEditCommentId(int? commentId) {
    _editCommentId = commentId ?? 0;
    notifyListeners();
  }
}
