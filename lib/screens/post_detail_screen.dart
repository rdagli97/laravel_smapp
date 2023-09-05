import 'package:flutter/material.dart';
import 'package:laravel_smapp/models/comment_model.dart';
import 'package:laravel_smapp/models/post_model.dart';
import 'package:laravel_smapp/providers/comment_controller.dart';
import 'package:laravel_smapp/providers/like_controller.dart';
import 'package:laravel_smapp/providers/post_controller.dart';
import 'package:laravel_smapp/screens/comment_screen.dart';
import 'package:laravel_smapp/screens/profile_screen.dart';
import 'package:laravel_smapp/screens/send_post_screen.dart';
import 'package:laravel_smapp/screens/update_screen.dart';
import 'package:laravel_smapp/utils/add_space.dart';
import 'package:laravel_smapp/utils/navigate_to.dart';
import 'package:laravel_smapp/widgets/custom_appbar_action.dart';
import 'package:laravel_smapp/widgets/custom_comment.dart';
import 'package:laravel_smapp/widgets/custom_post.dart';
import 'package:provider/provider.dart';

class PostDetailScreen extends StatefulWidget {
  const PostDetailScreen({
    super.key,
    required this.postModel,
  });
  final PostModel? postModel;

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  bool _selfLiked = false;
  // get comment of post
  Future<void> _getComments(int postId) async {
    await context
        .read<CommentController>()
        .getComments(context, mounted, postId);
  }

  // handle like
  Future<void> _handlePostLike(int postId) async {
    await context
        .read<LikeController>()
        .handlePostLike(context, mounted, postId);
  }

  // handle delete post
  Future<void> _handleDeletePost(int postId) async {
    await context.read<PostController>().postDelete(context, mounted, postId);
  }

  // handle delete comment
  Future<void> _handleDeleteComment(int commentId) async {
    await context
        .read<CommentController>()
        .deleteComment(context, mounted, commentId, widget.postModel?.id ?? 0);
  }

  Future<void> initOperations() async {
    await _getComments(widget.postModel?.id ?? 0);
    _selfLiked = widget.postModel?.selfLiked ?? false;
  }

  Future<void> toggleLike() async {
    await _handlePostLike(widget.postModel?.id ?? 0);
    _selfLiked = !_selfLiked;
  }

  @override
  void initState() {
    initOperations();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final postRead = context.read<PostController>();
    final postWatch = context.watch<PostController>();
    final commentRead = context.read<CommentController>();
    final commentWatch = context.watch<CommentController>();
    return Scaffold(
      appBar: AppBar(
        actions: const [
          CustomAppBarAction(),
        ],
      ),
      body: Column(
        children: [
          postWatch.isLoading
              ? const CircularProgressIndicator()
              : CustomPost(
                  postModel: widget.postModel ?? PostModel(),
                  ppUrl: widget.postModel?.user?.image,
                  iconData: _selfLiked == true
                      ? Icons.favorite
                      : Icons.favorite_border,
                  likeClick: () async {
                    await toggleLike();
                  },
                  commentClick: () {
                    NavigateSkills().pushTo(
                      context,
                      CommentScreen(
                        postId: widget.postModel?.id,
                      ),
                    );
                  },
                  ppClick: () {
                    NavigateSkills().pushTo(
                      context,
                      ProfileScreen(
                        postModel: widget.postModel ?? PostModel(),
                      ),
                    );
                  },
                  onSelected: (value) {
                    if (value == 'edit') {
                      if (widget.postModel?.user?.id == postRead.allUserId) {
                        // edit
                        NavigateSkills().pushTo(
                          context,
                          SendPostScreen(
                            postModel: postRead.post ?? PostModel(),
                          ),
                        );
                      } else {
                        if (widget.postModel?.user?.id == postRead.allUserId) {
                          // delete
                          _handleDeletePost(postRead.post?.id ?? 0);
                          NavigateSkills().pushReplacementTo(
                            context,
                            const UpdateScreen(),
                          );
                        }
                      }
                    }
                  },
                ),
          AddSpace().vertical(20),
          commentWatch.isLoading
              ? const CircularProgressIndicator()
              : Expanded(
                  child: ListView.builder(
                    itemCount: commentRead.commentList.length,
                    itemBuilder: (context, index) {
                      CommentModel commentModel =
                          commentRead.commentList[index];
                      return CustomComment(
                        ppUrl: commentModel.user?.image,
                        comment: commentModel.comment ?? "",
                        name: commentModel.user?.username,
                        onSelected: (value) {
                          if (value == 'delete' &&
                              commentModel.user?.id == commentRead.userId) {
                            commentRead.initialEditCommentId(commentModel.id);
                            _handleDeleteComment(commentModel.id ?? 0);
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
