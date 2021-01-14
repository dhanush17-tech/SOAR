import 'dart:ui';

import 'package:SOAR/auth/login.dart';
import 'package:SOAR/auth/record.dart';
import 'package:SOAR/screens/assist.dart';
import 'package:SOAR/screens/chat/chat_home.dart';
import 'package:SOAR/screens/post/post_image.dart';
import 'package:SOAR/screens/profile.dart';
import 'package:SOAR/screens/see_more.dart';
import 'package:SOAR/motivation_scrren/motivation_home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'feed_details.dart';
import 'package:fade/fade.dart';
import 'post/post_details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:lottie/lottie.dart';
import 'package:timeago/timeago.dart' as timeago;

class Feed extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {});
    print(auth.currentUser.uid);
    _fetchUserinfoForSettingsPage();
    _controller = AnimationController(vsync: this, duration: duration);
    _scaleAnimation = Tween<double>(begin: 1, end: 0.8).animate(_controller);
    _menuScaleAnimation =
        Tween<double>(begin: 0.5, end: 1).animate(_controller);
    _slideAnimation = Tween<Offset>(begin: Offset(-1, 0), end: Offset(0, 0))
        .animate(_controller);
    print(DateTime.now());
  }

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
    prefs.remove("useremail");
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  DateTime time = DateTime.now();

  Timer getTimerWid() {
    return Timer(Duration(seconds: 2), () {
      setState(() {
        isLiked = false;
      });
    });
  }

  Timer getTimerWidforwow() {
    return Timer(Duration(seconds: 2), () {
      setState(() {
        iswow = false;
      });
    });
  }

  Future<void> _fetchUserinfoForSettingsPage() async {
    try {
      await Firestore.instance
          .collection("Users")
          .document(auth.currentUser.uid)
          .get()
          .then((value) {
        setState(() {
          dpurl = value.data()["location"];
          name = value.data()["name"];
          tagline = value.data()["tagline"];
        });
      });
    } catch (e) {}
  }

  String name;
  String dpurl =
      "https://www.macmillandictionary.com/external/slideshow/thumb/White_thumb.png";
  String tagline;

  List<TextEditingController> _controllers = new List();
  List<GlobalKey<FormState>> _key = new List();
  List isdusablelike = List();
  List isdisablewow = List();

  bool isCollapsed = true;

  final Duration duration = const Duration(milliseconds: 300);
  AnimationController _controller;
  Animation<double> _scaleAnimation;
  Animation<double> _menuScaleAnimation;
  Animation<Offset> _slideAnimation;

  bool isDrawerOpen = false;

  bool isLiked = false;
  bool iswow = false;

  String id;

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
                    SizedBox(
                      height: 50,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.55),
                      child: Padding(
                        padding: EdgeInsets.only(left: 0),
                        child: GestureDetector(
                          onTap: () {
                            _signOut();
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.exit_to_app_outlined,
                                color: Colors.redAccent,
                                size: 35,
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Text(
                                "Sign Out",
                                style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.red),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.569,
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
                              scale: 15,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Text(
                              "Support",
                              style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            )
                          ],
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
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(4278716491),
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
                  animationDuration: duration,
                  borderRadius: BorderRadius.circular(20),
                  elevation: 8,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: isCollapsed
                          ? BorderRadius.circular(0)
                          : BorderRadius.circular(20),
                      color: Color(4278190106),
                    ),
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10, top: 40),
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
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.8,
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 16,
                                                ),
                                                child: Text(name ?? "",
                                                    style: GoogleFonts.poppins(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 25,
                                                      height: 0.5,
                                                      color: Colors.white,
                                                    ))),
                                          ),
                                        ),
                                      ],
                                    ),
                                    isCollapsed
                                        ? Padding(
                                            padding: EdgeInsets.only(
                                                bottom: 50, right: 0),
                                            child: IconButton(
                                              icon: Icon(
                                                Icons.menu,
                                                size: 30,
                                                color: Colors.white,
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
                                        : Padding(
                                            padding: EdgeInsets.only(
                                                bottom: 50, right: 0),
                                            child: IconButton(
                                              icon: Icon(
                                                Icons.arrow_back_ios,
                                                color: Colors.white,
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
                                            )),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: StreamBuilder(
                                stream: Firestore.instance
                                    .collection("Feed")
                                    .orderBy("date", descending: true)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData)
                                    return Text('Loading... data');
                                  return snapshot.data != null
                                      ? ListView.separated(
                                          separatorBuilder: (ctx, i) =>
                                              SizedBox(height: 20),
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemCount:
                                              snapshot.data.documents.length,
                                          itemBuilder: (ctx, i) {
                                            _controllers.add(
                                                new TextEditingController());
                                            _key.add(
                                                new GlobalKey<FormState>());
                                            DocumentSnapshot course =
                                                snapshot.data.documents[i];

                                            return snapshot.data == null
                                                ? Container()
                                                : Align(
                                                    alignment: Alignment.center,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 15,
                                                              right: 15,
                                                              top: 0),
                                                      child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            gradient: LinearGradient(
                                                                colors: [
                                                                  Color(
                                                                      4278328185).withOpacity(0.4),
                                                                  Color(
                                                                      4278547942).withOpacity(0.4),
                                                                  Color(
                                                                      4280311451).withOpacity(0.5)
                                                                ],
                                                                begin: Alignment
                                                                    .topLeft,
                                                                end: Alignment
                                                                    .bottomRight),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                          ),
                                                          child: Stack(
                                                              children: [
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          8.0),
                                                                  child: Column(
                                                                    children: [
                                                                      Padding(
                                                                        padding: const EdgeInsets.only(
                                                                            top:
                                                                                0,
                                                                            left:
                                                                                10),
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Container(
                                                                                child: Row(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                StreamBuilder(
                                                                                    stream: Firestore.instance.collection("Users").document(course["uid"]).snapshots(),
                                                                                    builder: (ctx, i) {
                                                                                      return i.data == null
                                                                                          ? Container()
                                                                                          : GestureDetector(
                                                                                              onTap: () {
                                                                                                Navigator.push(
                                                                                                    context,
                                                                                                    MaterialPageRoute(
                                                                                                        builder: (_) => Profile(
                                                                                                              uidforprofile: i.data["uid"],
                                                                                                            )));
                                                                                              },
                                                                                              child: Column(
                                                                                                children: [
                                                                                                  Row(
                                                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                                                    children: [
                                                                                                      i.data["location"] != null
                                                                                                          ? Container(
                                                                                                              width: 50,
                                                                                                              height: 50,
                                                                                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), image: DecorationImage(image: NetworkImage(i.data["location"]), fit: BoxFit.fill)),
                                                                                                            )
                                                                                                          : Container(
                                                                                                              width: 50,
                                                                                                              height: 50,
                                                                                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), image: DecorationImage(image: AssetImage("assets/unknown.png"), fit: BoxFit.fill)),
                                                                                                            ),
                                                                                                      SizedBox(
                                                                                                        width: 10,
                                                                                                      ),
                                                                                                      Padding(
                                                                                                        padding: const EdgeInsets.only(bottom: 0),
                                                                                                        child: Column(
                                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                                                          children: [
                                                                                                            Container(
                                                                                                              width: MediaQuery.of(context).size.width * 0.50,
                                                                                                              child: SingleChildScrollView(
                                                                                                                scrollDirection: Axis.horizontal,
                                                                                                                child: Padding(
                                                                                                                    padding: const EdgeInsets.only(
                                                                                                                      top: 16,
                                                                                                                    ),
                                                                                                                    child: Text(
                                                                                                                      i.data["name"],
                                                                                                                      style: GoogleFonts.poppins(
                                                                                                                        fontSize: 17,
                                                                                                                        fontWeight: FontWeight.w600,
                                                                                                                        color: Colors.white,
                                                                                                                      ),
                                                                                                                    )),
                                                                                                              ),
                                                                                                            ),
                                                                                                            Text(
                                                                                                              i.data["tagline"],
                                                                                                              style: GoogleFonts.poppins(fontSize: 13, color: Colors.white.withOpacity(0.6)),
                                                                                                            ),
                                                                                                          ],
                                                                                                        ),
                                                                                                      ),
                                                                                                    ],
                                                                                                  ),
                                                                                                  Text(
                                                                                                    timeago.format(DateTime.parse(course["timeago"])),
                                                                                                    style: TextStyle(
                                                                                                      fontSize: 25,
                                                                                                      color: Colors.grey.withOpacity(0.5),
                                                                                                      fontFamily: "good",
                                                                                                    ),
                                                                                                  )
                                                                                                ],
                                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                              ),
                                                                                            );
                                                                                    }),
                                                                              ],
                                                                            )),
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(top: 11.0, right: 8),
                                                                              child: Container(
                                                                                width: 50,
                                                                                height: 50,
                                                                                decoration: BoxDecoration(
                                                                                  borderRadius: BorderRadius.circular(10),
                                                                                  color: Colors.white.withOpacity(0.9),
                                                                                ),
                                                                                child: Padding(
                                                                                  padding: const EdgeInsets.only(top: 5),
                                                                                  child: Column(
                                                                                    children: [
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.only(top: 5),
                                                                                        child: Text(
                                                                                          course["day"],
                                                                                          style: GoogleFonts.poppins(fontSize: 15, height: 1, fontWeight: FontWeight.w600, color: Color(4278228470)),
                                                                                        ),
                                                                                      ),
                                                                                      SizedBox(
                                                                                        height: 3,
                                                                                      ),
                                                                                      Text(
                                                                                        course["month"],
                                                                                        style: GoogleFonts.poppins(height: 1, fontSize: 15, fontWeight: FontWeight.w600, color: Color(4278190106)),
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            10,
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsets.only(
                                                                            left:
                                                                                10,
                                                                            right:
                                                                                10),
                                                                        child:
                                                                            Stack(
                                                                          children: [
                                                                            Hero(
                                                                              tag: "dssd+$i",
                                                                              child: Container(
                                                                                  height: 170,
                                                                                  decoration: BoxDecoration(
                                                                                      boxShadow: <BoxShadow>[BoxShadow(color: Colors.black54, blurRadius: 15.0, offset: Offset(0.0, 0.75))],
                                                                                      borderRadius: BorderRadius.only(
                                                                                        topLeft: Radius.circular(5),
                                                                                        bottomRight: Radius.circular(5),
                                                                                        topRight: Radius.circular(20),
                                                                                        bottomLeft: Radius.circular(20),
                                                                                      ),
                                                                                      image: DecorationImage(image: NetworkImage(course["postimage"]), fit: BoxFit.fill)),
                                                                                  child: likes == i.toString()
                                                                                      ? Container(
                                                                                          child: Fade(
                                                                                            visible: isLiked,
                                                                                            duration: Duration(milliseconds: 500),
                                                                                            child: Container(
                                                                                              height: 203,
                                                                                              width: 350,
                                                                                              child: Center(
                                                                                                child: SizedBox(
                                                                                                    width: 100,
                                                                                                    height: 100,
                                                                                                    child: Lottie.asset(
                                                                                                      "assets/like.json",
                                                                                                      repeat: false,
                                                                                                    )),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        )
                                                                                      : Container()),
                                                                            ),
                                                                            Container(
                                                                                child: wow == i.toString()
                                                                                    ? Container(
                                                                                        child: Fade(
                                                                                          visible: iswow,
                                                                                          duration: Duration(milliseconds: 500),
                                                                                          child: Padding(
                                                                                            padding: const EdgeInsets.only(top: 30),
                                                                                            child: Container(
                                                                                              width: 350,
                                                                                              child: Center(
                                                                                                  child: SizedBox(
                                                                                                      width: 100,
                                                                                                      height: 100,
                                                                                                      child: Lottie.asset(
                                                                                                        "assets/wow.json",
                                                                                                        repeat: true,
                                                                                                      ))),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      )
                                                                                    : Container())
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            10,
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsets.only(
                                                                            left:
                                                                                3,
                                                                            right:
                                                                                3),
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceEvenly,
                                                                          children: [
                                                                            isdusablelike.contains(i) == false
                                                                                ? Row(
                                                                                    children: [
                                                                                      GestureDetector(
                                                                                          onTap: () async {
                                                                                            setState(() {
                                                                                              isdusablelike.add(i);
                                                                                            });
                                                                                            Firestore.instance.collection('Feed').document(course.documentID).updateData({
                                                                                              "likes": FieldValue.increment(1)
                                                                                            });
                                                                                            print(course["likes"]);
                                                                                            Firestore.instance.collection("Users").document(course["uid"]).collection("posts").document(course.documentID).updateData({
                                                                                              "likes": FieldValue.increment(1)
                                                                                            });
                                                                                            setState(() {
                                                                                              isLiked = true;
                                                                                              getTimerWid();
                                                                                              likes = i.toString();

                                                                                              print("done");
                                                                                            });
                                                                                            print(i);
                                                                                          },
                                                                                          child: Image.asset(
                                                                                            "assets/heart.png",
                                                                                            color: Color(4290118716),
                                                                                            scale: 10,
                                                                                          )),
                                                                                      Text(
                                                                                        "${course["likes"]}",
                                                                                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white.withOpacity(1)),
                                                                                      ),
                                                                                    ],
                                                                                  )
                                                                                : Row(
                                                                                    children: [
                                                                                      GestureDetector(
                                                                                          onTap: () async {
                                                                                            setState(() {
                                                                                              isdusablelike.removeAt(i);
                                                                                            });
                                                                                            Firestore.instance.collection('Feed').document(course.documentID).updateData({
                                                                                              "likes": FieldValue.increment(-1)
                                                                                            });
                                                                                            print(course["likes"]);
                                                                                            Firestore.instance.collection("Users").document(course["uid"]).collection("posts").document(course.documentID).updateData({
                                                                                              "likes": FieldValue.increment(-1)
                                                                                            });

                                                                                            print(i);
                                                                                          },
                                                                                          child: Image.asset("assets/heartout.png", color: Color(4290118716), scale: 8)),
                                                                                      Text(
                                                                                        "${course["likes"]}",
                                                                                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white.withOpacity(1)),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                            SizedBox(
                                                                              width: 10,
                                                                            ),
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(right: 0),
                                                                              child: GestureDetector(
                                                                                onTap: isdisablewow.contains(i) == false
                                                                                    ? () {
                                                                                        Firestore.instance.collection('Feed').document(course.documentID).updateData({
                                                                                          "wow": FieldValue.increment(1)
                                                                                        });
                                                                                        print(course["likes"]);
                                                                                        Firestore.instance.collection("Users").document(course["uid"]).collection("posts").document(course.documentID).updateData({
                                                                                          "wow": FieldValue.increment(1)
                                                                                        });
                                                                                        setState(() {
                                                                                          iswow = true;
                                                                                          getTimerWidforwow();
                                                                                          wow = i.toString();
                                                                                          setState(() {
                                                                                            isdisablewow.add(i);
                                                                                          });
                                                                                          print("done");
                                                                                        });
                                                                                        print(i);
                                                                                      }
                                                                                    : () {
                                                                                        setState(() {
                                                                                          isdisablewow.removeAt(i);
                                                                                        });
                                                                                        Firestore.instance.collection('Feed').document(course.documentID).updateData({
                                                                                          "wow": FieldValue.increment(-1)
                                                                                        });
                                                                                        print(course["likes"]);
                                                                                        Firestore.instance.collection("Users").document(course["uid"]).collection("posts").document(course.documentID).updateData({
                                                                                          "wow": FieldValue.increment(-1)
                                                                                        });
                                                                                      },
                                                                                child: Row(
                                                                                  children: [
                                                                                    Image.asset(
                                                                                      "assets/wow.png",
                                                                                      width: 20,
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width: 5,
                                                                                    ),
                                                                                    Text(
                                                                                      "${course["wow"]}",
                                                                                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white.withOpacity(1)),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              width: 4,
                                                                            ),
                                                                            IconButton(
                                                                                icon: Icon(
                                                                                  Icons.message_outlined,
                                                                                  color: Color(4278228470).withOpacity(0.8),
                                                                                ),
                                                                                onPressed: () {
                                                                                  Navigator.push(
                                                                                      context,
                                                                                      MaterialPageRoute(
                                                                                          builder: (_) => SeeMore(
                                                                                                seemore: course.id,
                                                                                              )));
                                                                                }),
                                                                            SizedBox(
                                                                              width: 50,
                                                                            ),
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(left: 0),
                                                                              child: GestureDetector(
                                                                                  onTap: () {
                                                                                    Navigator.push(
                                                                                        context,
                                                                                        MaterialPageRoute(
                                                                                          builder: (_) => FeedDetails(
                                                                                            documnetid: course.documentID,
                                                                                            url: course["video_url"],
                                                                                          ),
                                                                                        ));
                                                                                  },
                                                                                  child: Container(
                                                                                    alignment: Alignment.center,
                                                                                    width: 100,
                                                                                    height: 30,
                                                                                    decoration: BoxDecoration(
                                                                                      borderRadius: BorderRadius.circular(8),
                                                                                      color: Colors.white.withOpacity(0.8),
                                                                                    ),
                                                                                    child: Text(
                                                                                      "Learn More",
                                                                                      style: TextStyle(
                                                                                        fontSize: 22,
                                                                                        fontFamily: "good",
                                                                                        fontWeight: FontWeight.w300,
                                                                                        color: Colors.blue,
                                                                                      ),
                                                                                    ),
                                                                                  )),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                )
                                                              ])),
                                                    ),
                                                  );
                                          })
                                      : Container();
                                }),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ))
        ],
      ),
    );
  }

  String likes;
  String wow;
}

FirebaseAuth auth = FirebaseAuth.instance;
String imageurl = auth.currentUser.photoURL.toString();
