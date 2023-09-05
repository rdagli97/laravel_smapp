import 'dart:io';

import 'package:flutter/material.dart';
import 'package:laravel_smapp/consts/global_variables.dart';
import 'package:laravel_smapp/models/api_response.dart';
import 'package:laravel_smapp/models/user_model.dart';
import 'package:laravel_smapp/screens/auth/login_screen.dart';
import 'package:laravel_smapp/services/shared_preference.dart';
import 'package:laravel_smapp/services/user_service.dart';
import 'package:laravel_smapp/utils/navigate_to.dart';
import 'package:laravel_smapp/utils/pick_image.dart';
import 'package:laravel_smapp/widgets/show_error_message.dart';

class UserController extends ChangeNotifier {
  UserModel? _user;
  UserModel? get user => _user;

  UserModel? _userWithCounts;
  UserModel? get userWithCounts => _userWithCounts;

  List<dynamic> _followingUsers = [];
  List<dynamic> get followingUsers => _followingUsers;

  List<dynamic> _followerUsers = [];
  List<dynamic> get followerUsers => _followerUsers;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<int> _followersIds = [];
  List<int> get followerIds => _followersIds;

  final int _followerCount = 0;
  int get followerCount => _followerCount;

  bool _amIFollowingIt = false;
  bool get amIFollowingIt => _amIFollowingIt;

  // get user detail
  Future<void> getUser(BuildContext context, bool mounted) async {
    _isLoading = true;
    ApiResponse response = await UserService().getUserDetails();

    if (response.error == null) {
      _user = response.data as UserModel;
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

  // get user by id with counts
  Future<void> getUserById(
    BuildContext context,
    bool mounted,
    int userId,
  ) async {
    _isLoading = true;
    ApiResponse response = await UserService().getUserById(userId);

    if (response.error == null) {
      _userWithCounts = response.data as UserModel;
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

  // get user's followers id by userid
  Future<void> getFollowerIdsByUserId(
    BuildContext context,
    bool mounted,
    int userId,
  ) async {
    _isLoading = true;
    ApiResponse response = await UserService().getFollowerIdsByUserId(userId);

    if (response.error == null) {
      _followersIds = response.data as List<int>;
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

  // update user
  Future<void> updateUser(
    BuildContext context,
    bool mounted,
    File? file,
  ) async {
    _isLoading = true;

    ApiResponse response = await UserService().updateUser(
      getStringImage(file) ?? defaultPPUrl,
    );
    if (response.error == null) {
      if (!mounted) return;
      HandleError().showErrorMessage(context, '${response.data}');
    } else if (response.error == unauthorized) {
      if (!mounted) return;
      logoutAndGoLoginScreen(context);
    } else {
      if (!mounted) return;
      HandleError().showErrorMessage(context, '${response.error}');
    }
    _isLoading = false;
  }

  // get followings users
  Future<void> getFollowingUsers(
    BuildContext context,
    bool mounted,
    int userId,
  ) async {
    _isLoading = true;
    ApiResponse response = await UserService().getFollowingUsers(userId);

    if (response.error == null) {
      _followingUsers = response.data as List<dynamic>;
    } else if (response.error == null) {
      if (!mounted) return;
      logoutAndGoLoginScreen(context);
    } else {
      if (!mounted) return;
      HandleError().showErrorMessage(context, '${response.error}');
    }
    _isLoading = false;
    notifyListeners();
  }

  // get follower users
  Future<void> getFollowerUsers(
    BuildContext context,
    bool mounted,
    int userId,
  ) async {
    _isLoading = true;
    ApiResponse response = await UserService().getFollowerUsers(userId);

    if (response.error == null) {
      _followerUsers = response.data as List<dynamic>;
    } else if (response.error == null) {
      if (!mounted) return;
      logoutAndGoLoginScreen(context);
    } else {
      if (!mounted) return;
      HandleError().showErrorMessage(context, '${response.error}');
    }
    _isLoading = false;
    notifyListeners();
  }

  // clear list
  Future<void> clearUserControllerList() async {
    _followerUsers.clear();
    _followingUsers.clear();
    notifyListeners();
  }

  // check follow
  Future<void> checkFollow(
    BuildContext context,
    bool mounted,
    int userId,
  ) async {
    await getFollowerIdsByUserId(context, mounted, userId);

    _amIFollowingIt = _followersIds.contains(_user?.id);
    notifyListeners();
  }

  logoutAndGoLoginScreen(BuildContext context) {
    SharedPreference().logout().then(
          (value) => NavigateSkills().pushReplacementTo(
            context,
            const LoginScreen(),
          ),
        );
    notifyListeners();
  }
}
