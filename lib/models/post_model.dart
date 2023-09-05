import 'package:laravel_smapp/models/user_model.dart';

class PostModel {
  int? id;
  String? body;
  int? likesCount;
  int? commentCount;
  UserModel? user;
  bool? selfLiked;

  PostModel({
    this.id,
    this.body,
    this.likesCount,
    this.commentCount,
    this.user,
    this.selfLiked,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'],
      body: json['body'],
      likesCount: json['likes_count'],
      commentCount: json['comments_count'],
      selfLiked: json['likes'].length > 0 ?? 0,
      user: UserModel(
        id: json['user']['id'],
        username: json['user']['username'],
        image: json['user']['image'] ?? "https://picsum.photos/200",
        email: json['user']['email'],
      ),
    );
  }

  UserModel get getUser => user ?? UserModel();
  String get getBody => body ?? "";
}
