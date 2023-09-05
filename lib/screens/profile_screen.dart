import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:laravel_smapp/consts/palette.dart';
import 'package:laravel_smapp/models/post_model.dart';
import 'package:laravel_smapp/models/user_model.dart';
import 'package:laravel_smapp/providers/follow_controller.dart';
import 'package:laravel_smapp/providers/like_controller.dart';
import 'package:laravel_smapp/providers/post_controller.dart';
import 'package:laravel_smapp/providers/user_controller.dart';
import 'package:laravel_smapp/screens/comment_screen.dart';
import 'package:laravel_smapp/screens/follower_screen.dart';
import 'package:laravel_smapp/screens/following_screen.dart';
import 'package:laravel_smapp/screens/send_post_screen.dart';
import 'package:laravel_smapp/screens/update_screen.dart';
import 'package:laravel_smapp/utils/add_padding.dart';
import 'package:laravel_smapp/utils/add_space.dart';
import 'package:laravel_smapp/utils/navigate_to.dart';
import 'package:laravel_smapp/widgets/custom_appbar_action.dart';
import 'package:laravel_smapp/widgets/custom_button.dart';
import 'package:laravel_smapp/widgets/custom_circle_avatar.dart';
import 'package:laravel_smapp/widgets/custom_option_button.dart';
import 'package:laravel_smapp/widgets/custom_post.dart';
import 'package:laravel_smapp/widgets/custom_text.dart';
import 'package:laravel_smapp/widgets/custom_title_subtitle.dart';
import 'package:laravel_smapp/widgets/show_error_message.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    this.postModel,
  });
  final PostModel? postModel;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _showPosts = true;
  File? _imageFile;
  final _picker = ImagePicker();

  // get all posts
  Future<void> _getAllPosts() async {
    await context.read<PostController>().retrievePosts(context, mounted);
  }

  // get current user's posts
  Future<void> _getCurrentUsersPosts() async {
    await context.read<PostController>().getCurrentUserPosts(context, mounted);
  }

  // get target users posts
  Future<void> _getTargetUsersPosts(int userId) async {
    await context
        .read<PostController>()
        .getOneUsersPosts(context, mounted, userId);
  }

  // get liked posts
  Future<void> _getLikedPostsList(int userId) async {
    await context
        .read<PostController>()
        .getLikedPostsById(context, mounted, userId);
  }

  // get current user liked posts
  Future<void> _getCurrentUsersLikedPosts() async {
    await context
        .read<PostController>()
        .getCurrentULikedPosts(context, mounted);
  }

  // get image
  Future<void> _getImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    } else {
      if (!mounted) return;
      HandleError().showErrorMessage(context, 'No image selected');
    }
  }

  // update user
  Future<void> _updateUser() async {
    await context
        .read<UserController>()
        .updateUser(context, mounted, _imageFile);
  }

  // get user
  Future<void> _getUser() async {
    await context.read<UserController>().getUser(context, mounted);
  }

  // get user with counts
  Future<void> _getUserWithCounts() async {
    await context.read<UserController>().getUserById(
          context,
          mounted,
          widget.postModel!.user!.id ?? 0,
        );
  }

  // get followerids by user id
  Future<void> _getFollowersIdsByUserId(int userId) async {
    await context
        .read<UserController>()
        .getFollowerIdsByUserId(context, mounted, userId);
  }

  // handle follow
  Future<void> _handleFollow(int userId) async {
    await context
        .read<FollowController>()
        .followOrUnfollow(context, mounted, userId);
    if (!mounted) return;
    await context
        .read<UserController>()
        .getUserById(context, mounted, widget.postModel!.user!.id ?? 0);
  }

  // handle like
  Future<void> _handlePostLike(int postId) async {
    await context
        .read<LikeController>()
        .handlePostLike(context, mounted, postId);
  }

  // handle delete
  Future<void> _postDelete(int postId) async {
    await context.read<PostController>().postDelete(context, mounted, postId);
  }

  Future<void> _checkFollow(int userId) async {
    await context.read<UserController>().checkFollow(context, mounted, userId);
  }

  void togglePostLike() {
    setState(() {
      _showPosts = !_showPosts;
    });
  }

  Future<void> initOperations() async {
    if (widget.postModel == null) {
      await _getCurrentUsersPosts();
      await _getUser();
      await _getAllPosts();
      await _getCurrentUsersLikedPosts();
    } else {
      await _getFollowersIdsByUserId(widget.postModel?.user?.id ?? 0);
      await _getUserWithCounts();
      await _getTargetUsersPosts(widget.postModel?.user?.id ?? 0);
      await _checkFollow(widget.postModel?.user?.id ?? 0);
      await _getLikedPostsList(widget.postModel?.user?.id ?? 0);
    }
  }

  @override
  void initState() {
    super.initState();
    initOperations();
  }

  @override
  Widget build(BuildContext context) {
    Palette palette = Palette.fromDarkMode(context);
    final userRead = context.read<UserController>();
    final userWatch = context.watch<UserController>();
    final postRead = context.read<PostController>();
    final postWatch = context.watch<PostController>();
    final currentUser = userRead.user ?? UserModel();
    final targetUser = widget.postModel?.user;
    return Scaffold(
      appBar: widget.postModel != null
          ? AppBar(
              actions: const [
                CustomAppBarAction(),
              ],
            )
          : null,
      body: userWatch.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Column(
                  children: [
                    // Circle avatar
                    widget.postModel == null
                        ? GestureDetector(
                            onTap: () async {
                              await _getImage();
                            },
                            child: _imageFile != null
                                ? CustomCircleAvatar(
                                    isBorderEnabled: true,
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: FileImage(_imageFile ?? File('')),
                                    ),
                                  )
                                : CircleAvatar(
                                    radius: 36,
                                    backgroundImage:
                                        NetworkImage('${currentUser.image}'),
                                  ),
                          )
                        : CircleAvatar(
                            radius: 36,
                            backgroundImage: NetworkImage(
                              targetUser?.image ?? "https://picsum.photos/200",
                            ),
                          ),
                    _imageFile != null
                        ? Column(
                            children: [
                              AddSpace().vertical(10),
                              SizedBox(
                                width: 50,
                                child: CustomOptionButton(
                                  color: palette.green,
                                  onTap: () async {
                                    await _updateUser();
                                    if (!mounted) return;
                                    NavigateSkills().pushReplacementTo(
                                        context, const UpdateScreen());
                                  },
                                  child: Icon(
                                    Icons.done,
                                    color: palette.white,
                                  ),
                                ),
                              ),
                              AddSpace().vertical(10),
                            ],
                          )
                        : AddSpace().vertical(20),
                    // username , email
                    TitleAndSubtitleColumnWidget(
                      title: widget.postModel == null
                          ? '${currentUser.username}'
                          : '${targetUser?.username}',
                      subTitle: widget.postModel == null
                          ? '${currentUser.email}'
                          : '${targetUser?.email}',
                    ),
                    AddSpace().vertical(20),
                    // Follow button
                    CustomButton(
                      color: userWatch.amIFollowingIt
                          ? palette.blue
                          : palette.buttonColor,
                      fontWeight: FontWeight.bold,
                      width: 150,
                      text: widget.postModel == null
                          ? "Sign out"
                          : userWatch.amIFollowingIt
                              ? 'Unfollow'
                              : "Follow",
                      onTap: () async {
                        if (widget.postModel == null) {
                          await context
                              .read<UserController>()
                              .logoutAndGoLoginScreen(context);
                        } else {
                          await _handleFollow(targetUser?.id ?? 0);
                          await _checkFollow(targetUser?.id ?? 0);
                        }
                      },
                    ),
                    AddSpace().vertical(20),
                    // Posts / Follower / Following
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TitleAndSubtitleColumnWidget(
                          title: widget.postModel == null
                              ? '${currentUser.postCount}'
                              : '${userRead.userWithCounts?.postCount}',
                          subTitle: "Posts",
                        ),
                        TitleAndSubtitleColumnWidget(
                          isClickable: true,
                          title: widget.postModel == null
                              ? '${userWatch.user!.followerCount}'
                              : '${userWatch.userWithCounts?.followerCount}',
                          subTitle: "Follower",
                          onTap: () {
                            userRead.clearUserControllerList();
                            NavigateSkills().pushTo(
                                context,
                                FollowerScreen(
                                  userModel: widget.postModel == null
                                      ? currentUser
                                      : context
                                          .read<UserController>()
                                          .userWithCounts,
                                ));
                          },
                        ),
                        TitleAndSubtitleColumnWidget(
                          title: widget.postModel == null
                              ? '${userWatch.user!.followingCount}'
                              : '${userWatch.userWithCounts?.followingCount}',
                          subTitle: "Following",
                          isClickable: true,
                          onTap: () {
                            userRead.clearUserControllerList();
                            NavigateSkills().pushTo(
                              context,
                              FollowingScreen(
                                userModel: widget.postModel == null
                                    ? currentUser
                                    : context
                                        .read<UserController>()
                                        .userWithCounts,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    AddSpace().vertical(40),
                    // posts / likes buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CustomText(
                          isClickable: true,
                          text: "Posts",
                          fontWeight:
                              _showPosts ? FontWeight.bold : FontWeight.w400,
                          onTap: () {
                            togglePostLike();
                          },
                        ),
                        CustomText(
                          isClickable: true,
                          text: "Likes",
                          fontWeight:
                              _showPosts ? FontWeight.w400 : FontWeight.bold,
                          onTap: () {
                            togglePostLike();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                _showPosts
                    // posts list
                    ? Expanded(
                        child: ListView.builder(
                          padding: AddPadding.symmetric(
                              horizontal: 15, vertical: 13),
                          itemCount: widget.postModel == null
                              ? postRead.currentUsersPostsList.length
                              : postRead.targetUsersPostsList.length,
                          itemBuilder: (context, index) {
                            PostModel postModel = widget.postModel == null
                                ? postWatch.currentUsersPostsList[index]
                                : postWatch.targetUsersPostsList[index];
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
                                widget.postModel == null
                                    ? _getCurrentUsersPosts()
                                    : _getTargetUsersPosts(targetUser?.id ?? 0);
                              },
                              ppClick: () {},
                              iconData: postModel.selfLiked == true
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              onSelected: (value) {
                                if (value == 'edit') {
                                  if (postModel.user?.id ==
                                      postRead.allUserId) {
                                    // edit
                                    NavigateSkills().pushTo(
                                      context,
                                      SendPostScreen(
                                        postModel: postModel,
                                      ),
                                    );
                                  }
                                } else {
                                  if (postModel.user?.id ==
                                      postRead.allUserId) {
                                    _postDelete(postModel.id ?? 0);
                                    widget.postModel == null
                                        ? _getCurrentUsersPosts()
                                        : _getTargetUsersPosts(
                                            targetUser?.id ?? 0);
                                  }
                                }
                              },
                            );
                          },
                        ),
                      )
                    // likes list
                    : Expanded(
                        child: ListView.builder(
                          padding: AddPadding.symmetric(
                              horizontal: 15, vertical: 13),
                          itemCount: widget.postModel == null
                              ? postWatch.currentUsersLikedPostList.length
                              : postWatch.likedPostsList.length,
                          itemBuilder: (context, index) {
                            PostModel postModel = widget.postModel == null
                                ? postWatch.currentUsersLikedPostList[index]
                                : postWatch.likedPostsList[index];
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
                                widget.postModel == null
                                    ? _getCurrentUsersLikedPosts()
                                    : _getLikedPostsList(targetUser?.id ?? 0);
                              },
                              ppClick: () {},
                              iconData: postModel.selfLiked == true
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              onSelected: (value) {
                                if (value == 'edit') {
                                  if (postModel.user?.id ==
                                      postRead.allUserId) {
                                    // edit
                                    NavigateSkills().pushTo(
                                      context,
                                      SendPostScreen(
                                        postModel: postModel,
                                      ),
                                    );
                                  }
                                } else {
                                  if (postModel.user?.id ==
                                      postRead.allUserId) {
                                    _postDelete(postModel.id ?? 0);
                                    widget.postModel == null
                                        ? _getCurrentUsersLikedPosts()
                                        : _getLikedPostsList(
                                            targetUser?.id ?? 0);
                                  }
                                }
                              },
                            );
                          },
                        ),
                      ),
              ],
            ),
    );
  }
}
