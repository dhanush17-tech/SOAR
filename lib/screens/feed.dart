import 'dart:ui';

import 'package:SOAR/auth/record.dart';
import 'package:SOAR/screens/chat/chat_home.dart';
import 'package:SOAR/screens/post/post_image.dart';
import 'package:SOAR/screens/profile.dart';
import 'package:SOAR/screens/see_more.dart';
import 'package:SOAR/screens/settings_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'feed_details.dart';
import 'package:fade/fade.dart';
import 'post/post_details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:lottie/lottie.dart';
import 'package:SOAR/screens/movivation.dart';

class Feed extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {});
    print(auth.currentUser.uid);
    _fetchUserinfoForSettingsPage();
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
        if (value.exists) {
          setState(() {
            dpurl = value.data()["location"];
            name = value.data()["name"];
            tagline = value.data()["tagline"];
          });
        }
      });
    } catch (e) {}
  }

  String name;
  String dpurl;
  String tagline;

  List<TextEditingController> _controllers = new List();
  List<GlobalKey<FormState>> _key = new List();

  bool isLiked = false;
  bool iswow = false;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);

    return Scaffold(
      backgroundColor: Color(4278190106),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/backpng.png"), fit: BoxFit.fill)),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, top: 40),
                  child: SingleChildScrollView(
                    child: Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Padding(
                                      padding: const EdgeInsets.only(
                                        top: 16,
                                      ),
                                      child: Text(name ?? "",
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 25,
                                            height: 0.5,
                                            color: Colors.white,
                                          ))),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                              padding: EdgeInsets.only(bottom: 50, right: 10),
                              child: Icon(
                                Icons.menu,
                                color: Colors.white,
                                size: 30,
                              )),
                        ],
                      ),
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
                      if (!snapshot.hasData) return Text('Loading... data');
                      return snapshot.data != null
                          ? ListView.separated(
                              separatorBuilder: (ctx, i) =>
                                  SizedBox(height: 20),
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: snapshot.data.documents.length,
                              itemBuilder: (ctx, i) {
                                _controllers.add(new TextEditingController());
                                _key.add(new GlobalKey<FormState>());
                                DocumentSnapshot course =
                                    snapshot.data.documents[i];

                                return snapshot.data == null
                                    ? Container()
                                    : Align(
                                        alignment: Alignment.center,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 15, right: 15, top: 20),
                                          child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white
                                                    .withOpacity(0.27),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Stack(children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                top: 1,
                                                                left: 10),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Container(
                                                                child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                StreamBuilder(
                                                                    stream: Firestore
                                                                        .instance
                                                                        .collection(
                                                                            "Users")
                                                                        .document(course[
                                                                            "uid"])
                                                                        .snapshots(),
                                                                    builder:
                                                                        (ctx,
                                                                            i) {
                                                                      return i.data ==
                                                                              null
                                                                          ? Container()
                                                                          : Row(
                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                              children: [
                                                                                i.data["location"] != null
                                                                                    ? Container(
                                                                                        width: 45,
                                                                                        height: 45,
                                                                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), image: DecorationImage(image: NetworkImage(i.data["location"]), fit: BoxFit.fill)),
                                                                                      )
                                                                                    : Container(
                                                                                        width: 45,
                                                                                        height: 45,
                                                                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), image: DecorationImage(image: AssetImage("assets/unknown.png"), fit: BoxFit.fill)),
                                                                                      ),
                                                                                SizedBox(
                                                                                  width: 10,
                                                                                ),
                                                                                Padding(
                                                                                  padding: const EdgeInsets.only(bottom: 10),
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
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            );
                                                                    }),
                                                              ],
                                                            )),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Container(
                                                                width: 50,
                                                                height: 50,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                  color: Colors
                                                                      .white
                                                                      .withOpacity(
                                                                          0.8),
                                                                ),
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      top: 5),
                                                                  child: Column(
                                                                    children: [
                                                                      Padding(
                                                                        padding:
                                                                            const EdgeInsets.only(top: 5),
                                                                        child:
                                                                            Text(
                                                                          course[
                                                                              "day"],
                                                                          style: GoogleFonts.poppins(
                                                                              fontSize: 15,
                                                                              height: 1,
                                                                              fontWeight: FontWeight.w600,
                                                                              color: Color(4278228470)),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            3,
                                                                      ),
                                                                      Text(
                                                                        course[
                                                                            "month"],
                                                                        style: GoogleFonts.poppins(
                                                                            height:
                                                                                1,
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                            color: Color(4278190106)),
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
                                                        height: 1,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 10,
                                                                right: 10),
                                                        child: Material(
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    5),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    5),
                                                            topRight:
                                                                Radius.circular(
                                                                    20),
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    20),
                                                          ),
                                                          elevation: 3,
                                                          child: Stack(
                                                            children: [
                                                              GestureDetector(
                                                                onDoubleTap:
                                                                    () async {
                                                                  Firestore
                                                                      .instance
                                                                      .collection(
                                                                          'Feed')
                                                                      .document(
                                                                          course
                                                                              .documentID)
                                                                      .updateData({
                                                                    "likes": FieldValue
                                                                        .increment(
                                                                            1)
                                                                  });
                                                                  print(course[
                                                                      "likes"]);
                                                                  Firestore
                                                                      .instance
                                                                      .collection(
                                                                          "Users")
                                                                      .document(
                                                                          course[
                                                                              "uid"])
                                                                      .collection(
                                                                          "posts")
                                                                      .document(
                                                                          course
                                                                              .documentID)
                                                                      .updateData({
                                                                    "likes": FieldValue
                                                                        .increment(
                                                                            1)
                                                                  });
                                                                  setState(() {
                                                                    isLiked =
                                                                        true;
                                                                    getTimerWid();
                                                                    likes = i
                                                                        .toString();

                                                                    print(
                                                                        "done");
                                                                  });
                                                                  print(i);
                                                                },
                                                                child: Hero(
                                                                  tag:
                                                                      "dssd+$i",
                                                                  child: Container(
                                                                      height: 170,
                                                                      decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.only(
                                                                            topLeft:
                                                                                Radius.circular(5),
                                                                            bottomRight:
                                                                                Radius.circular(5),
                                                                            topRight:
                                                                                Radius.circular(20),
                                                                            bottomLeft:
                                                                                Radius.circular(20),
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
                                                              ),
                                                              Container(
                                                                  child: wow ==
                                                                          i.toString()
                                                                      ? Container(
                                                                          child:
                                                                              Fade(
                                                                            visible:
                                                                                iswow,
                                                                            duration:
                                                                                Duration(milliseconds: 500),
                                                                            child:
                                                                                Container(
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
                                                                        )
                                                                      : Container())
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Image.asset(
                                                                "assets/heart.png",
                                                                color: Color(
                                                                    4290118716),
                                                                scale: 10,
                                                              ),
                                                              Text(
                                                                "${course["likes"]}",
                                                                style: GoogleFonts.poppins(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .white
                                                                        .withOpacity(
                                                                            1)),
                                                              ),
                                                            ],
                                                          ),
                                                          GestureDetector(
                                                            onTap: () {
                                                              Firestore.instance
                                                                  .collection(
                                                                      'Feed')
                                                                  .document(course
                                                                      .documentID)
                                                                  .updateData({
                                                                "wow": FieldValue
                                                                    .increment(
                                                                        1)
                                                              });
                                                              print(course[
                                                                  "likes"]);
                                                              Firestore.instance
                                                                  .collection(
                                                                      "Users")
                                                                  .document(
                                                                      course[
                                                                          "uid"])
                                                                  .collection(
                                                                      "posts")
                                                                  .document(course
                                                                      .documentID)
                                                                  .updateData({
                                                                "wow": FieldValue
                                                                    .increment(
                                                                        1)
                                                              });
                                                              setState(() {
                                                                iswow = true;
                                                                getTimerWidforwow();
                                                                wow = i
                                                                    .toString();

                                                                print("done");
                                                              });
                                                              print(i);
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
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .white
                                                                          .withOpacity(
                                                                              1)),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 50,
                                                          ),
                                                          GestureDetector(
                                                              onTap: () {
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder:
                                                                          (_) =>
                                                                              FeedDetails(
                                                                        documnetid:
                                                                            course.documentID,
                                                                      ),
                                                                    ));
                                                              },
                                                              child: Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                width: 100,
                                                                height: 30,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8),
                                                                  color: Colors
                                                                      .white
                                                                      .withOpacity(
                                                                          0.8),
                                                                ),
                                                                child: Text(
                                                                  "Learn More",
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        22,
                                                                    fontFamily:
                                                                        "good",
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w300,
                                                                    color: Colors
                                                                        .blue,
                                                                  ),
                                                                ),
                                                              ))
                                                        ],
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
    );
  }

  String likes;
  String wow;
}

FirebaseAuth auth = FirebaseAuth.instance;
String imageurl = auth.currentUser.photoURL.toString();
