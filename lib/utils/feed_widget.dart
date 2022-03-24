import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
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
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          /// Header
          Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: ListTile(
              leading: const CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage('assets/images/im_profile.png'),
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

          (post.image != null) ? Image.file(post.image!) : CachedNetworkImage(
            imageUrl: post.postImage!,
            placeholder: (context, url) => const Image(
              image: AssetImage('assets/images/im_placeholder.png'),
              fit: BoxFit.cover,
            ),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),

          /// Buttons Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        FontAwesomeIcons.heart,
                        color: Colors.black,
                      )),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        FontAwesomeIcons.comment,
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
              IconButton(
                color: Colors.black,
                icon: Icon(
                  FontAwesomeIcons.bookmark,
                ),
                onPressed: () {},
              ),
            ],
          ),

          /// Caption
          (post.caption != null)
              ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: RichText(
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
                        ])),
              )
              : const SizedBox.shrink(),
          /// data
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
            child: Text(
              WidgetCatalog.getMonthDayYear(post.createdDate!),
              style: const TextStyle(color: Colors.black, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
