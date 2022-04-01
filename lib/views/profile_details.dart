import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram/models/user_model.dart';
import 'package:flutter_instagram/services/firestore_service.dart';
import 'package:flutter_instagram/views/shimmer_anim.dart';
import 'package:image_picker/image_picker.dart';
import '../services/log_service.dart';
import '../services/storage_service.dart';

class ProfDetails extends StatefulWidget {
  User? user;

  ProfDetails({required this.user, Key? key}) : super(key: key);

  @override
  State<ProfDetails> createState() => _ProfDetailsState();
}

class _ProfDetailsState extends State<ProfDetails> {
  List<String> storyText = [
    "New",
    "Sport",
    "Travelling",
    "Time Management",
    "Education"
  ];
  bool isLoading = true;
  User? user;
  File? image;
  final picker = ImagePicker();

  void getUser() {
    setState(() {
      user = widget.user;
    });
  }

  @override
  void didUpdateWidget(covariant ProfDetails oldWidget) {
    super.didUpdateWidget(oldWidget);
    getUser();
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  // for edit user
  void _apiChangePhoto() {
    if (image == null) return;
    setState(() {
      isLoading = false;
    });
    StoreService.uploadImage(image!, StoreService.folderUserImg).then((imgUrl) {
      setState(() {
        isLoading = true;
        user!.imageUrl = imgUrl;
      });
      FireStoreService.updateUser(user!);
    });
  }

  /// Get Image from local device
  Future<void> _getImage(ImageSource imageSource) async {
    final pickedFile = await picker.pickImage(source: imageSource);
    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
        _apiChangePhoto();
        Log.i('File Selected!!! ');
      });
    } else {
      Log.e('No file selected');
    }
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
                      leading: GestureDetector(
                        onTap: () {
                          buildShowModalBottomSheet(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.purple,
                              borderRadius: BorderRadius.circular(100)),
                          padding: EdgeInsets.all(2),
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                border:
                                    Border.all(color: Colors.white, width: 1),
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
            ((user != null))
                ? Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        /// Profile Name
                        Text(
                          user!.fullName!,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 1,
                        ),

                        /// # Profile details
                        const Text.rich(TextSpan(
                            text: "Digital goodies designer ",
                            style: TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 14),
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
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w400),
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
                                  color:
                                      Theme.of(context).textTheme.button?.color,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600),
                            )),
                      ],
                    ),
                  )
                : buildMovieShimmer(false),

            /// # Story List
            Container(
              alignment: Alignment.center,
              height: MediaQuery.of(context).size.height * 0.18,
              child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  itemCount: 5,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          (index == 0)

                              /// # Add story
                              ? Container(
                                  height: 70,
                                  width: 70,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      border: Border.all(color: Colors.black)),
                                  child: const Icon(
                                    Icons.add_sharp,
                                    size: 30,
                                  ),
                                )

                              /// # Story with picture
                              : Container(
                                  padding: EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.black, width: 1),
                                      borderRadius: BorderRadius.circular(100)),
                                  child: Container(
                                    height: 65,
                                    width: 65,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                  ),
                                ),
                          const SizedBox(
                            height: 5,
                          ),

                          /// Story Description
                          Container(
                            width: 70,
                            alignment: Alignment.center,
                            child: Text(
                              storyText[index],
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 12,
                                  letterSpacing: 0.01,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }

  /// BottomSheet
  Future<dynamic> buildShowModalBottomSheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: Wrap(children: [
              const SizedBox(
                height: 10,
              ),

              /// From Gallery
              ListTile(
                  leading: Icon(CupertinoIcons.photo_fill_on_rectangle_fill),
                  title: Text(
                    'Pick Photo',
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                  onTap: () {
                    _getImage(ImageSource.gallery);
                    Navigator.of(context).pop();
                  }),

              /// Take Photo
              ListTile(
                  leading: Icon(CupertinoIcons.camera_fill),
                  title: Text(
                    'Take Photo',
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                  onTap: () {
                    _getImage(ImageSource.camera);
                    Navigator.of(context).pop();
                  }),
            ]),
          );
        });
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
