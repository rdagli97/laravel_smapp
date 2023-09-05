import 'package:flutter/material.dart';
import 'package:laravel_smapp/consts/palette.dart';
import 'package:laravel_smapp/models/post_model.dart';
import 'package:laravel_smapp/providers/like_controller.dart';
import 'package:laravel_smapp/providers/post_controller.dart';
import 'package:laravel_smapp/providers/user_controller.dart';
import 'package:laravel_smapp/screens/comment_screen.dart';
import 'package:laravel_smapp/screens/profile_screen.dart';
import 'package:laravel_smapp/screens/send_post_screen.dart';
import 'package:laravel_smapp/utils/add_padding.dart';
import 'package:laravel_smapp/utils/navigate_to.dart';
import 'package:laravel_smapp/widgets/custom_post.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // get following posts
  Future<void> _retrievePosts() async {
    await context
        .read<PostController>()
        .retrieveFollowingPost(context, mounted);
  }

  // post like / unlike
  Future<void> _handlePostLike(int postId) async {
    await context
        .read<LikeController>()
        .handlePostLike(context, mounted, postId);
  }

  // post delete
  Future<void> _postDelete(int postId) async {
    await context.read<PostController>().postDelete(context, mounted, postId);
  }

  // get user detail
  Future<void> _getUser() async {
    await context.read<UserController>().getUser(context, mounted);
  }

  @override
  void initState() {
    _getUser();
    _retrievePosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Palette palette = Palette.fromDarkMode(context);
    final watchPost = context.watch<PostController>();
    final readPost = context.read<PostController>();
    final watchUser = context.watch<UserController>();
    return Scaffold(
      body: watchPost.isLoading && watchUser.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: _retrievePosts,
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      padding:
                          AddPadding.symmetric(horizontal: 15, vertical: 13),
                      itemCount: readPost.followingPostList.length,
                      itemBuilder: (context, index) {
                        PostModel postModel =
                            watchPost.followingPostList[index];
                        return CustomPost(
                          ppUrl: '${postModel.user?.image}',
                          postModel: postModel,
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
                            _retrievePosts();
                          },
                          ppClick: () {
                            readPost.clearPostLists();
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
                                postModel.user!.id == readPost.allUserId) {
                              // edit
                              NavigateSkills().pushTo(
                                context,
                                SendPostScreen(
                                  postModel: postModel,
                                ),
                              );
                            } else {
                              // delete
                              if (postModel.user!.id == readPost.allUserId) {
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
          NavigateSkills().pushTo(context, const SendPostScreen());
        },
        child: Icon(
          Icons.add,
          color: palette.textColor,
        ),
      ),
    );
  }
}
