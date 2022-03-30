import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_instagram/services/log_service.dart';
import 'package:flutter_instagram/services/prefs_service.dart';
import 'package:flutter_instagram/utils/widget_catalog.dart';

import '../models/post_model.dart';
import '../models/user_model.dart';

class FireStoreService {
  // init
  static final instance = FirebaseFirestore.instance;

  // folder
  static const String usersFolder = "users";
  static const String allPostsFolder = "all_posts";
  static const String postsFolder = "posts";
  static const String feedsFolder = "feeds";
  static const String likesFolder = "likes";
  static const String followingFolder = "following";
  static const String followerFolder = "followers";

  /// User Related

  static Future<void> storeUser(User user) async {
    user.uid = await Prefs.load(StorageKeys.UID);
    return instance.collection(usersFolder).doc(user.uid).set(user.toJson());
  }

  static Future<User> loadUser() async {
    String uid = (await Prefs.load(StorageKeys.UID))!;
    var value = await instance.collection(usersFolder).doc(uid).get();
    return User.fromJson(value.data()!);
  }

  static Future<void> updateUser(User user) async {
    return instance.collection(usersFolder).doc(user.uid).update(user.toJson());
  }

  static Future<List<User>> searchUsers(String keyword) async {
    User user = await loadUser();
    List<User> users = [];
    // write request
    var querySnapshot = await instance
        .collection(usersFolder)
        .orderBy("fullName")
        .startAt([keyword]).endAt([keyword + '\uf8ff']).get();
    Log.i(querySnapshot.docs.toString());

    for (var element in querySnapshot.docs) {
      users.add(User.fromJson(element.data()));
    }
    users.remove(user);

    List<User> following = [];

    var querySnapshot2 = await instance
        .collection(usersFolder)
        .doc(user.uid)
        .collection(followingFolder)
        .get();
    for (var result in querySnapshot2.docs) {
      following.add(User.fromJson(result.data()));
    }

    for (User user in users) {
      if (following.contains(user)) {
        user.followed = true;
      } else {
        user.followed = false;
      }
    }
    return users;
  }

  /// Post Related

  /// Post methods
  static Future<Post> storePost(Post post) async {
    // filled post
    User me = await loadUser();
    // me.postCount = me.postCount +1;
    // await updateUser(me);
    post.uid = me.uid;
    post.fullName = me.fullName;
    post.profileImage = me.imageUrl;
    post.isMine = true;
    post.createdDate = WidgetCatalog.getMonthDayYear(DateTime.now().toString());

    String postId = instance
        .collection(usersFolder)
        .doc(me.uid)
        .collection(postsFolder)
        .doc()
        .id;
    post.id = postId;
    // Store to All post for Search page
    await instance.collection(allPostsFolder).doc(postId).set(post.toJson());
    // Store to users posts
    await instance
        .collection(usersFolder)
        .doc(me.uid)
        .collection(postsFolder)
        .doc(postId)
        .set(post.toJson());
    return post;
  }

  static Future<Post> storeFeed(Post post) async {
    String uid = (await Prefs.load(StorageKeys.UID))!;
    await instance
        .collection(usersFolder)
        .doc(uid)
        .collection(feedsFolder)
        .doc(post.id)
        .set(post.toJson());
    return post;
  }

  static Future<List<Post>> loadFeeds() async {
    List<Post> posts = [];
    String uid = (await Prefs.load(StorageKeys.UID))!;
    var querySnapshot = await instance
        .collection(usersFolder)
        .doc(uid)
        .collection(feedsFolder)
        .get();

    for (var element in querySnapshot.docs) {
      Post post = Post.fromJson(element.data());
      if (post.uid == uid) {
        post.isMine = true;
      }
      else{
        post.isMine = false;
      }
      posts.add(post);
    }

    return posts;
  }

  static Future<List<Post>> loadPosts() async {
    List<Post> posts = [];
    String uid = (await Prefs.load(StorageKeys.UID))!;
    var querySnapshot = await instance
        .collection(usersFolder)
        .doc(uid)
        .collection(postsFolder)
        .get();

    for (var element in querySnapshot.docs) {
      posts.add(Post.fromJson(element.data()));
    }

    return posts;
  }

  static Future<List<Post>> loadAllPosts() async {
    List<Post> posts = [];
    var querySnapshot = await instance.collection(allPostsFolder).get();

    for (var element in querySnapshot.docs) {
      posts.add(Post.fromJson(element.data()));
    }

    return posts;
  }

