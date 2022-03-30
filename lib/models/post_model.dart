import 'dart:io';

import 'package:flutter_instagram/models/user_model.dart';

class Post {
  String? uid;
  String? fullName;
  String? id;
  String? postImage;
  String? caption;
  String? createdDate;
  int likedCount = 0;
  bool isLiked = false;
  bool isMine = false;
  List likedByUsers=[];
  String? profileImage;

  Post({
    required this.postImage,
    required this.caption,
  });

  Post.fromJson(Map<String, dynamic> json) {
    uid = json["uid"];
    fullName = json["fullName"];
    id = json["id"];
    postImage = json["postImage"];
    caption = json["caption"];
    createdDate = json["createdDate"];
    isLiked = json["isLiked"];
    isMine = json["isMine"];
    likedCount = json["likedCount"];
    profileImage = json["profileImage"];
    likedByUsers = json["likedByUsers"];
  }

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "fullName": fullName,
        "id": id,
        "postImage": postImage,
        "caption": caption,
        "createdDate": createdDate,
        "isLiked": isLiked,
        "isMine": isMine,
        "likedCount": likedCount,
        "profileImage": profileImage,
        "likedByUsers": likedByUsers,
      };
}
