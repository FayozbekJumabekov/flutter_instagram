import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram/pages/sign_up_page.dart';

import 'control_page.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);
  static const String id = 'sign_in_page';

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
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
                        cursorColor: Colors.grey,
                        decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10),
                            hintText: "Email".tr(),
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
                        cursorColor: Colors.grey,
                        decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10),
                            hintText: "Password".tr(),
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
                          Navigator.pushReplacementNamed(context, ControlPage.id);
                          FocusScope.of(context).requestFocus(FocusNode());
                        },
                        child: const Text(
                          "Sign In",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ).tr()),
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
                    text: "Don't have an account? ".tr(),
                    children: [
                  TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pushReplacementNamed(
                              context, SignUpPage.id);
                        },
                      style: TextStyle(color: Colors.blue.shade900),
                      text: "Sign Up".tr()),
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