  /// Like Post methods
  static Future<Post> likePost(Post post, bool isLiked) async {
    User user = await loadUser();
    post.isLiked = isLiked;
    if (isLiked) {
      user.likedImage = post.postImage;
      post.likedCount = post.likedCount + 1;
      post.likedByUsers.add(user.toJson());
    } else {
      user.likedImage = null;
      post.likedCount = post.likedCount - 1;
      post.likedByUsers.removeWhere((element) => (element['uid'] == user.uid));
    }
    // Update my liked Feed post
    await instance
        .collection(usersFolder)
        .doc(user.uid)
        .collection(feedsFolder)
        .doc(post.id)
        .update(post.toJson());
    await storedLikeByUsers(user, post, isLiked);

    //Update my liked post
    if (user.uid == post.uid) {
      await instance
          .collection(usersFolder)
          .doc(user.uid)
          .collection(postsFolder)
          .doc(post.id)
          .update(post.toJson());
    } else {
      await methodLikeSomeones(user, post, isLiked);
    }
    post.isLiked = !post.isLiked;
    return post;
  }

  static Future<void> methodLikeSomeones(
      User user, Post post, bool isLiked) async {
    post.isLiked = !isLiked;

    // Update someones liked Feed post
    await instance
        .collection(usersFolder)
        .doc(post.uid)
        .collection(feedsFolder)
        .doc(post.id)
        .update(post.toJson());
    // Update someones liked Posts post

    await instance
        .collection(usersFolder)
        .doc(post.uid)
        .collection(postsFolder)
        .doc(post.id)
        .update(post.toJson());
  }

  static Future<Post> storedLikeByUsers(
      User user, Post post, bool isLiked) async {
    // Add or Remove from likesFolder
    ((isLiked) && (user.uid != post.uid))
        ? await instance
            .collection(usersFolder)
            .doc(post.uid)
            .collection(likesFolder)
            .doc(post.id! + user.uid!)
            .set(user.toJson())
        : await instance
            .collection(usersFolder)
            .doc(post.uid)
            .collection(likesFolder)
            .doc(post.id! + user.uid!)
            .delete();
    return post;
  }

  static Future<List<User>> loadLikes() async {
    String uid = (await Prefs.load(StorageKeys.UID))!;
    List<User> likeUsers = [];
    var querySnapshot = await instance
        .collection(usersFolder)
        .doc(uid)
        .collection(likesFolder)
        .get();

    for (var element in querySnapshot.docs) {
      User user = User.fromJson(element.data());
      likeUsers.add(user);
    }
    return likeUsers;
  }

  /// Follow methods
  static Future<User> followUser(User someone) async {
    User me = await loadUser();
    me.followingCount = me.followingCount + 1;
    updateUser(me);
    someone.followersCount = someone.followersCount + 1;
    updateUser(someone);
    // I followed to someone
    await instance
        .collection(usersFolder)
        .doc(me.uid)
        .collection(followingFolder)
        .doc(someone.uid)
        .set(someone.toJson());

    // I am in someone's following list
    await instance
        .collection(usersFolder)
        .doc(someone.uid)
        .collection(followerFolder)
        .doc(me.uid)
        .set(me.toJson());

    return someone;
  }

  static Future<User> unFollowUser(User someone) async {
    User me = await loadUser();
    me.followingCount = me.followingCount - 1;
    updateUser(me);
    someone.followersCount = someone.followersCount - 1;
    updateUser(someone);
    // I unFollowed to someone
    await instance
        .collection(usersFolder)
        .doc(me.uid)
        .collection(followingFolder)
        .doc(someone.uid)
        .delete();

    // I am deleted in someone's following list
    await instance
        .collection(usersFolder)
        .doc(someone.uid)
        .collection(followerFolder)
        .doc(me.uid)
        .delete();
    return someone;
  }

  static Future storePostsToMyFeed(User someone) async {
    // Store someone`s posts to my feed
    List<Post> posts = [];

    var querySnapshot = await instance
        .collection(usersFolder)
        .doc(someone.uid)
        .collection(postsFolder)
        .get();
    for (var element in querySnapshot.docs) {
      Post post = Post.fromJson(element.data());
      post.isLiked = false;
      posts.add(post);
    }
    for (Post post in posts) {
      storeFeed(post);
    }
    Log.w("Stored Feed Done");
  }

  static Future removePostsFromMyFeed(User someone) async {
    // Remove someone`s posts from my feed
    List<Post> posts = [];

    var querySnapshot = await instance
        .collection(usersFolder)
        .doc(someone.uid)
        .collection(postsFolder)
        .get();
    for (var element in querySnapshot.docs) {
      posts.add(Post.fromJson(element.data()));
    }

    for (Post post in posts) {
      removeFeed(post);
    }
    Log.w("Removed Feed Done");
  }

  static Future removeFeed(Post post) async {
    String uid = (await Prefs.load(StorageKeys.UID))!;

    return await instance
        .collection(usersFolder)
        .doc(uid)
        .collection(feedsFolder)
        .doc(post.id)
        .delete();
  }
}
