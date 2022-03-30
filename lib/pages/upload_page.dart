import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram/models/post_model.dart';
import 'package:flutter_instagram/services/firestore_service.dart';
import 'package:flutter_instagram/services/storage_service.dart';
import 'package:flutter_instagram/utils/widget_catalog.dart';
import 'package:image_picker/image_picker.dart';
import '../models/user_model.dart';
import '../services/log_service.dart';

class UploadPage extends StatefulWidget {
  PageController pageController;

  UploadPage({required this.pageController, Key? key}) : super(key: key);

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  File? image;
  bool isLoading = false;
  final picker = ImagePicker();
  TextEditingController captionController = TextEditingController();

  /// Get Image from local device
  Future<void> _getImage(ImageSource imageSource) async {
    final pickedFile = await picker.pickImage(source: imageSource);
    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
        Log.i('File Selected!!! ');
      });
    } else {
      Log.e('No file selected');
    }
  }

  /// Send Request FireStore
  void sendRequest() {
    StoreService.uploadImage(image!, StoreService.folderPostImg).then((imgUrl) {
      getResponsePost(imgUrl!);
    });
  }

  /// Get Response
  void getResponsePost(String imgUrl) {
    String caption = captionController.text.trim().toString();
    Post post = Post(postImage: imgUrl, caption: caption);
    apiStorePost(post);
  }

  /// Store Post
  void apiStorePost(Post post) async {
    // For postFolder
    Post posted = await FireStoreService.storePost(post);
    // For feedFolder
    FireStoreService.storeFeed(posted).then((value) {
      goToFeedPage();
    });
  }

  /// Upload Function
  void uploadPost() {
    if ((image == null) || (captionController.text.isEmpty)) {
      WidgetCatalog.showSnackBar(context, "Empty field !!!");
      return;
    } else {
      setState(() {
        isLoading = true;
        FocusScope.of(context).requestFocus(FocusNode());
      });
      sendRequest();
    }
  }

  Future<void> goToFeedPage() async {
    setState(() {
      image = null;
      isLoading = false;
    });
    widget.pageController.jumpToPage(0);
    User me = await FireStoreService.loadUser();
    me.postCount = me.postCount + 1;
    Log.w(me.postCount.toString());
    await FireStoreService.updateUser(me);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: const Text(
          'Upload',
          style: TextStyle(
              fontFamily: 'Billabong', color: Colors.black, fontSize: 28),
        ),
        actions: [
          IconButton(
            onPressed: () {
              uploadPost();
            },
            icon: Icon(Icons.post_add),
            color: Colors.purple,
          )
        ],
        centerTitle: true,
      ),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  /// Image
                  Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.width,
                        color: Colors.grey.shade300,
                        child: (image == null)
                            ? IconButton(
                                icon: Icon(
                                  Icons.add_a_photo,
                                ),
                                onPressed: () {
                                  buildShowModalBottomSheet(context);
                                },
                                iconSize: 50,
                                color: Colors.grey,
                              )
                            : Image.file(image!),
                      ),
                      if (image != null)
                        IconButton(
                          onPressed: () {
                            setState(() {
                              image = null;
                            });
                          },
                          icon: Icon(CupertinoIcons.clear_circled),
                          color: Colors.white,
                        )
                    ],
                  ),

                  /// TextField Caption
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: TextField(
                      controller: captionController,
                      cursorColor: Colors.grey,
                      decoration: const InputDecoration(
                          hintText: "Caption",
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.grey)),
                    ),
                  ),
                  Divider(
                    height: 0,
                    color: Colors.grey.shade700,
                  )
                ],
              ),
            ),
          ),
          if (isLoading)
            const CupertinoActivityIndicator(
              radius: 30,
              color: Colors.blue,
            )
        ],
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
}
