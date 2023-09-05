import 'package:flutter/material.dart';
import 'package:laravel_smapp/models/user_model.dart';
import 'package:laravel_smapp/providers/user_controller.dart';
import 'package:laravel_smapp/widgets/custom_appbar_action.dart';
import 'package:laravel_smapp/widgets/custom_follow_model.dart';
import 'package:provider/provider.dart';

class FollowingScreen extends StatefulWidget {
  const FollowingScreen({super.key, required this.userModel});
  final UserModel? userModel;

  @override
  State<FollowingScreen> createState() => _FollowingScreenState();
}

class _FollowingScreenState extends State<FollowingScreen> {
  // get following users

  Future<void> getFollowingUsers() async {
    await context
        .read<UserController>()
        .getFollowingUsers(context, mounted, widget.userModel?.id ?? 0);
  }

  @override
  void initState() {
    getFollowingUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userWatch = context.watch<UserController>();
    return Scaffold(
      appBar: AppBar(
        actions: const [
          CustomAppBarAction(),
        ],
      ),
      body: userWatch.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: userWatch.followingUsers.length,
              itemBuilder: (context, index) {
                final UserModel? userModel = userWatch.followingUsers[index];
                return CustomFollowModel(userModel: userModel);
              },
            ),
    );
  }
}
