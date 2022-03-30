import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram/services/firestore_service.dart';
import 'package:flutter_instagram/utils/feed_widget.dart';
import 'package:flutter_instagram/utils/glow_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/post_model.dart';

class FeedPage extends StatefulWidget {
  PageController pageController;

  FeedPage({required this.pageController, Key? key}) : super(key: key);

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  List<Post> posts = [];
  List<Post> likedByUsers = [];
  bool isLoading = false;

  void apiLoadPosts() {
    setState(() {
      isLoading = true;
    });

    FireStoreService.loadFeeds().then((posts) {
      getResPosts(posts);
    });
  }
  void getResPosts(List<Post> posts) {
    setState(() {
      this.posts = posts;
      isLoading = false;
    });
  }


  @override
  void initState() {
    super.initState();
    apiLoadPosts();
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
                fontSize: 35, color: Colors.black, fontFamily: 'Billabong'),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(FontAwesomeIcons.facebookMessenger),
              color: Colors.black,
            ),
            SizedBox(
              width: 5,
            )
          ],
        ),
        body: Glow(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                SingleChildScrollView(
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
                if (isLoading) Center(child: const CupertinoActivityIndicator(radius: 30,color: Colors.blue,))

              ],
            ),
          ),
        ));
  }
}
