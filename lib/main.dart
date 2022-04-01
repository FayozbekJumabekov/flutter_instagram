import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram/pages/control_page.dart';
import 'package:flutter_instagram/pages/sign_in_page.dart';
import 'package:flutter_instagram/pages/sign_up_page.dart';
import 'package:flutter_instagram/pages/splash_page.dart';
import 'package:flutter_instagram/services/prefs_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // notification
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description: 'This channel is used for important notifications.',
    // description
    importance: Importance.max,
  );
  await FlutterLocalNotificationsPlugin()
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  var initAndroidSetting = const AndroidInitializationSettings('@mipmap/ic_launcher');
  var initIosSetting = const IOSInitializationSettings();
  var initSetting = InitializationSettings(android: initAndroidSetting, iOS: initIosSetting);
  await FlutterLocalNotificationsPlugin().initialize(initSetting);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  Widget _startPage() {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, snapshot) {
        if (!snapshot.hasData) {
          Prefs.remove(StorageKeys.UID);
          return SignInPage();
        } else {
          Prefs.store(StorageKeys.UID, snapshot.data!.uid);
          return SplashPage();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Instagram Demo',
      theme: ThemeData(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: _startPage(),
      routes: {
        SplashPage.id: (context) => SplashPage(),
        SignUpPage.id: (context) => SignUpPage(),
        SignInPage.id: (context) => SignInPage(),
        ControlPage.id: (context) => ControlPage()
      },
    );
  }
}
