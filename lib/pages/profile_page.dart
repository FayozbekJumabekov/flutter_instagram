import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/post_model.dart';
import '../models/user_model.dart';
import '../services/firestore_service.dart';
import '../views/glow_widget.dart';
import '../views/profile_details.dart';
import '../views/widget_catalog.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? user;
  List<Post> posts = [];

  @override
  void initState() {
    super.initState();
    _apiLoadUser();
    loadPost();
  }

  void loadPost() {
    FireStoreService.loadPosts().then((posts) {
      setState(() {
        this.posts = posts;
      });
    });
  }

  void _apiLoadUser() async {
    FireStoreService.loadUser().then((value) {
      setState(() {
        user = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: ListTile(
            contentPadding: const EdgeInsets.symmetric(),
            title: Row(
              children: [
                Text(
                  (user != null) ? user!.email! : '',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                ),
              ],
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                WidgetCatalog.buildShowModalBottomSheet(context);
              },
              child: Icon(
                FontAwesomeIcons.bars,
                size: 26,
              ),
            ),
            SizedBox(
              width: 14,
            )
          ],
        ),
        body: Glow(
          child: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return [
                SliverList(
                    delegate: SliverChildListDelegate([
                  ProfDetails(
                    user: user,
                  ),
                ]))
              ];
            },
            body: Column(
              children: [
                const Divider(
                  height: 0,
                ),
                const TabBar(
                  indicatorColor: Colors.black,
                  indicatorWeight: 0.8,
                  tabs: [
                    Tab(
                      icon: Icon(
                        Icons.grid_on_sharp,
                        size: 25,
                        color: Colors.black,
                      ),
                    ),
                    Tab(
                      icon: Icon(
                        Icons.perm_contact_cal_rounded,
                        size: 25,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: GridView.builder(
                          padding: EdgeInsets.symmetric(vertical: 2,horizontal: 2),
                          itemCount: posts.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  mainAxisSpacing: 2,
                                  crossAxisSpacing: 2,
                                  crossAxisCount: 3),
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              child: CachedNetworkImage(
                                imageUrl: posts[index].postImage!,
                                placeholder: (context, url) => const Image(
                                  image: AssetImage('assets/images/im_placeholder.png'),
                                  fit: BoxFit.cover,
                                ),
                                errorWidget: (context, url, error) => Icon(Icons.error),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: GridView.builder(
                          itemCount: 7,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  mainAxisSpacing: 1,
                                  crossAxisSpacing: 1,
                                  crossAxisCount: 2),
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              color: Colors.grey.shade300,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
