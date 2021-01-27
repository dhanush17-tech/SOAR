import 'package:SOAR/screens/feed.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../screens/profile.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:SOAR/auth/login.dart';
import 'package:SOAR/motivation_scrren/video_motivation.dart';
import "dart:ui";
import 'package:SOAR/screens/assist.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:easy_gradient_text/easy_gradient_text.dart';
import 'dart:math' as math;
import 'video_promotion.dart';
import 'package:video_thumbnail_generator/video_thumbnail_generator.dart';

void _enablePlatformOverrideForDesktop() {
  if (!kIsWeb && (Platform.isMacOS || Platform.isWindows || Platform.isLinux)) {
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  }
}

void main() {
  _enablePlatformOverrideForDesktop();
  runApp(HomeScreen());
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  String name;
  fetch() {
    Firestore.instance
        .collection("Users")
        .document(auth.currentUser.uid)
        .get()
        .then((value) {
      setState(() {
        name = value.data()["name"];
      });
    });
  }

  @override
  void initState() {
    super.initState();
    fetch();
    controller = PageController();
    _controller = AnimationController(vsync: this, duration: duration);
    _scaleAnimation = Tween<double>(begin: 1, end: 0.8).animate(_controller);
    _menuScaleAnimation =
        Tween<double>(begin: 0.5, end: 1).animate(_controller);
    _slideAnimation = Tween<Offset>(begin: Offset(-1, 0), end: Offset(0, 0))
        .animate(_controller);
  }

  bool isCollapsed = true;

  final Duration duration = const Duration(milliseconds: 300);
  AnimationController _controller;
  Animation<double> _scaleAnimation;
  Animation<double> _menuScaleAnimation;
  Animation<Offset> _slideAnimation;

  bool isDrawerOpen = false;

  Future _signOut() async {
    _logoutUser().then((value) {
      print("done");
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Loginscreen()));
    });
  }

  SharedPreferences prefs;

  Future<Null> _logoutUser() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final FacebookLogin facebookLogIn = FacebookLogin();
    await facebookLogIn.logOut();
    await googleSignIn.signOut();

    prefs = await SharedPreferences.getInstance();
    await prefs.remove("useremail");
  }

  String dpurl;

  Future<void> _edit() async {
    try {
      await Firestore.instance
          .collection("Users")
          .document(auth.currentUser.uid)
          .get()
          .then((value) {
        setState(() {
          dpurl = value.data()["location"];
        });
      });
    } catch (e) {}
  }

  Widget menu(context) {
    return SlideTransition(
      position: _slideAnimation,
      child: ScaleTransition(
        scale: _menuScaleAnimation,
        child: Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: Padding(
            padding: EdgeInsets.only(top: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                StreamBuilder(
                  stream: Firestore.instance
                      .collection("Users")
                      .document(auth.currentUser.uid)
                      .snapshots(),
                  builder: (ctx, sn) {
                    return dpurl != null
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 190),
                                    child: CircleAvatar(
                                      backgroundColor: Color(4278272638),
                                      backgroundImage: NetworkImage(
                                        dpurl,
                                      ),
                                      radius: 40,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 190),
                                  child: Text(
                                    sn.data["name"],
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                        fontSize: 20, color: Color(4278228470)),
                                  ),
                                )
                              ],
                            ),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 200),
                                child: CircleAvatar(
                                  backgroundColor: Color(4278272638),
                                  backgroundImage:
                                      AssetImage("assets/unknown.png"),
                                  radius: 40,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 206),
                                child: Text(
                                  sn.data["name"],
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                      fontSize: 20, color: Color(4278228470)),
                                ),
                              )
                            ],
                          );
                  },
                ),
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.595,
                          top: 30),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) => Assist()));
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Image.asset(
                              "assets/faq.png",
                              scale: 19,
                              color: Colors.black,
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Text(
                              "Support",
                              style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
                            )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.595,
                          top: 30),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) => Assist()));
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Icon(
                              Icons.assignment,
                              color: Colors.black,
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Text(
                              "Privacy policy",
                              style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
                            )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.595,
                          top: 30),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) => Assist()));
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Icon(
                              Icons.brightness_2,
                              color: Colors.black,
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Text(
                              "Dark Theme",
                              style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.535),
                      child: Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: GestureDetector(
                          onTap: () async {
                            await _signOut();
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Icon(
                                Icons.exit_to_app_outlined,
                                color: Colors.redAccent,
                                size: 25,
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Text(
                                "Sign Out",
                                style: GoogleFonts.poppins(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.red),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(0xFFE6EDFA),
      body: Stack(
        children: [
          menu(context),
          AnimatedPositioned(
            duration: duration,
            top: 0,
            bottom: isCollapsed ? 0 : 0.02 * screenHeight,
            left: isCollapsed ? 0 : -0.4 * screenWidth,
            right: isCollapsed ? 0 : 0.4 * screenWidth,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Material(
                color: Color(0xFFE6EDFA),
                animationDuration: duration,
                borderRadius: BorderRadius.circular(20),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10, top: 20),
                            child: SingleChildScrollView(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Material(
                                        type: MaterialType.transparency,
                                        child: Text(
                                          "Hello There",
                                          style: GoogleFonts.poppins(
                                            color: Color(4278228470),
                                            fontSize: 30,
                                            height: 1,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                100,
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Padding(
                                              padding: const EdgeInsets.only(
                                                top: 16,
                                              ),
                                              child: name == null
                                                  ? Text("",
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 25,
                                                        height: 0.5,
                                                        color: Colors.indigo,
                                                      ))
                                                  : Text(name,
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 25,
                                                        height: 0.5,
                                                        color: Colors.indigo,
                                                      ))),
                                        ),
                                      ),
                                    ],
                                  ),
                                  isCollapsed
                                      ? Padding(
                                          padding: EdgeInsets.only(
                                              bottom: 30, right: 0),
                                          child: IconButton(
                                            icon: Icon(
                                              Icons.menu,
                                              size: 30,
                                              color: Colors.blue,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                if (isCollapsed)
                                                  _controller.forward();
                                                else
                                                  _controller.reverse();

                                                isCollapsed = !isCollapsed;
                                              });
                                            },
                                          ),
                                        )
                                      : Padding(
                                          padding: EdgeInsets.only(
                                              bottom: 0, right: 0),
                                          child: IconButton(
                                            icon: Icon(
                                              Icons.arrow_back_ios,
                                              color: Colors.blue,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                if (isCollapsed)
                                                  _controller.forward();
                                                else
                                                  _controller.reverse();

                                                isCollapsed = !isCollapsed;
                                              });
                                            },
                                          ))
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Container(
                          alignment: Alignment.topLeft,
                          child: GradientText(
                            text: "Trending",
                            colors: [Colors.indigo, Colors.blue],
                            style: GoogleFonts.poppins(
                                fontSize: 28, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, left: 10),
                        child: Container(
                          height: 200,
                          width: MediaQuery.of(context).size.width,
                          child: StreamBuilder(
                              stream: Firestore.instance
                                  .collection("trending")
                                  .snapshots(),
                              builder: (context, snapshot) {
                                return snapshot.data == null
                                    ? Container()
                                    : ListView.separated(
                                        physics: BouncingScrollPhysics(),
                                        itemCount:
                                            snapshot.data.documents.length,
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (ctx, i) {
                                          DocumentSnapshot trending =
                                              snapshot.data.documents[i];
                                          return Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  gradient: LinearGradient(
                                                      colors: [
                                                        Color(0xFF4E82E8),
                                                        Colors.blue
                                                      ]),
                                                  image: DecorationImage(
                                                      image: NetworkImage(
                                                        trending["url"],
                                                      ),
                                                      fit: BoxFit.fill)),
                                              width: 350.0,
                                            ),
                                          );
                                        },
                                        separatorBuilder: (context, index) =>
                                            SizedBox(width: 10),
                                      );
                              }),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Container(
                          alignment: Alignment.topLeft,
                          child: GradientText(
                            text: "Categories",
                            colors: [Colors.indigo, Colors.blue],
                            style: GoogleFonts.poppins(
                                fontSize: 28, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        height: 50,
                        child: ListView(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            children: [
                              GestureDetector(
                                onTap: () => controller.animateToPage(0,
                                    duration: Duration(milliseconds: 500),
                                    curve: Curves.easeIn),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                        color: Colors.blue[300],
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Center(
                                        child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Text(
                                        "All",
                                        style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    )),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => controller.animateToPage(1,
                                    duration: Duration(milliseconds: 500),
                                    curve: Curves.easeIn),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                        color:
                                            Color(0xFF5894FA).withOpacity(0.9),
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Center(
                                        child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Text(
                                        "Motivational",
                                        style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    )),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              GestureDetector(
                                onTap: () => controller.animateToPage(2,
                                    duration: Duration(milliseconds: 500),
                                    curve: Curves.easeIn),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 0.0),
                                  child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                        color: Colors.green[300],
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Center(
                                        child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Text(
                                        "Sucess stories",
                                        style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    )),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => controller.animateToPage(3,
                                    duration: Duration(milliseconds: 500),
                                    curve: Curves.easeIn),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                        color: Colors.red[300],
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Center(
                                        child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Text(
                                        "Promotional",
                                        style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    )),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => controller.animateToPage(4,
                                    duration: Duration(milliseconds: 500),
                                    curve: Curves.easeIn),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                        color: Colors.pinkAccent[100],
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Center(
                                        child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Text(
                                        "Tips",
                                        style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    )),
                                  ),
                                ),
                              ),
                              SizedBox(width: 15)
                            ]),
                      ),
                      Container(
                        height: 500,
                        child: PageView(controller: controller, children: [
                          BuildHomeCardAll(context),
                          BuildHomeCardMotivational(context),
                          BuildHomeCardSuccess(context),
                          BuildHomeCardPoromotional(context),
                          BuildHomeCardTips(context)
                        ]),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  PageController controller;
}

Widget BuildHomeCardSuccess(context) {
  return StreamBuilder(
      stream: Firestore.instance
          .collection("all")
          .where("type", isEqualTo: "success")
          .snapshots(),
      builder: (context, snapshot) {
        return snapshot.data == null
            ? Container()
            : ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (ctx, i) {
                  var success = snapshot.data.documents[i];

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (c) => MotivationHome(
                                    "Success Stories",
                                    success.id,
                                  )));
                    },
                    child: Padding(
                      padding: EdgeInsets.only(top: 0, left: 5, right: 5),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.green[300],
                            borderRadius: BorderRadius.circular(20)),
                        child: Row(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 20, top: 30),
                                  child: Text(
                                    success["Title"],
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 5, left: 20, bottom: 10),
                                  child: SingleChildScrollView(
                                    child: Container(
                                      height: 90,
                                      width: MediaQuery.of(context).size.width -
                                          170,
                                      child: Text(
                                        success["sub"],
                                        style: GoogleFonts.poppins(
                                          height: 1.2,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width - 350,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 10.0, bottom: 5),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.32,
                                  height:
                                      MediaQuery.of(context).size.height * 0.17,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      image: DecorationImage(
                                          fit: BoxFit.fill,
                                          image: NetworkImage(
                                              success["lcation"]))),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                scrollDirection: Axis.vertical,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
              );
      });
}

Widget BuildHomeCardMotivational(context) {
  return StreamBuilder(
      stream: Firestore.instance
          .collection("all")
          .where("type", isEqualTo: "motivation")
          .snapshots(),
      builder: (context, snapshot) {
        return snapshot.data == null
            ? Container()
            : ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (ctx, i) {
                  var success = snapshot.data.documents[i];

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (c) =>
                                  MotivationHome("Motivational", success.id)));
                    },
                    child: Padding(
                      padding: EdgeInsets.only(top: 0, left: 5, right: 5),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Color(0xFF5894FA).withOpacity(0.9),
                            borderRadius: BorderRadius.circular(20)),
                        child: Row(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 20, top: 30),
                                  child: Text(
                                    success["Title"],
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 5, left: 20, bottom: 10),
                                  child: SingleChildScrollView(
                                    child: Container(
                                      height: 90,
                                      width: MediaQuery.of(context).size.width -
                                          170,
                                      child: Text(
                                        success["sub"],
                                        style: GoogleFonts.poppins(
                                          height: 1.2,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width - 350,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 10.0, bottom: 5),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.32,
                                  height:
                                      MediaQuery.of(context).size.height * 0.17,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      image: DecorationImage(
                                          fit: BoxFit.fill,
                                          image: NetworkImage(
                                              success["lcation"]))),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                scrollDirection: Axis.vertical,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
              );
      });
}

