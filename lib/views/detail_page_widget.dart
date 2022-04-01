import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram/models/user_model.dart';
import 'package:flutter_instagram/views/shimmer_anim.dart';

class DetailPageWidget extends StatefulWidget {
  User? user;

  DetailPageWidget({required this.user, Key? key}) : super(key: key);

  @override
  State<DetailPageWidget> createState() => _DetailPageWidgetState();
}

class _DetailPageWidgetState extends State<DetailPageWidget> {
  bool isLoading = true;
  User? user;

  void getUser() {
    setState(() {
      user = widget.user;
    });
  }

  @override
  void didUpdateWidget(covariant DetailPageWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    getUser();
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.46,
      child: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            /// # Profile Account pictue and Statistcs
            ((user != null) && isLoading)
                ? Container(
                    margin: EdgeInsets.only(top: 10),
                    height: MediaQuery.of(context).size.height * 0.12,
                    width: MediaQuery.of(context).size.width,
                    child: GridTileBar(
                      leading: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            border: Border.all(color: Colors.white, width: 1),
                            borderRadius: BorderRadius.circular(100)),
                        child: (user?.imageUrl != null)
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  imageUrl: user!.imageUrl!,
                                ),
                              )
                            : Icon(
                                Icons.add,
                                color: Colors.black,
                              ),
                      ),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          /// Posts
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                user!.postCount.toString(),
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5),
                              ),
                              const Text(
                                "Posts",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: -0.1),
                              ),
                            ],
                          ),

                          /// Followers
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                user!.followersCount.toString(),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: -0.3),
                              ),
                              const Text(
                                "Followers",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: -0.1),
                              ),
                            ],
                          ),

                          /// Following
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                user!.followingCount.toString(),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: -0.3),
                              ),
                              const Text(
                                "Following",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: -0.1),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                : buildMovieShimmer(true),

            /// # Profile details
            Container(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  /// Profile Name
                  Text(
                    user!.fullName!,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 1,
                  ),

                  /// # Profile details
                  const Text.rich(TextSpan(
                      text: "Digital goodies designer ",
                      style:
                          TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
                      children: [
                        TextSpan(
                            text: "@pixsellz",
                            style: TextStyle(color: Colors.blue))
                      ])),
                  const SizedBox(
                    height: 1,
                  ),
                  const Text(
                    "Everything is designed.",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(
                    height: 15,
                  ),

                  /// #Edit Button
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                                color: Color.fromRGBO(60, 60, 67, 0.18)),
                            borderRadius: BorderRadius.circular(5),
                          )),
                      onPressed: () {},
                      child: Text(
                        "Edit Profile",
                        style: TextStyle(
                            color: Theme.of(context).textTheme.button?.color,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      )),
                ],
              ),
            ),
          ],
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
