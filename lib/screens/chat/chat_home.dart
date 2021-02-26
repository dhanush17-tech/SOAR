import 'package:SOAR/screens/profile.dart';
import 'package:SOAR/screens/search_screen.dart';
import 'package:SOAR/screens/video_conferencing.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_gradient_text/easy_gradient_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:SOAR/screens/feed.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:SOAR/auth/login.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:SOAR/main_constraints.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'text_screen.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String usertype;

  Future<void> _usertype() async {
    try {
      await Firestore.instance
          .collection("Users")
          .document(auth.currentUser.uid)
          .get()
          .then((value) {
        if (value.exists) {
          setState(() {
            usertype = value.data()["usertype"];
          });
        }
      });
    } catch (e) {}
  }

  String dpurl;

  fetchcurrentuserdetails() {
    Firestore.instance
        .collection("Users")
        .document(auth.currentUser.uid)
        .get()
        .then((value) {
      setState(() {
        dpurl = value.data()["location"];
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _usertype();
    getman();

    fetchcurrentuserdetails();
    print(usertype);
  }

  var queryResult = [];
  var tempResult = [];

  Future loadpass() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool(
      "keys",
    );
  }

  getman() {
    loadpass().then((ca) {
      setState(() {
        man = ca;
      });
    });
  }

  bool man;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);

    return Scaffold(
        backgroundColor: man == false ? light_background : dark_background,
        body: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: man == false ? light_background : dark_background,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 30, left: 15, right: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 0,
                            ),
                            child: Align(
                                alignment: Alignment.topLeft,
                                child: GradientText(
                                  text: "Connections",
                                  colors: [Colors.blue, Colors.blueAccent],
                                  style: GoogleFonts.poppins(
                                    fontSize: 35,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )),
                          ),
                          Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => VideoCon()),
                                  );
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(top: 5, right: 0),
                                  child: Container(
                                    width: 35,
                                    height: 35,
                                    padding: EdgeInsets.only(
                                        top: 7, left: 8, bottom: 7, right: 6),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.indigo,
                                    ),
                                    child: Image.asset(
                                      "assets/video.png",
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              )),
                        ],
                      ),
                    ),
                    Hero(
                      tag: "key",
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) => Search()));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 30, left: 10, right: 10),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Color(0xFF5894FA)),
                                color: Color(0xFF5894FA).withOpacity(0.4)),
                            width: 350,
                            height: 60,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 20.0, right: 20, top: 2),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.search,
                                    size: 30,
                                    color: Color(4278228470),
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Material(
                                    type: MaterialType.transparency,
                                    child: Text(
                                      'Search',
                                      style: GoogleFonts.poppins(
                                          fontSize: 20,
                                          color: Color(
                                            4278228470,
                                          ),
                                          fontWeight: FontWeight.w500),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    usertype == "investor"
                        ? StreamBuilder(
                            stream: Firestore.instance
                                .collection("Users")
                                .document(auth.currentUser.uid)
                                .collection("following")
                                .snapshots(),
                            builder: (ctx, snapshot) {
                              return snapshot.data != null
                                  ? Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ListView.separated(
                                        itemCount:
                                            snapshot.data.documents.length,
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemBuilder: (ctx, i) {
                                          DocumentSnapshot course =
                                              snapshot.data.documents[i];

                                          return StreamBuilder(
                                            stream: Firestore.instance
                                                .collection("Users")
                                                .document(
                                                    course["uid_entrepreneur"])
                                                .snapshots(),
                                            builder: (BuildContext context,
                                                AsyncSnapshot snapshot) {
                                              var ed = snapshot.data;
                                              return snapshot.data != null
                                                  ? GestureDetector(
                                                      onTap: () {
                                                        Navigator.push(
                                                            context,
                                                            PageRouteBuilder(
                                                                transitionDuration:
                                                                    Duration(
                                                                        milliseconds:
                                                                            500),
                                                                pageBuilder: (ctx,
                                                                        ani,
                                                                        inde) =>
                                                                    TextScreen(
                                                                      widgeti:
                                                                          i,
                                                                      id: course[
                                                                          "uid_entrepreneur"],
                                                                      dpurl: ed[
                                                                          "location"],
                                                                      uid: course[
                                                                          "uid"],
                                                                      name: ed[
                                                                          "name"],
                                                                    )));
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 10,
                                                                left: 10),
                                                        child: Container(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  right: 10,
                                                                  left: 10),
                                                          height: 100,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.blue
                                                                .withOpacity(
                                                                    0.3),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                          ),
                                                          child: Row(
                                                            children: [
                                                              Hero(
                                                                tag: "good+$i",
                                                                child:
                                                                    Container(
                                                                  height: 80,
                                                                  width: 80,
                                                                  decoration: BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              15),
                                                                      color: man ==
                                                                              false
                                                                          ? image_background_light
                                                                          : image_background_dark,
                                                                      image: ed["location"] ==
                                                                              null
                                                                          ? DecorationImage(
                                                                              image: AssetImage(
                                                                                  "assets/unknown.png"),
                                                                              fit: BoxFit
                                                                                  .cover)
                                                                          : DecorationImage(
                                                                              image: NetworkImage(ed["location"]),
                                                                              fit: BoxFit.fill)),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 15,
                                                              ),
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Container(
                                                                    height: 50,
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        .57,
                                                                    child:
                                                                        SingleChildScrollView(
                                                                      scrollDirection:
                                                                          Axis.horizontal,
                                                                      child: Padding(
                                                                          padding: const EdgeInsets.only(
                                                                            top:
                                                                                16,
                                                                          ),
                                                                          child: Text(ed["name"],
                                                                              style: GoogleFonts.poppins(
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 25,
                                                                                color: man == false ? chat_name_light : chat_name_dark,
                                                                              ))),
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    ed["tagline"],
                                                                    style: GoogleFonts
                                                                        .poppins(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      fontSize:
                                                                          15,
                                                                      color:
                                                                          Color(
                                                                        4278228470,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  : Container();
                                            },
                                          );
                                        },
                                        separatorBuilder: (context, i) {
                                          return SizedBox(
                                            height: 20,
                                          );
                                        },
                                      ),
                                    )
                                  : Container();
                            })
                        : StreamBuilder(
                            stream: Firestore.instance
                                .collection("Users")
                                .document(auth.currentUser.uid)
                                .collection("followers")
                                .snapshots(),
                            builder: (ctx, snapshot) {
                              return snapshot.data != null
                                  ? Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ListView.separated(
                                        itemCount:
                                            snapshot.data.documents.length,
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemBuilder: (ctx, i) {
                                          DocumentSnapshot course =
                                              snapshot.data.documents[i];

                                          return StreamBuilder(
                                            stream: Firestore.instance
                                                .collection("Users")
                                                .document(
                                                    course["investor_uid"])
                                                .snapshots(),
                                            builder: (BuildContext context,
                                                AsyncSnapshot snapshot) {
                                              var cool = snapshot.data;
                                              return snapshot.data != null
                                                  ? Padding(
                                                      padding: EdgeInsets.only(
                                                          right: 10, left: 10),
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 10,
                                                                left: 10),
                                                        height: 100,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.blue
                                                              .withOpacity(0.3),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                        ),
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            Navigator.push(
                                                                context,
                                                                PageRouteBuilder(
                                                                    transitionDuration:
                                                                        Duration(
                                                                            milliseconds:
                                                                                500),
                                                                    pageBuilder: (ctx,
                                                                            ani,
                                                                            inde) =>
                                                                        TextScreen(
                                                                          widgeti:
                                                                              i,
                                                                          id: auth
                                                                              .currentUser
                                                                              .uid,
                                                                          uid: course[
                                                                              "investor_uid"],
                                                                          name:
                                                                              cool["name"],
                                                                          dpurl:
                                                                              cool["location"],
                                                                        )));
                                                          },
                                                          child: Row(
                                                            children: [
                                                              Hero(
                                                                tag: "good+$i",
                                                                child:
                                                                    Container(
                                                                  height: 80,
                                                                  width: 80,
                                                                  decoration: BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              15),
                                                                      color: man ==
                                                                              false
                                                                          ? image_background_light
                                                                          : image_background_dark,
                                                                      image: cool["location"] ==
                                                                              null
                                                                          ? DecorationImage(
                                                                              image: AssetImage(
                                                                                  "assets/unknown.png"),
                                                                              fit: BoxFit
                                                                                  .fill)
                                                                          : DecorationImage(
                                                                              image: NetworkImage(cool["location"]),
                                                                              fit: BoxFit.fill)),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 15,
                                                              ),
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Container(
                                                                    height: 56,
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        .50,
                                                                    child:
                                                                        SingleChildScrollView(
                                                                      scrollDirection:
                                                                          Axis.horizontal,
                                                                      child: Padding(
                                                                          padding: const EdgeInsets.only(
                                                                            top:
                                                                                16,
                                                                          ),
                                                                          child: Text(cool["name"],
                                                                              style: GoogleFonts.poppins(
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 25,
                                                                                color: man == false ? chat_name_light : chat_name_dark,
                                                                              ))),
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    cool[
                                                                        "tagline"],
                                                                    style: GoogleFonts
                                                                        .poppins(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      fontSize:
                                                                          15,
                                                                      color:
                                                                          Color(
                                                                        4278228470,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  : Container();
                                            },
                                          );
                                        },
                                        separatorBuilder: (context, i) {
                                          return SizedBox(
                                            height: 20,
                                          );
                                        },
                                      ),
                                    )
                                  : Container();
                            }),
                    SizedBox(
                      height: 100,
                    )
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}

String connectionlenght;
