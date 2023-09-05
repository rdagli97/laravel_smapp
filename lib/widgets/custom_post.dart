import 'package:flutter/material.dart';
import 'package:laravel_smapp/consts/palette.dart';
import 'package:laravel_smapp/models/post_model.dart';
import 'package:laravel_smapp/utils/add_space.dart';
import 'package:laravel_smapp/widgets/custom_text.dart';

class CustomPost extends StatelessWidget {
  const CustomPost({
    super.key,
    required this.onSelected,
    required this.postModel,
    required this.commentClick,
    required this.likeClick,
    required this.iconData,
    required this.ppClick,
    required this.ppUrl,
    this.postClicked,
    this.likeCount,
  });
  final Function(String)? onSelected;
  final PostModel postModel;
  final Function()? likeClick;
  final Function()? commentClick;
  final IconData? iconData;
  final Function()? ppClick;
  final String? ppUrl;
  final Function()? postClicked;
  final String? likeCount;

  @override
  Widget build(BuildContext context) {
    Palette palette = Palette.fromDarkMode(context);
    return GestureDetector(
      onTap: postClicked,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // circle avatar,
          GestureDetector(
            onTap: ppClick,
            child: CircleAvatar(
              backgroundImage: NetworkImage(ppUrl!),
            ),
          ),
          AddSpace().horizontal(MediaQuery.of(context).size.width * 0.05),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // username
              CustomText(
                text: postModel.user?.username ?? 'Unknown',
                fontWeight: FontWeight.bold,
              ),
              AddSpace().vertical(5),
              // post body
              SizedBox(
                width: 200,
                child: CustomText(
                  text: postModel.body ?? 'there is no post body',
                  overflow: TextOverflow.ellipsis,
                  maxLine: 3,
                ),
              ),
              AddSpace().vertical(5),
              Row(
                children: [
                  // like count
                  CustomText(text: likeCount ?? '${postModel.likesCount}'),
                  AddSpace().horizontal(5),
                  // like button
                  GestureDetector(
                    onTap: likeClick,
                    child: Icon(
                      iconData,
                      color: palette.buttonColor,
                    ),
                  ),
                  AddSpace().horizontal(10),
                  // like count
                  CustomText(text: '${postModel.commentCount}'),
                  AddSpace().horizontal(5),
                  // comment button
                  GestureDetector(
                    onTap: commentClick,
                    child: Icon(
                      Icons.mode_comment_outlined,
                      color: palette.buttonColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
          AddSpace().horizontal(MediaQuery.of(context).size.width * 0.15),
          Column(
            children: [
              PopupMenuButton(
                shape: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                itemBuilder: (context) => [
                  // edit
                  const PopupMenuItem(
                    value: 'edit',
                    child: CustomText(
                      text: 'Edit',
                      color: Colors.black,
                    ),
                  ),
                  // delete
                  const PopupMenuItem(
                    value: 'delete',
                    child: CustomText(
                      text: 'Delete',
                      color: Colors.black,
                    ),
                  ),
                ],
                onSelected: onSelected,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
