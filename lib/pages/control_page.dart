import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram/pages/feed_page.dart';
import 'package:flutter_instagram/pages/like_page.dart';
import 'package:flutter_instagram/pages/profile_page.dart';
import 'package:flutter_instagram/pages/search_page.dart';
import 'package:flutter_instagram/pages/upload_page.dart';

class ControlPage extends StatefulWidget {
  const ControlPage({Key? key}) : super(key: key);
  static const String id = 'control_page';

  @override
  State<ControlPage> createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
  int selectedIndex = 0;
  PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        onPageChanged: (index){
          setState(() {
            selectedIndex = index;
          });
        },
        controller: pageController,
        children: [
          FeedPage(),
          SearchPage(),
          UploadPage(),
          LikePage(),
          ProfilePage()
        ],
      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: selectedIndex,
        activeColor: Colors.purple,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
            pageController.jumpToPage(selectedIndex);
          });
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.search),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box),
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.heart),
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person_alt_circle_fill),
          ),
        ],
      ),
    );
  }
}
