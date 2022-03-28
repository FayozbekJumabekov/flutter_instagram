class User {
  String? uid;
  String? fullName;
  String? email;
  String? password;
  String? imageUrl;
  String? likedImage;
  bool followed = false;
  int postCount = 0;
  int followersCount = 0;
  int followingCount = 0;

  User({required this.fullName, required this.email, required this.password});

  User.fromJson(Map<String, dynamic> json) {
    uid = json["uid"];
    fullName = json["fullName"];
    email = json["email"];
    password = json["password"];
    likedImage = json["likedImage"];
    imageUrl = json["imageUrl"];
    postCount = json["postCount"];
    followersCount = json["followersCount"];
    followingCount = json["followingCount"];
  }

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "fullName": fullName,
        "email": email,
        "password": password,
        "imageUrl": imageUrl,
        "likedImage": likedImage,
        "postCount": postCount,
        "followingCount": followingCount,
        "followersCount": followersCount,
      };

  @override
  bool operator ==(Object other) {
    return other is User && other.uid == uid;
  }

  @override
  int get hashCode => uid.hashCode;
}