Widget BuildHomeCardPoromotional(context) {
  return StreamBuilder(
      stream: Firestore.instance
          .collection("all")
          .where("type", isEqualTo: "promo")
          .snapshots(),
      builder: (context, snapshot) {
        return snapshot.data == null
            ? Container()
            : ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (ctx, i) {
                  var success = snapshot.data.documents[i];

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (c) =>
                                  MotivationHome("Promotional", success.id)));
                    },
                    child: Padding(
                      padding: EdgeInsets.only(top: 0, left: 5, right: 5),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.red[300],
                            borderRadius: BorderRadius.circular(20)),
                        child: Row(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 20, top: 30),
                                  child: Text(
                                    success["Title"],
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 5, left: 20, bottom: 10),
                                  child: SingleChildScrollView(
                                    child: Container(
                                      height: 90,
                                      width: MediaQuery.of(context).size.width -
                                          170,
                                      child: Text(
                                        success["sub"],
                                        style: GoogleFonts.poppins(
                                          height: 1.2,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width - 350,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 10.0, bottom: 5),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.32,
                                  height:
                                      MediaQuery.of(context).size.height * 0.17,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      image: DecorationImage(
                                          fit: BoxFit.fill,
                                          image: NetworkImage(
                                              success["lcation"]))),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                scrollDirection: Axis.vertical,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
              );
      });
}

