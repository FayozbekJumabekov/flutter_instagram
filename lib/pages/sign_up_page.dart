import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram/pages/control_page.dart';
import 'package:flutter_instagram/pages/sign_in_page.dart';
import 'package:flutter_instagram/services/firestore_service.dart';
import 'package:flutter_instagram/services/prefs_service.dart';
import 'package:flutter_instagram/models/user_model.dart' as model;
import 'package:flutter_instagram/utils/utils.dart';
import '../services/auth_service.dart';
import '../views/widget_catalog.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);
  static const String id = 'sign_up_page';

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _cpasswordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  bool hidePassword = true;
  bool isLoading = false;

  bool _checkValid(BuildContext context, String firstName, String email,
      String password, String cpassword) {
    if (email.isEmpty || password.isEmpty || firstName.isEmpty) {
      WidgetCatalog.showSnackBar(
          context, "Field can not be empty. Please fill it");
      return false;
    }

    if (!Utils.isValidEmail(email)) {
      WidgetCatalog.showSnackBar(context, "Please, enter valid Email");
      return false;
    }

    if (!Utils.isValidPassword(password)) {
      WidgetCatalog.showSnackBar(context,
          "Password must be at least one upper case, one lower case, one digit, one Special character & be at least 8 characters in length");
      return false;
    }

    if (password != cpassword) {
      WidgetCatalog.showSnackBar(context, "Passwords do not match");
      return false;
    }
    return true;
  }

  void _doSignUp(BuildContext context) {
    String email = _emailController.text.toString().trim();
    String password = _passwordController.text.toString().trim();
    String cpassword = _cpasswordController.text.toString().trim();
    String firstName = _nameController.text.toString().trim();

    model.User user =
        model.User(fullName: firstName, email: email, password: password);
    if (_checkValid(context, firstName, email, password, cpassword)) {
      setState(() {
        isLoading = true;
      });
      AuthenticationService.signUpUser(
              context: context,
              name: firstName,
              email: email,
              password: password)
          .then((value) => {
                getUser(user, value),
              });
    }
  }

  void getUser(model.User user, User? firebaseuser) async {
    if (firebaseuser != null) {
      Prefs.store(StorageKeys.UID, firebaseuser.uid);
      user.uid = firebaseuser.uid;
      FireStoreService.storeUser(user).then((value) {
        setState(() {
          isLoading = false;
        });
        Navigator.pushReplacementNamed(context, ControlPage.id);
      });
    }
    else{
      setState(() {
        isLoading = false;
      });
    }
  }


  @override
  void initState() {
    super.initState();
    Utils.initNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        body: Stack(
          alignment: Alignment.center,
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.1),
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
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
                                controller: _nameController,
                                cursorColor: Colors.grey,
                                decoration: InputDecoration(
                                    contentPadding:
                                        const EdgeInsets.symmetric(horizontal: 10),
                                    hintText: "Fullname",
                                    hintStyle: const TextStyle(
                                        fontSize: 15, color: Colors.grey),
                                    border: InputBorder.none),
                              )),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 2),
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
                            margin: const EdgeInsets.symmetric(vertical: 5),
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
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 5),
                            padding:
                                EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                            decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                border: Border.all(color: Colors.grey.shade300)),
                            child: TextField(
                              controller: _cpasswordController,
                              cursorColor: Colors.grey,
                              decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 10),
                                  hintText: "Confirm",
                                  hintStyle:
                                      TextStyle(fontSize: 15, color: Colors.grey),
                                  border: InputBorder.none),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),

                          /// Text
                          const Text(
                            'Receive sms',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(
                            height: 15,
                          ),

                          /// Sign Up Button
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.blue, fixedSize: Size(50, 50)),
                              onPressed: () {
                                _doSignUp(context);
                                FocusScope.of(context).requestFocus(FocusNode());
                              },
                              child: const Text(
                                "Sign Up",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              )),
                        ],
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
                            text: "Already have account? ",
                            children: [
                          TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pushReplacementNamed(
                                      context, SignInPage.id);
                                },
                              style: TextStyle(color: Colors.blue.shade900),
                              text: "Sign In"),
                        ])),
                    const SizedBox(
                      height: 30,
                    )
                  ],
                ),
              ),
            ),
            if(isLoading)const CupertinoActivityIndicator(
              radius: 30,
            )
          ],
        ));
  }
}
