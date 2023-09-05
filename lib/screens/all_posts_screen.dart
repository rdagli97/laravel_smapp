import 'package:flutter/material.dart';
import 'package:laravel_smapp/consts/palette.dart';
import 'package:laravel_smapp/models/post_model.dart';
import 'package:laravel_smapp/providers/like_controller.dart';
import 'package:laravel_smapp/providers/post_controller.dart';
import 'package:laravel_smapp/providers/user_controller.dart';
import 'package:laravel_smapp/screens/comment_screen.dart';
import 'package:laravel_smapp/screens/post_detail_screen.dart';
import 'package:laravel_smapp/screens/profile_screen.dart';
import 'package:laravel_smapp/screens/send_post_screen.dart';
import 'package:laravel_smapp/utils/add_padding.dart';
import 'package:laravel_smapp/utils/navigate_to.dart';
import 'package:laravel_smapp/widgets/custom_post.dart';
import 'package:provider/provider.dart';

class AllPostsScreen extends StatefulWidget {
  const AllPostsScreen({super.key});

  @override
  State<AllPostsScreen> createState() => _AllPostsScreenState();
}

class _AllPostsScreenState extends State<AllPostsScreen> {
  // get all posts
  Future<void> retrievePosts() async {
    await context.read<PostController>().retrievePosts(context, mounted);
  }

  // get user detail
  Future<void> getUser() async {
    await context.read<UserController>().getUser(context, mounted);
  }

  // like or unlike
  Future<void> _handlePostLike(int postId) async {
    await context
        .read<LikeController>()
        .handlePostLike(context, mounted, postId);
  }

  // post delete
  Future<void> _postDelete(int postId) async {
    await context.read<PostController>().postDelete(context, mounted, postId);
  }

  @override
  void initState() {
    getUser();
    retrievePosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Palette palette = Palette.fromDarkMode(context);
    final postWatch = context.watch<PostController>();
    final postRead = context.read<PostController>();
    final userWatch = context.watch<UserController>();
    return Scaffold(
      body: postWatch.isLoading && userWatch.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: retrievePosts,
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      padding:
                          AddPadding.symmetric(horizontal: 15, vertical: 13),
                      itemCount: postRead.allPostList.length,
                      itemBuilder: (context, index) {
                        PostModel postModel = postWatch.allPostList[index];
                        return CustomPost(
                          ppUrl: '${postModel.user?.image}',
                          postModel: postModel,
                          postClicked: () {
                            NavigateSkills().pushTo(
                              context,
                              PostDetailScreen(postModel: postModel),
                            );
                          },
                          commentClick: () {
                            NavigateSkills().pushTo(
                              context,
                              CommentScreen(
                                postId: postModel.id,
                              ),
                            );
                          },
                          likeClick: () {
                            _handlePostLike(postModel.id ?? 0);
                          },
                          ppClick: () {
                            postRead.clearPostLists();
                            NavigateSkills().pushTo(
                              context,
                              ProfileScreen(
                                postModel: postModel,
                              ),
                            );
                          },
                          iconData: postModel.selfLiked == true
                              ? Icons.favorite
                              : Icons.favorite_border,
                          onSelected: (value) {
                            if (value == 'edit' &&
                                postModel.user!.id == postRead.allUserId) {
                              // edit
                              NavigateSkills().pushTo(
                                  context,
                                  SendPostScreen(
                                    postModel: postModel,
                                  ));
                            } else {
                              // delete
                              if (postModel.user!.id == postRead.allUserId) {
                                _postDelete(postModel.id ?? 0);
                              }
                            }
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: palette.primaryColor,
        onPressed: () {
          NavigateSkills().pushTo(
            context,
            const SendPostScreen(),
          );
        },
        child: Icon(
          Icons.add,
          color: palette.textColor,
        ),
      ),
    );
  }
}
