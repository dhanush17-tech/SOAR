import 'package:SOAR/auth/login.dart';
import 'package:SOAR/screens/chat/chat_home.dart';
import 'package:SOAR/screens/chat/text_screen.dart';
import 'package:SOAR/screens/stories.dart';
import 'package:SOAR/screens/feed.dart';
import 'package:SOAR/screens/post/post_image.dart';
import 'package:SOAR/screens/profile.dart';
import 'package:SOAR/screens/settings_page.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:circular_reveal_animation/circular_reveal_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class StartEnt extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StartEntrepreneur(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class StartEntrepreneur extends StatefulWidget {
  @override
  _StartEntrepreneurState createState() => _StartEntrepreneurState();
}

class _StartEntrepreneurState extends State<StartEntrepreneur>
    with SingleTickerProviderStateMixin {
  var _bottomNavIndex = 0; //default index of first screen

  AnimationController _animationController;
  Animation<double> animation;
  CurvedAnimation curve;
  @override
  void initState() {
    super.initState();
    final systemTheme = SystemUiOverlayStyle.light.copyWith(
      systemNavigationBarColor: HexColor('#373A36'),
      systemNavigationBarIconBrightness: Brightness.light,
    );
    SystemChrome.setSystemUIOverlayStyle(systemTheme);

    _animationController = AnimationController(
      duration: Duration(seconds: 0),
      vsync: this,
    );
    curve = CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.5,
        1.0,
        curve: Curves.fastOutSlowIn,
      ),
    );
    animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(curve);

    Future.delayed(
      Duration(seconds: 0),
      () => _animationController.forward(),
    );
  }

  final iconList = <IconData>[
    Icons.settings,
    Icons.add,
    Icons.message,
    Icons.person,
  ];
  final screen = [
    SettingsPage(),
    PostImage(),
    ChatScreen(),
    Profile(
      uidforprofile: auth.currentUser.uid,
    ),
   
  ];
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      extendBody: true,
      backgroundColor: Color(4278190106),
      body: NavigationforentrepreneurScreen(
        screen[_bottomNavIndex],
      ),
      floatingActionButton: ScaleTransition(
        scale: animation,
        child: FloatingActionButton(
          heroTag: "add",
          elevation: 8,
          backgroundColor: Colors.blue[800],
          child: Icon(
            Icons.explore,
            color: Color(4278190106),
          ),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => Stories()));
          },
        ),
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar.builder(
        itemCount: iconList.length,
        tabBuilder: (int index, bool isActive) {
          final color = isActive ? Colors.white : Color(4278190106);
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15, left: 15),
                child: Icon(
                  iconList[index],
                  size: 24,
                  color: color,
                ),
              ),
              isActive
                  ? Padding(
                      padding: const EdgeInsets.only(top: 50, left: 25),
                      child: Container(
                        height: 2,
                        width: 2,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white,
                                blurRadius: 6.0,
                                spreadRadius: 10.0,
                                offset: Offset(
                                  0.0,
                                  3.0,
                                ),
                              ),
                            ]),
                      ),
                    )
                  : Container(
                      height: 8,
                      width: 8,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.transparent)),
            ],
          );
        },
        backgroundColor: Colors.blue[900],
        activeIndex: _bottomNavIndex,
        notchAndCornersAnimation: animation,
        splashSpeedInMilliseconds: 00,
        notchSmoothness: NotchSmoothness.defaultEdge,
        gapLocation: GapLocation.center,
        leftCornerRadius: 17,
        rightCornerRadius: 17,
        onTap: (index) => setState(() => _bottomNavIndex = index),
      ),
    );
  }
}

class NavigationforentrepreneurScreen extends StatefulWidget {
  final Widget iconData;

  NavigationforentrepreneurScreen(this.iconData) : super();

  @override
  _NavigationforentrepreneurScreenState createState() =>
      _NavigationforentrepreneurScreenState();
}

class _NavigationforentrepreneurScreenState
    extends State<NavigationforentrepreneurScreen>
    with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> animation;

  @override
  void didUpdateWidget(NavigationforentrepreneurScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.iconData != widget.iconData) {
      _startAnimation();
    }
  }

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 0),
    );
    animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
    _controller.forward();
    super.initState();
  }

  _startAnimation() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 0),
    );
    animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.white,
      child: Center(
        child: CircularRevealAnimation(
            animation: animation,
            centerOffset: Offset(80, 80),
            maxRadius: MediaQuery.of(context).size.longestSide * 1.1,
            child: Container(
              child: widget.iconData,
            )),
      ),
    );
  }
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}
