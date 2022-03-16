import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram/models/post_model.dart';
import 'package:flutter_instagram/utils/widget_catalog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FeedWidget extends StatefulWidget {
  Post post;

  FeedWidget({required this.post, Key? key}) : super(key: key);

  @override
  State<FeedWidget> createState() => _FeedWidgetState();
}

class _FeedWidgetState extends State<FeedWidget> {
  late Post post;

  @override
  void initState() {
    super.initState();
    post = widget.post;
  }

  @override
  Widget build(BuildContext context) {
    return GridTile(
      header: Container(
        height: 50,
        color: Theme.of(context).scaffoldBackgroundColor,
        child: GridTileBar(
          leading: const CircleAvatar(
            backgroundImage: AssetImage('assets/images/im_profile.png'),
          ),
          title: Text(
            post.fullName!,
            style: const TextStyle(fontSize: 14, color: Colors.black),
          ),
          trailing: const Icon(
            FontAwesomeIcons.ellipsisV,
            color: Colors.black,
            size: 18,
          ),
        ),
      ),
      child: CachedNetworkImage(
        imageUrl: post.postImage!,
        placeholder: (context, url) => const Image(
          image: AssetImage('assets/images/im_placeholder.png'),
          fit: BoxFit.cover,
        ),
        errorWidget: (context, url, error) => Icon(Icons.error),
      ),
      footer: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GridTileBar(
              leading: Row(
                children: [
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        CupertinoIcons.heart,
                        color: Colors.black,
                      )),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        CupertinoIcons.chat_bubble,
                        color: Colors.black,
                      )),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        CupertinoIcons.paperplane_fill,
                        color: Colors.black,
                      )),
                ],
              ),
              title: const Text(""),
              trailing: const Icon(
                CupertinoIcons.bookmark,
                color: Colors.black,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: (post.caption != null)
                  ? RichText(
                      maxLines: 2,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                          style: TextStyle(color: Colors.black),
                          text: "${post.caption} ",
                          children: [
                            TextSpan(
                              text: post.caption,
                              style: Theme.of(context).textTheme.bodyText2,
                            )
                          ]))
                  : const SizedBox.shrink(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
              child: Text(
                WidgetCatalog.getMonthDayYear(post.createdDate!),
                style: const TextStyle(color: Colors.black, fontSize: 12),
              ),
            )
          ],
        ),
      ),
    );
  }
}
