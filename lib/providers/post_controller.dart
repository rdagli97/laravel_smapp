import 'package:flutter/material.dart';
import 'package:laravel_smapp/consts/global_variables.dart';
import 'package:laravel_smapp/models/api_response.dart';
import 'package:laravel_smapp/models/post_model.dart';
import 'package:laravel_smapp/screens/auth/loading_screen.dart';
import 'package:laravel_smapp/screens/auth/login_screen.dart';
import 'package:laravel_smapp/services/post_service.dart';
import 'package:laravel_smapp/services/shared_preference.dart';
import 'package:laravel_smapp/utils/navigate_to.dart';
import 'package:laravel_smapp/widgets/show_error_message.dart';

class PostController extends ChangeNotifier {
  List<dynamic> _allPostList = [];
  List<dynamic> get allPostList => _allPostList;

  List<dynamic> _followingPostList = [];
  List<dynamic> get followingPostList => _followingPostList;

  List<dynamic> _currentUsersPostsList = [];
  List<dynamic> get currentUsersPostsList => _currentUsersPostsList;

  List<dynamic> _targetUsersPostsList = [];
  List<dynamic> get targetUsersPostsList => _targetUsersPostsList;

  List<dynamic> _likedPostsList = [];
  List<dynamic> get likedPostsList => _likedPostsList;

  List<dynamic> _currentUsersLikedPostList = [];
  List<dynamic> get currentUsersLikedPostList => _currentUsersLikedPostList;

  PostModel? _post;
  PostModel? get post => _post;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  int _allUserId = 0;
  int get allUserId => _allUserId;

  //int _followingUserId = 0;
  //int get followingUserId => _followingUserId;

  // get all posts
  Future<void> retrievePosts(
    BuildContext context,
    bool mounted,
  ) async {
    _isLoading = true;
    _allUserId = await SharedPreference().getUserId();
    ApiResponse response = await PostService().getAllPosts();
    if (response.error == null) {
      _allPostList = response.data as List<dynamic>;
    } else if (response.error == unauthorized) {
      if (!mounted) return;
      logoutAndPushLogin(context);
    } else {
      if (!mounted) return;
      HandleError().showErrorMessage(context, '${response.error}');
    }
    _isLoading = false;
    notifyListeners();
  }

  // get current user's posts
  Future<void> getCurrentUserPosts(
    BuildContext context,
    bool mounted,
  ) async {
    _isLoading = true;
    _allUserId = await SharedPreference().getUserId();
    ApiResponse response = await PostService().getCurrentUserPosts();
    if (response.error == null) {
      _currentUsersPostsList = response.data as List<dynamic>;
    } else if (response.error == unauthorized) {
      if (!mounted) return;
      logoutAndPushLogin(context);
    } else {
      if (!mounted) return;
      HandleError().showErrorMessage(context, '${response.error}');
    }
    _isLoading = false;
    notifyListeners();
  }

  // post delete
  Future<void> postDelete(
    BuildContext context,
    bool mounted,
    int postId,
  ) async {
    ApiResponse response = await PostService().deletePost(postId: postId);

    if (response.error == null) {
      if (!mounted) return;
      retrievePosts(context, mounted);
    } else if (response.error == unauthorized) {
      if (!mounted) return;
      logoutAndPushLogin(context);
    } else {
      if (!mounted) return;
      HandleError().showErrorMessage(context, '${response.error}');
    }
    notifyListeners();
  }

  // get following posts
  Future<void> retrieveFollowingPost(BuildContext context, bool mounted) async {
    _isLoading = true;

    _allUserId = await SharedPreference().getUserId();

    ApiResponse response = await PostService().getFollowingUsersPosts();
    if (response.error == null) {
      _followingPostList = response.data as List<dynamic>;
    } else if (response.error == unauthorized) {
      if (!mounted) return;
      logoutAndPushLogin(context);
    } else {
      if (!mounted) return;
      HandleError().showErrorMessage(context, '${response.error}');
    }
    if (response.error == 'There is no post to show yet...') {
      _followingPostList.clear();
    }
    _isLoading = false;
    notifyListeners();
  }