Widget BuildHomeCardTips(context) {
  return StreamBuilder(
      stream: Firestore.instance
          .collection("all")
          .where("type", isEqualTo: "tips")
          .snapshots(),
      builder: (context, snapshot) {
        return snapshot.data == null
            ? Container()
            : ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (ctx, i) {
                  var success = snapshot.data.documents[i];

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (c) =>
                                  MotivationHome("Tips", success.id)));
                    },
                    child: Padding(
                      padding: EdgeInsets.only(top: 0, left: 5, right: 5),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.pinkAccent[100],
                            borderRadius: BorderRadius.circular(20)),
                        child: Row(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 20, top: 30),
                                  child: Text(
                                    success["Title"],
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 5, left: 20, bottom: 10),
                                  child: SingleChildScrollView(
                                    child: Container(
                                      height: 90,
                                      width: MediaQuery.of(context).size.width -
                                          170,
                                      child: Text(
                                        success["sub"],
                                        style: GoogleFonts.poppins(
                                          height: 1.2,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width - 350,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 10.0, bottom: 5),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.32,
                                  height:
                                      MediaQuery.of(context).size.height * 0.17,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      image: DecorationImage(
                                          fit: BoxFit.fill,
                                          image: NetworkImage(
                                              success["lcation"]))),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                scrollDirection: Axis.vertical,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
              );
      });
}

