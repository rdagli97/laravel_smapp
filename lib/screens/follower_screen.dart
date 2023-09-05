import 'package:flutter/material.dart';
import 'package:laravel_smapp/models/user_model.dart';
import 'package:laravel_smapp/providers/user_controller.dart';
import 'package:laravel_smapp/widgets/custom_appbar_action.dart';
import 'package:laravel_smapp/widgets/custom_follow_model.dart';
import 'package:provider/provider.dart';

class FollowerScreen extends StatefulWidget {
  const FollowerScreen({super.key, required this.userModel});
  final UserModel? userModel;

  @override
  State<FollowerScreen> createState() => _FollowerScreenState();
}

class _FollowerScreenState extends State<FollowerScreen> {
  // get follower users

  Future<void> getFollowerUsers() async {
    await context
        .read<UserController>()
        .getFollowerUsers(context, mounted, widget.userModel?.id ?? 0);
  }

  @override
  void initState() {
    getFollowerUsers();
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
              itemCount: userWatch.followerUsers.length,
              itemBuilder: (context, index) {
                final UserModel? userModel = userWatch.followerUsers[index];
                return CustomFollowModel(userModel: userModel);
              },
            ),
    );
  }
}