  // create post
  Future<void> createPost(
    BuildContext context,
    bool mounted,
    TextEditingController textEditingController,
  ) async {
    _isLoading = true;
    ApiResponse response =
        await PostService().createPost(textEditingController.text);

    if (response.error == null) {
      if (!mounted) return;
      NavigateSkills().pushReplacementTo(context, const LoadingScreen());
    } else if (response.error == unauthorized) {
      if (!mounted) return;
      logoutAndPushLogin(context);
    } else {
      if (!mounted) return;
      HandleError().showErrorMessage(context, '${response.error}');
    }
    _isLoading = false;
    notifyListeners();
  }

  // edit post
  Future<void> editPost(
    BuildContext context,
    bool mounted,
    int? postId,
    TextEditingController textEditingController,
  ) async {
    _isLoading = true;
    ApiResponse response = await PostService().updatePost(
      postId: postId ?? 0,
      postBody: textEditingController.text,
    );

    if (response.error == null) {
      if (!mounted) return;
      NavigateSkills().pushReplacementTo(context, const LoadingScreen());
    } else if (response.error == unauthorized) {
      if (!mounted) return;
      logoutAndPushLogin(context);
    } else {
      if (!mounted) return;
      HandleError().showErrorMessage(context, '${response.error}');
    }
    _isLoading = true;
  }

  // get user by id and show it's posts
  Future<void> getOneUsersPosts(
    BuildContext context,
    bool mounted,
    int userId,
  ) async {
    _isLoading = true;
    ApiResponse response = await PostService().getOneUsersPosts(userId: userId);

    _allUserId = await SharedPreference().getUserId();

    if (response.error == null) {
      _targetUsersPostsList = response.data as List<dynamic>;
    } else if (response.error == unauthorized) {
      if (!mounted) return;
      logoutAndPushLogin(context);
    } else {
      if (!mounted) return;
      HandleError().showErrorMessage(context, '${response.error}');
    }
  }

  // get liked post by user id
  Future<void> getLikedPostsById(
    BuildContext context,
    bool mounted,
    int userId,
  ) async {
    _isLoading = true;

    ApiResponse response =
        await PostService().getLikedPostsById(userId: userId);

    _allUserId = await SharedPreference().getUserId();

    if (response.error == null) {
      _likedPostsList = response.data as List<dynamic>;
    } else if (response.error == unauthorized) {
      if (!mounted) return;
      logoutAndPushLogin(context);
    }
    if (response.error == 'There is no liked post to show yet...') {
      _likedPostsList.clear();
    }
    _isLoading = false;
    notifyListeners();
  }

  //get current users liked post list
  Future<void> getCurrentULikedPosts(BuildContext context, bool mounted) async {
    _isLoading = true;

    ApiResponse response = await PostService().getLikedPostsByCurrentUser();

    _allUserId = await SharedPreference().getUserId();

    if (response.error == null) {
      _currentUsersLikedPostList = response.data as List<dynamic>;
    } else if (response.error == unauthorized) {
      if (!mounted) return;
      logoutAndPushLogin(context);
    }
    if (response.error == 'There is no liked post to show yet...') {
      _currentUsersLikedPostList.clear();
    }
    _isLoading = false;
    notifyListeners();
  }

  // clear lists
  Future<void> clearPostLists() async {
    _currentUsersLikedPostList.clear();
    _currentUsersPostsList.clear();
    _followingPostList.clear();
    _likedPostsList.clear();
    _targetUsersPostsList.clear();
    notifyListeners();
  }

  void logoutAndPushLogin(BuildContext context) {
    SharedPreference().logout().then((value) => {
          NavigateSkills().pushReplacementTo(
            context,
            const LoginScreen(),
          ),
        });
    notifyListeners();
  }
}
