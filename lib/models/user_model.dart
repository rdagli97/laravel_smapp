class UserModel {
  int? id;
  String? username;
  String? email;
  String? image;
  String? token;
  int? postCount;
  int? followerCount;
  int? followingCount;

  UserModel({
    this.id,
    this.username,
    this.email,
    this.image,
    this.token,
    this.postCount,
    this.followerCount,
    this.followingCount,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      image: json['image'] ?? '',
      email: json['email'] ?? '',
      token: json['token'] ?? '',
      postCount: json['posts_count'] ?? 0,
      followerCount: json['followers_count'] ?? 0,
      followingCount: json['followings_count'] ?? 0,
    );
  }
}
