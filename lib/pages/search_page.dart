import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram/models/post_model.dart';
import 'package:flutter_instagram/models/user_model.dart';
import 'package:flutter_instagram/services/firestore_service.dart';
import 'package:flutter_instagram/views/detail_page.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../views/glow_widget.dart';
import '../views/shimmer_anim.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController textEditingController = TextEditingController();
  bool isLoading = false;
  List<User> users = [];
  List<Post> posts = [];

  @override
  void initState() {
    super.initState();
    sendImgRequest();
  }

  /// Follow
  Future<void> followUser(User user) async {
    setState(() {
      isLoading = true;
    });
    FireStoreService.followUser(user).then((value) {
      setState(() {
        user.followed = true;
        isLoading = false;
      });
    });
    await FireStoreService.storePostsToMyFeed(user);
  }

  /// UnFollow
  Future<void> unFollowUser(User user) async {
    setState(() {
      user.followed = false;
      isLoading = true;
    });
    FireStoreService.unFollowUser(user).then((value) {
      setState(() {
        isLoading = false;
      });
    });
    await FireStoreService.removePostsFromMyFeed(user);
  }

  /// Search Methods
  void sendSearchRequest(String keyword) {
    if (keyword.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      FireStoreService.searchUsers(keyword).then((value) {
        getUsers(value);
      });
    } else {
      setState(() {
        users.clear();
      });
    }
  }

  void getUsers(List<User> response) {
    setState(() {
      users = response;
      isLoading = false;
    });
  }

  /// Grid Images
  void sendImgRequest() {
    setState(() {
      isLoading = true;
    });
    FireStoreService.loadAllPosts().then((value) {
      setState(() {
        getImages(value);
      });
    });
  }

  getImages(List<Post> response) {
    setState(() {
      isLoading = false;
      posts = response;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Glow(
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverList(
                  delegate: SliverChildListDelegate([
                textField(context),
              ]))
            ];
          },
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    /// Users
                    ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          return (!isLoading)
                              ? usersListTile(users[index])
                              : buildMovieShimmer(true);
                        }),

                    /// Images
                    if (users.isEmpty)
                      MasonryGridView.count(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        itemCount: posts.length,
                        crossAxisCount: 2,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5,
                        itemBuilder: (context, index) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: CachedNetworkImage(
                              imageUrl: posts[index].postImage!,
                              fit: BoxFit.cover,
                              placeholder: (context, index) => const Image(
                                fit: BoxFit.cover,
                                image: AssetImage(
                                    "assets/images/im_placeholder.png"),
                              ),
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
              if (isLoading)
                const Center(
                    child: CupertinoActivityIndicator(
                  radius: 20,
                ))
            ],
          ),
        ),
      ),
    );
  }

  Widget usersListTile(User user) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailPage(user: user)));
      },
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
                  ),
                ),
        ),
        title: Text(
          user.fullName!,
        ),
        subtitle: Text(user.email!),
        trailing: Container(
          height: 30,
          child: TextButton(
            onPressed: () {
              (user.followed) ? unFollowUser(user) : followUser(user);
            },
            child: Text((user.followed) ? "Unfollow" : "Follow"),
            style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 20),
                primary: Colors.black,
                shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.grey))),
          ),
        ),
      ),
    );
  }

  Widget buildMovieShimmer(bool isHasLeading) => ListTile(
        leading: (isHasLeading)
            ? const CustomWidget.circular(height: 80, width: 80)
            : null,
        title: Align(
          alignment: Alignment.centerLeft,
          child: CustomWidget.rectangular(
            height: 16,
            width: MediaQuery.of(context).size.width * 0.3,
          ),
        ),
        subtitle: const CustomWidget.rectangular(height: 14),
      );

  Container textField(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * 0.05, left: 10, right: 10),
      height: MediaQuery.of(context).size.height * 0.045,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Colors.grey.shade300, borderRadius: BorderRadius.circular(5)),

      /// TextField Search
      child: TextField(
        style: const TextStyle(
            color: Colors.black, decoration: TextDecoration.none),
        cursorColor: Colors.black,
        controller: textEditingController,
        onChanged: (text) {
          sendSearchRequest(text);
        },
        decoration: InputDecoration(
            hintText: "Search",
            hintStyle: TextStyle(
                color: Colors.grey.shade700, decoration: TextDecoration.none),
            prefixIcon: const Icon(
              CupertinoIcons.search,
              size: 20,
              color: Colors.black,
            ),
            suffixIcon: const Icon(
              CupertinoIcons.location_solid,
              size: 20,
              color: Colors.black,
            ),
            // contentPadding: EdgeInsets.all(15),
            border: InputBorder.none),
      ),
    );
  }
}
