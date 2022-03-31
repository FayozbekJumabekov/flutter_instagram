import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram/models/user_model.dart' as model;
import 'package:flutter_instagram/pages/sign_up_page.dart';
import 'package:flutter_instagram/services/firestore_service.dart';
import 'package:flutter_instagram/utils/utils.dart';

import '../services/auth_service.dart';
import '../services/log_service.dart';
import '../services/prefs_service.dart';
import 'control_page.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);
  static const String id = 'sign_in_page';

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool hidePassword = true;

  void _doSignIn(BuildContext context) {
    String email = _emailController.text.toString().trim();
    String password = _passwordController.text.toString().trim();
    AuthenticationService.signInUser(context, email, password).then((value) => {
          getUser(value),
        });
  }

  void getUser(User? user) async {
    if (user != null) {
      Prefs.store(StorageKeys.UID, user.uid);
      Utils.initNotification();
      _apiUpdateUser();
      Navigator.pushReplacementNamed(context, ControlPage.id);
    } else {
      Log.e("Null Response");
    }
  }

  void _apiUpdateUser() async {
    model.User userModel = await FireStoreService.loadUser();
    userModel.device_token = (await Prefs.load(StorageKeys.TOKEN))!;
    await FireStoreService.updateUser(userModel);
  }


  @override
  void initState() {
    super.initState();

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.1),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ///Instagram Text

                    const Text(
                      'Instagram',
                      style: TextStyle(fontFamily: 'Billabong', fontSize: 50),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(
                      height: 50,
                    ),

                    /// TextFields
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                      decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          border: Border.all(color: Colors.grey.shade300)),
                      child: TextField(
                        controller: _emailController,
                        cursorColor: Colors.grey,
                        decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10),
                            hintText: "Email",
                            hintStyle:
                                TextStyle(fontSize: 15, color: Colors.grey),
                            border: InputBorder.none),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                      decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          border: Border.all(color: Colors.grey.shade300)),
                      child: TextField(
                        controller: _passwordController,
                        cursorColor: Colors.grey,
                        decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10),
                            hintText: "Password",
                            hintStyle:
                                TextStyle(fontSize: 15, color: Colors.grey),
                            border: InputBorder.none),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),

                    const SizedBox(
                      height: 15,
                    ),

                    /// Sign In Button
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.blue, fixedSize: Size(50, 50)),
                        onPressed: () {
                          _doSignIn(context);
                          FocusScope.of(context).requestFocus(FocusNode());
                        },
                        child: const Text(
                          "Sign In",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        )),
                  ],
                ),
              ),
            ),

            const Divider(
              color: Colors.grey,
              height: 40,
            ),

            /// Already have account SignIn Text
            RichText(
                text: TextSpan(
                    style: const TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                    text: "Don't have an account? ",
                    children: [
                  TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pushReplacementNamed(
                              context, SignUpPage.id);
                        },
                      style: TextStyle(color: Colors.blue.shade900),
                      text: "Sign Up"),
                ])),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    ));
  }
}
