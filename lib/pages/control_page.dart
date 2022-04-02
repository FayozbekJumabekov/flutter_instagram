import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram/pages/feed_page.dart';
import 'package:flutter_instagram/pages/like_page.dart';
import 'package:flutter_instagram/pages/profile_page.dart';
import 'package:flutter_instagram/pages/search_page.dart';
import 'package:flutter_instagram/pages/upload_page.dart';
import 'package:flutter_instagram/services/log_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../utils/utils.dart';

class ControlPage extends StatefulWidget {
  const ControlPage({Key? key}) : super(key: key);
  static const String id = 'control_page';

  @override
  State<ControlPage> createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
  int selectedIndex = 0;
  PageController pageController = PageController();

  _initNotification() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      Log.w("ForeGround message working... $message");
      Utils.showLocalNotification(message,context);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      Log.w("OpENED APP message working... $message");
      Utils.showLocalNotification(message,context);
    });
  }

  @override
  void initState() {
    super.initState();
    _initNotification();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        controller: pageController,
        children: [
          FeedPage(
            pageController: pageController,
          ),
          SearchPage(),
          UploadPage(
            pageController: pageController,
          ),
          LikePage(),
          ProfilePage()
        ],
      ),
      bottomNavigationBar: CupertinoTabBar(
        inactiveColor: Colors.black,
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
            icon: Icon(FontAwesomeIcons.plusSquare),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border_outlined),
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person_alt_circle_fill),
          ),
        ],
      ),
    );
  }
}
