import 'dart:ui';

import 'package:SOAR/auth/record.dart';
import 'package:SOAR/screens/chat/chat_home.dart';
import 'package:SOAR/screens/post/post_image.dart';
import 'package:SOAR/screens/profile.dart';
import 'package:SOAR/screens/see_more.dart';
import 'package:SOAR/screens/settings_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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

  Future<void> _fetchUserinfoForSettingsPage() async {
    try {
      await Firestore.instance
          .collection("Users")
          .document(auth.currentUser.uid)
          .get()
          .then((value) {
        if (value.exists) {
          setState(() {
            dpurl = value.data()["dpurl"];
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(4278190106),
      body: ClipRRect(
        borderRadius: BorderRadius.circular(20),
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
                          Material(
                            type: MaterialType.transparency,
                            child: Text(
                              "Pitches",
                              style: GoogleFonts.poppins(
                                  color: Color(4278228470),
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            width: 18,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 13),
                            child: Container(
                              height: 40,
                              width: 110,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Color(4278228470),
                              ),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 10,
                                  ),
                                  FittedBox(
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => ChatScreen()));
                                      },
                                      child: Container(
                                        height: 35,
                                        width: 35,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color(4278190106),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 3,
                                              left: 3,
                                              bottom: 3,
                                              right: 3),
                                          child: Icon(
                                            Icons.notifications_none,
                                            color: Color(4278228470),
                                            size: 23,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  FittedBox(
                                    child: Container(
                                      height: 35,
                                      width: 35,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(4278190106),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(6.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        Movivation()));
                                          },
                                          child: Image.asset(
                                            "assets/idea.png",
                                            color: Color(4278228470),
                                            height: 19,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
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

                                return Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, right: 15, top: 20),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(26),
                                      child: Container(
                                          width: 340,
                                          color: Colors.white,
                                          child: Column(
                                            children: [
                                              Container(
                                                  height: 203,
                                                  decoration: BoxDecoration(
                                                    color: Color(4280099132),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  alignment: Alignment
                                                      .center, // where to p
                                                  child: Stack(
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                        child: GestureDetector(
                                                            onDoubleTap:
                                                                () async {
                                                              Firestore.instance
                                                                  .collection(
                                                                      'Feed')
                                                                  .document(course
                                                                      .documentID)
                                                                  .updateData({
                                                                "likes": FieldValue
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
                                                                "likes": FieldValue
                                                                    .increment(
                                                                        1)
                                                              });
                                                              setState(() {
                                                                isLiked = true;
                                                                getTimerWid();
                                                                likes = i
                                                                    .toString();

                                                                print("done");
                                                              });
                                                              print(i);
                                                            },
                                                            child: Hero(
                                                              tag: "dssd+$i",
                                                              child: Container(
                                                                height: 203,
                                                                width: 350,
                                                                decoration: BoxDecoration(
                                                                    image: DecorationImage(
                                                                        image: NetworkImage(course[
                                                                            "postimage"]),
                                                                        fit: BoxFit
                                                                            .fill)),
                                                              ),
                                                            )),
                                                      ),
                                                      if (likes == i.toString())
                                                        Fade(
                                                          visible: isLiked,
                                                          duration: Duration(
                                                              seconds: 1),
                                                          child: Container(
                                                            height: 203,
                                                            width: 350,
                                                            child: Center(
                                                              child: SizedBox(
                                                                  width: 80,
                                                                  height: 80,
                                                                  child: Lottie
                                                                      .asset(
                                                                    "assets/like.json",
                                                                    repeat:
                                                                        false,
                                                                  )),
                                                            ),
                                                          ),
                                                        ),
                                                      Container(
                                                        height: 203,
                                                        width: 350,
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 10,
                                                                  bottom: 13),
                                                          child: Align(
                                                            alignment: Alignment
                                                                .bottomLeft,
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  course["likes"]
                                                                      .toString(),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          40,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontFamily:
                                                                          "good",
                                                                      color: Colors
                                                                          .black),
                                                                ),
                                                                Text(
                                                                  course["title"
                                                                      .toString()],
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          40,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontFamily:
                                                                          "good",
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                                Text(
                                                                  course[
                                                                      "date"],
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Color(
                                                                          4278228470)),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder: (_) =>
                                                                    FeedDetails(
                                                                  documnetid: course
                                                                      .documentID,
                                                                ),
                                                              ));
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  bottom: 10,
                                                                  right: 10),
                                                          child: Align(
                                                            alignment: Alignment
                                                                .bottomRight,
                                                            child: Container(
                                                                width: 80,
                                                                height: 30,
                                                                decoration: BoxDecoration(
                                                                    color: Color(
                                                                        4278190106),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            20)),
                                                                child: Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    child: Text(
                                                                      "Proceed",
                                                                      style: GoogleFonts.poppins(
                                                                          fontSize:
                                                                              13,
                                                                          color: Color(
                                                                              4278228470),
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ))),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  )),
                                              SizedBox(height: 10),
                                              Container(
                                                child: SingleChildScrollView(
                                                  child: Column(
                                                    children: [
                                                      StreamBuilder(
                                                          stream: Firestore
                                                              .instance
                                                              .collection(
                                                                  "Feed")
                                                              .document(course
                                                                  .documentID
                                                                  .toString())
                                                              .collection(
                                                                  "comments")
                                                              .orderBy("date",
                                                                  descending:
                                                                      true)
                                                              .snapshots(),
                                                          builder:
                                                              (ctx, snapshot) {
                                                            print(dpurl);
                                                            return snapshot
                                                                        .data !=
                                                                    null
                                                                ? Column(
                                                                    children: [
                                                                      ListView.separated(
                                                                          separatorBuilder: (ctx, i) => SizedBox(height: 20),
                                                                          shrinkWrap: true,
                                                                          physics: NeverScrollableScrollPhysics(),
                                                                          itemCount: snapshot.data.documents.length < 1 ? snapshot.data.documents.length : 1,
                                                                          itemBuilder: (ctx, i) {
                                                                            DocumentSnapshot
                                                                                comment =
                                                                                snapshot.data.documents[i];
                                                                            return Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: Row(
                                                                                children: [
                                                                                  comment["dpurl"] == null
                                                                                      ? GestureDetector(
                                                                                          onTap: () {
                                                                                            Navigator.push(context, MaterialPageRoute(builder: (_) => Profile(uidforprofile: comment["uid"])));
                                                                                          },
                                                                                          child: Stack(
                                                                                            children: [
                                                                                              CircleAvatar(
                                                                                                backgroundImage: AssetImage(
                                                                                                  "assets/unknown.png",
                                                                                                ),
                                                                                                backgroundColor: Color(4278272638),
                                                                                                radius: 25,
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        )
                                                                                      : Stack(
                                                                                          children: [
                                                                                            GestureDetector(
                                                                                              onTap: () {
                                                                                                Navigator.push(context, MaterialPageRoute(builder: (_) => Profile(uidforprofile: comment["uid"])));
                                                                                              },
                                                                                              child: CircleAvatar(
                                                                                                backgroundImage: NetworkImage(comment["dpurl"]),
                                                                                                backgroundColor: Colors.white,
                                                                                                radius: 25,
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                  SizedBox(
                                                                                    width: 10,
                                                                                  ),
                                                                                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                                                    Text(
                                                                                      comment["name"],
                                                                                      style: TextStyle(fontWeight: FontWeight.bold),
                                                                                    ),
                                                                                    Text(comment["tagline"], style: TextStyle(color: Colors.black.withOpacity(0.7), fontFamily: "good", fontSize: 20)),
                                                                                    Text(comment["comment"]),
                                                                                  ]),
                                                                                ],
                                                                              ),
                                                                            );
                                                                          }),
                                                                      GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          Navigator.push(
                                                                              context,
                                                                              MaterialPageRoute(
                                                                                  builder: (_) => SeeMore(
                                                                                        seemore: course.documentID,
                                                                                      )));
                                                                        },
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              EdgeInsets.only(right: 20),
                                                                          child: Align(
                                                                              alignment: Alignment.bottomRight,
                                                                              child: Text("See More...", style: TextStyle(color: Colors.black.withOpacity(0.8), fontFamily: "good", fontSize: 20))),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            5,
                                                                      ),
                                                                    ],
                                                                  )
                                                                : Container();
                                                          })
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 15,
                                                            right: 8,
                                                            bottom: 10),
                                                    child: Form(
                                                        key: _key[i],
                                                        child: Container(
                                                            height: 35,
                                                            width: 270,
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                border: Border.all(
                                                                    width: 2,
                                                                    color: Color(
                                                                        4278228470))),
                                                            child:
                                                                TextFormField(
                                                              style: TextStyle(
                                                                color: Color(
                                                                    4278228470),
                                                              ),
                                                              controller:
                                                                  _controllers[
                                                                      i],
                                                              validator: (value) =>
                                                                  value.length ==
                                                                          0
                                                                      ? "Enter A Valid Text"
                                                                      : null,
                                                              decoration: InputDecoration(
                                                                  border:
                                                                      InputBorder
                                                                          .none,
                                                                  focusedBorder:
                                                                      InputBorder
                                                                          .none,
                                                                  enabledBorder:
                                                                      InputBorder
                                                                          .none,
                                                                  errorBorder:
                                                                      InputBorder
                                                                          .none,
                                                                  disabledBorder:
                                                                      InputBorder
                                                                          .none,
                                                                  contentPadding:
                                                                      EdgeInsets.only(
                                                                          left:
                                                                              5,
                                                                          right:
                                                                              5,
                                                                          bottom:
                                                                              15)),
                                                            ))),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                      bottom: 6,
                                                    ),
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        if (_key[i]
                                                            .currentState
                                                            .validate()) {
                                                          Firestore.instance
                                                              .collection(
                                                                  "Feed")
                                                              .document(course
                                                                  .documentID
                                                                  .toString())
                                                              .collection(
                                                                  "comments")
                                                              .add({
                                                            "comment":
                                                                _controllers[i]
                                                                    .text,
                                                            "uid": auth
                                                                .currentUser
                                                                .uid,
                                                            "date":
                                                                DateTime.now()
                                                                    .toString(),
                                                            "dpurl": dpurl,
                                                            "name": name,
                                                            "tagline": tagline
                                                          }).then((value) =>
                                                                  _controllers[
                                                                          i]
                                                                      .clear());
                                                        }
                                                      },
                                                      child: Container(
                                                        height: 30,
                                                        width: 30,
                                                        decoration:
                                                            BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color:
                                                              Color(4278190106),
                                                        ),
                                                        child: Icon(
                                                          Icons
                                                              .arrow_forward_rounded,
                                                          color:
                                                              Color(4278228470),
                                                          size: 25,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          )),
                                    ),
                                  ),
                                );
                              })
                          : Container();
                    }),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String likes;
}

FirebaseAuth auth = FirebaseAuth.instance;
String imageurl = auth.currentUser.photoURL.toString();
