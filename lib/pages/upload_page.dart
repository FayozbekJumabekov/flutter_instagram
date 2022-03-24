import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram/models/post_model.dart';
import 'package:flutter_instagram/pages/feed_page.dart';
import 'package:image_picker/image_picker.dart';
import '../services/log_service.dart';

class UploadPage extends StatefulWidget {
  PageController pageController;

   UploadPage({required this.pageController,Key? key}) : super(key: key);

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  File? image;
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

  void uploadPost(){
    if(image != null){
      Post post = Post(id: '2', image: image,postImage: '', caption: captionController.text.trim(), createdDate: DateTime.now().toString(), isLiked: true, isMine: false, fullName: "Doniyor Ko'chimov");
      widget.pageController.jumpToPage(0);
      Navigator.push(context, MaterialPageRoute(builder: (context)=>FeedPage(post: post,pageController: widget.pageController,)));
    }
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
      body: SingleChildScrollView(
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
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: TextField(
                  controller: captionController,
                  cursorColor: Colors.grey,
                  decoration: InputDecoration(
                      hintText: "Caption".tr(),
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
                  title: Text('Pick Photo',style: TextStyle(color: Colors.grey.shade700),).tr(),
                  onTap: () {
                    _getImage(ImageSource.gallery);
                    Navigator.of(context).pop();
                  }),

              /// Take Photo
              ListTile(
                  leading: Icon(CupertinoIcons.camera_fill),
                  title: Text('Take Photo',style: TextStyle(color: Colors.grey.shade700),).tr(),
                  onTap: () {
                    _getImage(ImageSource.camera);
                    Navigator.of(context).pop();
                  }),
            ]),
          );
        });
  }
}