Widget BuildHomeCardAll(context) {
  return StreamBuilder(
      stream: Firestore.instance.collection("all").snapshots(),
      builder: (context, snapshot) {
        return snapshot.data == null
            ? Container()
            : ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (ctx, i) {
                  var success = snapshot.data.documents[i];

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (c) => MotivationHome(
                                  "Success Stories", success.id)));
                    },
                    child: Padding(
                      padding: EdgeInsets.only(top: 0, left: 5, right: 5),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.blue[300],
                            borderRadius: BorderRadius.circular(20)),
                        child: Row(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 20, top: 30),
                                  child: Text(
                                    success["Title"],
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 5, left: 20, bottom: 10),
                                  child: SingleChildScrollView(
                                    child: Container(
                                      height: 90,
                                      width: MediaQuery.of(context).size.width -
                                          170,
                                      child: Text(
                                        success["sub"],
                                        style: GoogleFonts.poppins(
                                          height: 1.2,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width - 350,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 10.0, bottom: 5),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.32,
                                  height:
                                      MediaQuery.of(context).size.height * 0.17,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      image: DecorationImage(
                                          fit: BoxFit.fill,
                                          image: NetworkImage(
                                              success["lcation"]))),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                scrollDirection: Axis.vertical,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
              );
      });
}
