import 'package:flutter/material.dart';
import 'package:laravel_smapp/utils/add_padding.dart';
import 'package:laravel_smapp/utils/add_space.dart';
import 'package:laravel_smapp/widgets/custom_text.dart';

class CustomComment extends StatelessWidget {
  const CustomComment({
    super.key,
    required this.name,
    required this.comment,
    required this.ppUrl,
    required this.onSelected,
  });
  final String? name;
  final String? comment;
  final String? ppUrl;
  final Function(String)? onSelected;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Padding(
      padding: AddPadding.symmetric(horizontal: 15, vertical: 12),
      child: Row(
        children: [
          // Circle avatar
          CircleAvatar(
            backgroundImage: NetworkImage(ppUrl ?? ""),
          ),
          AddSpace().horizontal(5),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // username
              SizedBox(
                width: size.width * 0.5,
                child: CustomText(
                  text: name ?? "Unknown",
                  fontWeight: FontWeight.w500,
                  overflow: TextOverflow.ellipsis,
                  maxLine: 1,
                ),
              ),
              // comment body
              SizedBox(
                width: size.width * 0.6,
                child: CustomText(
                  text: comment ?? "Unknown comment",
                  overflow: TextOverflow.ellipsis,
                  maxLine: 1,
                ),
              ),
            ],
          ),
          const Spacer(),
          // edit / delete
          PopupMenuButton(
            shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            itemBuilder: (context) => [
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
    );
  }
}
