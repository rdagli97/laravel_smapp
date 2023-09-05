import 'package:flutter/material.dart';
import 'package:laravel_smapp/models/comment_model.dart';
import 'package:laravel_smapp/providers/comment_controller.dart';
import 'package:laravel_smapp/providers/user_controller.dart';
import 'package:laravel_smapp/utils/add_padding.dart';
import 'package:laravel_smapp/utils/add_space.dart';
import 'package:laravel_smapp/widgets/custom_appbar_action.dart';
import 'package:laravel_smapp/widgets/custom_comment.dart';
import 'package:laravel_smapp/widgets/custom_option_button.dart';
import 'package:laravel_smapp/widgets/custom_textfield.dart';
import 'package:provider/provider.dart';

class CommentScreen extends StatefulWidget {
  const CommentScreen({
    super.key,
    this.postId,
  });
  final int? postId;

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController _commentController = TextEditingController();

  // get comment of this post
  Future<void> _getComments() async {
    await context
        .read<CommentController>()
        .getComments(context, mounted, widget.postId);
  }

  // create comment
  Future<void> _createComment() async {
    await context
        .read<CommentController>()
        .createComment(context, mounted, widget.postId, _commentController);
  }

  // delete comment
  Future<void> _deleteComment(int commentId) async {
    await context
        .read<CommentController>()
        .deleteComment(context, mounted, commentId, widget.postId);
  }

  // get user details
  Future<void> _getUser() async {
    await context.read<UserController>().getUser(context, mounted);
  }

  @override
  void initState() {
    _getComments();
    _getUser();
    super.initState();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final watchComment = context.watch<CommentController>();
    final readComment = context.read<CommentController>();
    return Scaffold(
      appBar: AppBar(
        actions: const [
          CustomAppBarAction(),
        ],
      ),
      body: watchComment.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: () {
                return _getComments();
              },
              child: Column(
                children: [
                  // list of comment
                  Expanded(
                    child: ListView.builder(
                      itemCount: readComment.commentList.length,
                      itemBuilder: (context, index) {
                        CommentModel comment = readComment.commentList[index];
                        return CustomComment(
                          name: comment.user?.username,
                          ppUrl: comment.user?.image,
                          comment: '${comment.comment}',
                          onSelected: (val) {
                            if (val == 'delete' &&
                                comment.user!.id == readComment.userId) {
                              // delete
                              readComment.initialEditCommentId(comment.id);
                              _deleteComment(comment.id ?? 0);
                            }
                          },
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: AddPadding.symmetric(horizontal: 20, vertical: 13),
                    child: Row(
                      children: [
                        // comment textfield
                        Form(
                          key: formKey,
                          child: Expanded(
                            child: CustomTextfield(
                              controller: _commentController,
                              hintText: 'Send comment',
                              validator: (val) => val!.isEmpty
                                  ? 'There is nothing to send'
                                  : null,
                            ),
                          ),
                        ),
                        AddSpace().horizontal(5),
                        // send button
                        CustomOptionButton(
                          child: const Icon(Icons.send),
                          onTap: () {
                            if (formKey.currentState!.validate()) {
                              _createComment();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
