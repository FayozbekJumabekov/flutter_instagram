import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram/models/user_model.dart';
import 'package:flutter_instagram/services/firestore_service.dart';

import '../views/glow_widget.dart';
import '../views/shimmer_anim.dart';

class LikePage extends StatefulWidget {
  const LikePage({Key? key}) : super(key: key);

  @override
  State<LikePage> createState() => _LikePageState();
}

class _LikePageState extends State<LikePage> {
  bool isLoading = false;
  List<User> users = [];

  @override
  void initState() {
    super.initState();
    sendRequestLikes();
  }

  void sendRequestLikes() {
    setState(() {
      isLoading = true;
    });

    FireStoreService.loadLikes().then((value) {
      getResponse(value);
    });
  }

  void getResponse(List<User> users) {
    setState(() {
      isLoading = false;
      this.users = users;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: const Text(
          'Activity',
          style: TextStyle(
              fontSize: 35, color: Colors.black, fontFamily: 'Billabong'),
        ),
      ),
      body: Glow(
          child: SingleChildScrollView(
        child: Column(
          children: [
            (!isLoading)
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      return usersListTile(users[index]);
                    })
                : Center(
                    child: CupertinoActivityIndicator(
                      radius: 20,
                    ),
                  )
          ],
        ),
      )),
    );
  }

  Widget usersListTile(User user) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
              color: Colors.grey.shade300,
              border: Border.all(color: Colors.purple, width: 2),
              borderRadius: BorderRadius.circular(100)),
          child: (user.imageUrl != null)
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: user.imageUrl!,
                  ),
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.asset(
                    'assets/images/im_profile.png',
                    fit: BoxFit.cover,
                  )),
        ),
        title: Text.rich(TextSpan(
            text: user.fullName,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
            ),
            children: const [
              TextSpan(
                  text: ' liked your post',
                  style: TextStyle(fontWeight: FontWeight.w400))
            ])),
        trailing: Container(
          child: CachedNetworkImage(
            fit: BoxFit.cover,
            imageUrl: user.likedImage!,
          ),
        ),
      ),
    );
  }

  Widget buildMovieShimmer(bool isHasLeading) => ListTile(
        leading: (isHasLeading)
            ? CustomWidget.circular(height: 80, width: 80)
            : null,
        title: Align(
          alignment: Alignment.centerLeft,
          child: CustomWidget.rectangular(
            height: 16,
            width: MediaQuery.of(context).size.width * 0.3,
          ),
        ),
        subtitle: CustomWidget.rectangular(height: 14),
      );
}
