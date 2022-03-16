class Post {
  String? uid;
  String? fullName;
  String? id;
  String? postImage;
  String? caption;
  String? createdDate;
  bool? isLiked;
  bool? isMine;
  String? profileImage;

  Post({
    this.uid,
    required this.id,
    required this.postImage,
    required this.caption,
    required this.createdDate,
    required this.isLiked,
    required this.isMine,
    required this.fullName,
    this.profileImage,
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
    profileImage = json["profileImage"];
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
        "profileImage": profileImage,
      };
}
