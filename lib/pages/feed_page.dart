import 'package:flutter/material.dart';
import 'package:flutter_instagram/utils/feed_widget.dart';
import 'package:flutter_instagram/utils/glow_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../models/post_model.dart';

class FeedPage extends StatefulWidget {
  Post? post;
  PageController pageController;
  FeedPage({this.post, required this.pageController,Key? key}) : super(key: key);

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  List<Post> posts = [
    Post(
        id: '1',
        postImage:
            'https://firebasestorage.googleapis.com/v0/b/koreanguideway.appspot.com/o/develop%2Fpost.png?alt=media&token=f0b1ba56-4bf4-4df2-9f43-6b8665cdc964',
        caption:
            "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s,",
        createdDate: DateTime.now().toString(),
        isLiked: true,
        isMine: true,
        fullName: "Nurulloh Abduvohidov"),
    Post(
        id: '2',
        postImage:
            'https://firebasestorage.googleapis.com/v0/b/koreanguideway.appspot.com/o/develop%2Fpost2.png?alt=media&token=ac0c131a-4e9e-40c0-a75a-88e586b28b72',
        caption:
            "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s,",
        createdDate: DateTime.now().toString(),
        isLiked: true,
        isMine: true,
        fullName: "Nurulloh Abduvohidov")
  ];

  void updatePosts() {
    if (widget.post != null) {
      setState(() {
        posts.insert(0, widget.post!);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    updatePosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          title: const Text(
            'Instagram',
            style: TextStyle(
                fontSize: 30, color: Colors.black, fontFamily: 'Billabong'),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(FontAwesomeIcons.facebookMessenger),
              color: Colors.black,
            )
          ],
        ),
        body: Glow(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ListView.builder(
                      itemCount: posts.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return FeedWidget(post: posts[index]);
                      })
                ],
              ),
            ),
          ),
        ));
  }
}
