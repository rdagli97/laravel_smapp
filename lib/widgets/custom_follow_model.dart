import 'package:flutter/material.dart';
import 'package:laravel_smapp/models/user_model.dart';
import 'package:laravel_smapp/utils/add_padding.dart';
import 'package:laravel_smapp/utils/add_space.dart';
import 'package:laravel_smapp/widgets/custom_text.dart';

class CustomFollowModel extends StatelessWidget {
  const CustomFollowModel({
    super.key,
    required this.userModel,
  });
  final UserModel? userModel;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Padding(
      padding: AddPadding.symmetric(horizontal: 15, vertical: 12),
      child: Row(
        children: [
          // Circle avatar
          CircleAvatar(
            backgroundImage: NetworkImage(userModel?.image ?? ""),
          ),
          AddSpace().horizontal(5),
          // username
          SizedBox(
            width: size.width * 0.5,
            child: CustomText(
              text: '${userModel?.username}',
              fontWeight: FontWeight.w500,
              overflow: TextOverflow.ellipsis,
              maxLine: 1,
            ),
          ),
        ],
      ),
    );
  }
}
