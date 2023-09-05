import 'package:flutter/material.dart';
import 'package:laravel_smapp/models/post_model.dart';
import 'package:laravel_smapp/providers/post_controller.dart';
import 'package:laravel_smapp/utils/add_padding.dart';
import 'package:laravel_smapp/widgets/custom_button.dart';
import 'package:laravel_smapp/widgets/custom_textfield.dart';
import 'package:provider/provider.dart';

import '../utils/add_space.dart';
import '../widgets/custom_appbar_action.dart';

class SendPostScreen extends StatefulWidget {
  const SendPostScreen({
    super.key,
    this.postModel,
  });
  final PostModel? postModel;

  @override
  State<SendPostScreen> createState() => _SendPostScreenState();
}

class _SendPostScreenState extends State<SendPostScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController _textEditingController = TextEditingController();

  // create post
  Future<void> _createPost() async {
    await context
        .read<PostController>()
        .createPost(context, mounted, _textEditingController);
  }

  // edit post
  Future<void> _editPost(int postId) async {
    await context
        .read<PostController>()
        .editPost(context, mounted, postId, _textEditingController);
  }

  @override
  void initState() {
    if (widget.postModel != null) {
      _textEditingController.text = widget.postModel?.body ?? "";
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final watchPost = context.watch<PostController>();
    return Scaffold(
      appBar: AppBar(
        actions: const [
          // light mode
          CustomAppBarAction(),
        ],
      ),
      body: Padding(
        padding: AddPadding.symmetric(horizontal: 20),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              CustomTextfield(
                isPrefixEnabled: false,
                controller: _textEditingController,
                hintText: "Post description...",
              ),
              AddSpace().vertical(30),
              watchPost.isLoading
                  ? const CircularProgressIndicator()
                  : CustomButton(
                      text: widget.postModel == null ? "SEND" : "EDIT",
                      onTap: () {
                        if (formKey.currentState!.validate()) {
                          if (widget.postModel == null) {
                            _createPost();
                          } else {
                            _editPost(widget.postModel?.id ?? 0);
                          }
                        }
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
