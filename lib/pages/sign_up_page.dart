import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram/pages/sign_in_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);
  static const String id = 'sign_up_page';

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool hidePassword = true;
  String _chosenValue = 'Please choose a langauage';
  String selectedLang = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          /// Dropdow
          title: Container(
            alignment: Alignment.center,
            child: DropdownButton<String>(
              value: selectedLang,
              underline: SizedBox.shrink(),
              items: <String>['English', 'Uzbek', 'Russian']
                  .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedLang = value!;
                  switch (selectedLang) {
                    case "English":
                      context.setLocale(Locale('en', 'US'));
                      break;
                    case "Russian":
                      context.setLocale(Locale('ru', 'RU'));
                      break;
                    case "Uzbek":
                      context.setLocale(Locale('uz', 'UZ'));
                      break;
                  }
                });
              },
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
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
                            cursorColor: Colors.grey,
                            decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                hintText: "Fullname".tr(),
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
                        margin: const EdgeInsets.symmetric(vertical: 5),
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
                              hintText: "Confirm".tr(),
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
                      ).tr(),
                      const SizedBox(
                        height: 15,
                      ),

                      /// Sign Up Button
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.blue, fixedSize: Size(50, 50)),
                          onPressed: () {
                            FocusScope.of(context).requestFocus(FocusNode());
                          },
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ).tr()),
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
                        text: "Already have account? ".tr(),
                        children: [
                      TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushReplacementNamed(
                                  context, SignInPage.id);
                            },
                          style: TextStyle(color: Colors.blue.shade900),
                          text: "Sign In".tr()),
                    ])),
                const SizedBox(
                  height: 30,
                )
              ],
            ),
          ),
        ));
  }
}
