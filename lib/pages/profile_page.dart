import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram/utils/glow_widget.dart';
import 'package:flutter_instagram/utils/profile_details.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../services/auth_service.dart';
import '../utils/widget_catalog.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
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
              children: const [
                Text(
                  "fayozbek.tuit",
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
                  ProfDetails(),
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
                          itemCount: 7,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  mainAxisSpacing: 2,
                                  crossAxisSpacing: 2,
                                  crossAxisCount: 3),
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              color: Colors.grey.shade300,
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
