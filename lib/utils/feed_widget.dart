import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_instagram/models/post_model.dart';
import 'package:flutter_instagram/models/user_model.dart';
import 'package:flutter_instagram/services/firestore_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FeedWidget extends StatefulWidget {
  Post post;

  FeedWidget({required this.post, Key? key}) : super(key: key);

  @override
  State<FeedWidget> createState() => _FeedWidgetState();
}

class _FeedWidgetState extends State<FeedWidget> {
  late Post post;
  bool isLoading = false;
  List<dynamic> likedByUsers = [];

  void likePost(Post post, bool isLiked) async {
    setState(() {
      isLoading = true;
    });
    await FireStoreService.likePost(post, isLiked).then((value) {
      setState(() {
        getDataFromParentWidget();
        isLoading = false;
      });
    });
  }

  void getDataFromParentWidget() {
    setState(() {
      post = widget.post;
      likedByUsers = post.likedByUsers;
    });
  }

  @override
  void didUpdateWidget(covariant FeedWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    getDataFromParentWidget();
  }



  @override
  void initState() {
    super.initState();
    getDataFromParentWidget();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          /// Header
          Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: ListTile(
              horizontalTitleGap: 10,

              /// Profile Image
              leading: Container(
                decoration: BoxDecoration(
                    color: Colors.purple,
                    borderRadius: BorderRadius.circular(100)),
                padding: EdgeInsets.all(2),
                child: Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      border: Border.all(color: Colors.white, width: 1),
                      borderRadius: BorderRadius.circular(100)),
                  child: (post.profileImage != null)
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: post.profileImage!,
                          ),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.asset(
                            'assets/images/im_profile.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
              ),
              title: Text(
                post.fullName!,
                style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              trailing: const Icon(
                FontAwesomeIcons.ellipsisV,
                color: Colors.black,
                size: 18,
              ),
            ),
          ),

          /// Image
          Stack(
            alignment: Alignment.center,
            children: [
              CachedNetworkImage(
                imageUrl: post.postImage!,
                width: MediaQuery.of(context).size.width,
                placeholder: (context, url) => const Image(
                  image: AssetImage('assets/images/im_placeholder.png'),
                  fit: BoxFit.cover,
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
              if (isLoading)
                CupertinoActivityIndicator(
                  radius: 20,
                  color: Colors.blue,
                )
            ],
          ),

          /// Buttons Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  /// Like button
                  if(!post.isMine)
                  IconButton(
                      onPressed: () {
                        (post.isLiked)
                            ? likePost(post, false)
                            : likePost(post, true);
                      },
                      icon: (post.isLiked)
                          ? Icon(
                              FontAwesomeIcons.solidHeart,
                              color: Colors.red,
                            )
                          : Icon(
                              FontAwesomeIcons.heart,
                              color: Colors.black,
                            )),
                  /// Comment button
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        FontAwesomeIcons.comment,
                        color: Colors.black,
                      )),
                  /// Share button
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        CupertinoIcons.paperplane_fill,
                        color: Colors.black,
                      )),
                ],
              ),
              IconButton(
                color: Colors.black,
                icon: const Icon(
                  FontAwesomeIcons.bookmark,
                ),
                onPressed: () {},
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text("${post.likedCount} likes",style: const TextStyle(color: Colors.black,fontWeight: FontWeight.w700,fontSize: 15),),
          ),
          /// Likes Count
          if (likedByUsers.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 2),
              child: RichText(
                maxLines: 2,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                text: TextSpan(
                    text: 'Liked by ',
                    style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                        color: Colors.black),
                    children: (likedByUsers.length >= 2)
                        ? List.generate(
                            3,
                            (index) => TextSpan(
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700),
                                text: (index != 2)
                                    ? '${likedByUsers.reversed.elementAt(index)}, '
                                    : ' and others'))
                        : List.generate(
                            1,
                            (index) => TextSpan(
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700),
                                text: '${likedByUsers.reversed.elementAt(index)}'))),
              ),
            ),

          /// Caption
          (post.caption != null)
              ? Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: RichText(
                      maxLines: 2,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        style:
                            const TextStyle(color: Colors.black, fontSize: 15),
                        text: post.caption,
                      )),
                )
              : const SizedBox.shrink(),

          /// data
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Text(
              post.createdDate!,
              style: const TextStyle(color: Colors.black, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
