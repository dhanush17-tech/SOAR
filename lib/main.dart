import 'package:SOAR/screens/chat/chat_home.dart';
import 'package:SOAR/screens/feed.dart';
import 'package:SOAR/screens/feed_details.dart';
import 'package:SOAR/screens/post/post_details.dart';
import 'package:SOAR/screens/settings_page.dart';
import 'package:SOAR/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:SOAR/screens/profile.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:SOAR/screens/post/post_image.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'screens/movivation.dart';
import 'auth/login.dart';
import 'package:firebase_core/firebase_core.dart';

void _enablePlatformOverrideForDesktop() {
  if (!kIsWeb && (Platform.isMacOS || Platform.isWindows || Platform.isLinux)) {
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  }
}

void main() async {
  _enablePlatformOverrideForDesktop();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Man());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SOAR',
      home: Movivation(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _seletedItem = 0;
  var _pages = [Feed(), Profile(), PostImage(), SettingsPage()];
  GlobalKey _bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _pages[_seletedItem],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Color(4278190106),
        color: Color(4278228470),
        height: 55,
        key: _bottomNavigationKey,
        items: <Widget>[
          Icon(Icons.home, size: 30),
          Icon(Icons.person, size: 30),
          Icon(
            Icons.add_box,
            size: 30,
          ),
          Icon(Icons.settings, size: 30),
        ],
        onTap: (index) {
          setState(() {
            _seletedItem = index;
          });
        },
      ),
    );
  }
}
