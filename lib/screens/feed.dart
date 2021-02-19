import 'dart:ui';

import 'package:SOAR/auth/login.dart';
import 'package:SOAR/auth/record.dart';
import 'package:SOAR/screens/assist.dart';
import 'package:SOAR/screens/chat/chat_home.dart';
import 'package:SOAR/screens/post/post_image.dart';
import 'package:SOAR/screens/profile.dart';
import 'package:SOAR/screens/see_more.dart';
import 'package:SOAR/screens/stories.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_gradient_text/easy_gradient_text.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'feed_details.dart';
import 'package:fade/fade.dart';
import 'package:SOAR/main_constraints.dart';
import 'post/post_details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:SOAR/screens/search_users_Screen.dart';
import 'package:lottie/lottie.dart';
import 'package:timeago/timeago.dart ' as timeago;
import 'package:shimmer_animation/shimmer_animation.dart';

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
    getman();
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        shimmer_show = false;
      });
    });

    print(DateTime.now());
    setState(() {});
  }

  bool shimmer_show = true;
  @override
  void dispose() {
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

  bool isLiked = false;
  bool iswow = false;

  String id;
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
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness:
          Brightness.dark, // navigation bar color
      statusBarColor: Colors.transparent, // status bar color
    ));
    setState(() {});
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: man == false ? light_background : dark_background,
        body: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: <Widget>[
            SliverAppBar(
              stretch: false,
              expandedHeight: 70,
              pinned: false,
              backgroundColor:
                  man == false ? light_background : dark_background,
              title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (c) => UserSearch()));
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 0.0, right: 0),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: Color(0xFF5894FA)),
                              color: Color(0xFF5894FA).withOpacity(0.4)),
                          height: 50,
                          width: MediaQuery.of(context).size.width - 110,
                          child: Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Hero(
                                    tag: "mannn",
                                    child: Icon(Icons.search,
                                        size: 25, color: Color(0xFF5894FA)),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    child: Material(
                                        color: Colors.transparent,
                                        child: Text("Search ",
                                            style: GoogleFonts.poppins(
                                              fontSize: 20,
                                              color: Color(
                                                4278228470,
                                              ),
                                            ))),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 25,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => Stories()),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 5, right: 0),
                          child: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.indigo,
                            ),
                            child: Image.asset(
                              "assets/hot.png",
                              color: Colors.white,
                              scale: 7,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ]),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Padding(
                      padding: const EdgeInsets.only(top: 0),
                      child: StreamBuilder(
                          stream:
                              Firestore.instance.collection("Feed").snapshots(),
                          builder: (context, snapshot) {
                            return shimmer_show == false
                                ? ListView.separated(
                                    separatorBuilder: (ctx, i) =>
                                        SizedBox(height: 20),
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: snapshot.data.documents.length,
                                    itemBuilder: (ctx, i) {
                                      _controllers
                                          .add(new TextEditingController());
                                      _key.add(new GlobalKey<FormState>());
                                      DocumentSnapshot course =
                                          snapshot.data.documents[i];

                                      return snapshot.data == null
                                          ? Container()
                                          : Align(
                                              alignment: Alignment.center,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 15,
                                                    right: 15,
                                                    top: 0),
                                                child: Material(
                                                  elevation: 10,
                                                  color: Colors.transparent,
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                  shadowColor: Colors.black
                                                      .withOpacity(0.7),
                                                  child: Container(
                                                      decoration: BoxDecoration(
                                                        gradient: LinearGradient(
                                                            begin: Alignment
                                                                .topLeft,
                                                            end: Alignment
                                                                .bottomRight,
                                                            colors: [
                                                              Colors.white
                                                                  .withOpacity(
                                                                      1),
                                                              Colors.white
                                                                  .withOpacity(
                                                                      1),
                                                            ]),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                      ),
                                                      child: Stack(children: [
                                                        Material(
                                                          elevation: 3,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          child: Opacity(
                                                            opacity:
                                                                0.7, //Overall Background opacity
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                  gradient: LinearGradient(
                                                                      colors: [
                                                                        Color(0xFF4E82E8)
                                                                            .withOpacity(0.3), // Card gradients
                                                                        Color(0xFF5690F6)
                                                                            .withOpacity(0.7)
                                                                      ],
                                                                      begin: Alignment.topLeft, // Gradient scheme
                                                                      end: Alignment.bottomRight),
                                                                  borderRadius: BorderRadius.circular(20)),
                                                              child: Opacity(
                                                                opacity: 0.35,
                                                                child:
                                                                    ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20),
                                                                  child:
                                                                      ImageFiltered(
                                                                          imageFilter: ImageFilter.blur(
                                                                              sigmaX:
                                                                                  1,
                                                                              sigmaY:
                                                                                  1),
                                                                          child:
                                                                              Container(
                                                                            decoration:
                                                                                BoxDecoration(color: Colors.grey.shade200.withOpacity(0.5)),
                                                                            child:
                                                                                Opacity(
                                                                              opacity: 1,
                                                                              child: Container(
                                                                                  height: 370,
                                                                                  decoration: BoxDecoration(
                                                                                    image: DecorationImage(image: NetworkImage(course["postimage"]), fit: BoxFit.fill),
                                                                                  )),
                                                                            ),
                                                                          )),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Column(
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top: 0,
                                                                        left:
                                                                            10),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Container(
                                                                        child:
                                                                            Row(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        StreamBuilder(
                                                                            stream:
                                                                                Firestore.instance.collection("Users").document(course["uid"]).snapshots(),
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
                                                                                                  ? Padding(
                                                                                                      padding: EdgeInsets.only(top: 5, bottom: 5),
                                                                                                      child: Container(
                                                                                                        width: 50,
                                                                                                        height: 50,
                                                                                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), image: DecorationImage(image: NetworkImage(i.data["location"]), fit: BoxFit.fill)),
                                                                                                      ),
                                                                                                    )
                                                                                                  : Padding(
                                                                                                      padding: EdgeInsets.only(top: 5, bottom: 5),
                                                                                                      child: Container(
                                                                                                        width: 50,
                                                                                                        height: 50,
                                                                                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), image: DecorationImage(image: AssetImage("assets/unknown.png"), fit: BoxFit.fill)),
                                                                                                      ),
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
                                                                                                              top: 0,
                                                                                                            ),
                                                                                                            child: Text(
                                                                                                              i.data["name"],
                                                                                                              style: GoogleFonts.poppins(
                                                                                                                fontSize: 17,
                                                                                                                fontWeight: FontWeight.w600,
                                                                                                                color: Color(0xFF333640),
                                                                                                              ),
                                                                                                            )),
                                                                                                      ),
                                                                                                    ),
                                                                                                    Text(
                                                                                                      timeago.format(DateTime.parse(course["timeago"])),
                                                                                                      style: GoogleFonts.poppins(fontSize: 13, color: Color((0xFF333640)).withOpacity(0.8)),
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        ],
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      ),
                                                                                    );
                                                                            }),
                                                                      ],
                                                                    )),
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          top:
                                                                              5.0,
                                                                          right:
                                                                              8),
                                                                      child:
                                                                          Container(
                                                                        width:
                                                                            50,
                                                                        height:
                                                                            50,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          borderRadius:
                                                                              BorderRadius.circular(10),
                                                                          color: Colors
                                                                              .white
                                                                              .withOpacity(0.25),
                                                                        ),
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              const EdgeInsets.only(top: 5),
                                                                          child:
                                                                              Column(
                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets.only(top: 5),
                                                                                child: Text(
                                                                                  course["day"],
                                                                                  style: GoogleFonts.poppins(fontSize: 15, height: 1, fontWeight: FontWeight.w600, color: Color(0xFF333640)),
                                                                                ),
                                                                              ),
                                                                              SizedBox(
                                                                                height: 3,
                                                                              ),
                                                                              Text(
                                                                                course["month"],
                                                                                style: GoogleFonts.poppins(height: 1, fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF333640)),
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
                                                                height: 10,
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            10,
                                                                        right:
                                                                            10),
                                                                child: Stack(
                                                                  children: [
                                                                    Hero(
                                                                      tag:
                                                                          "dssd+$i",
                                                                      child:
                                                                          Container(
                                                                              height:
                                                                                  220,
                                                                              decoration:
                                                                                  BoxDecoration(
                                                                                      boxShadow: <BoxShadow>[
                                                                                    BoxShadow(color: Colors.black54, blurRadius: 15.0, offset: Offset(0.0, 0.75))
                                                                                  ],
                                                                                      borderRadius: BorderRadius.only(
                                                                                        topLeft: Radius.circular(5),
                                                                                        bottomRight: Radius.circular(5),
                                                                                        topRight: Radius.circular(20),
                                                                                        bottomLeft: Radius.circular(20),
                                                                                      ),
                                                                                      image: DecorationImage(image: NetworkImage(course["postimage"]), fit: BoxFit.cover)),
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
                                                                        child: wow ==
                                                                                i.toString()
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
                                                                height: 10,
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left: 3,
                                                                        right:
                                                                            3),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceEvenly,
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        GestureDetector(
                                                                            onTap:
                                                                                () async {
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
                                                                            child:
                                                                                Image.asset(
                                                                              "assets/heart.png",
                                                                              color: Color(4290118716),
                                                                              scale: 10,
                                                                            )),
                                                                        Text(
                                                                          "${course["likes"]}",
                                                                          style: GoogleFonts.poppins(
                                                                              fontWeight: FontWeight.bold,
                                                                              color: Color(0xFF333640).withOpacity(1)),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      width: 10,
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          right:
                                                                              0),
                                                                      child:
                                                                          GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          Firestore
                                                                              .instance
                                                                              .collection(
                                                                                  'Feed')
                                                                              .document(course
                                                                                  .documentID)
                                                                              .updateData({
                                                                            "wow":
                                                                                FieldValue.increment(1)
                                                                          });
                                                                          print(
                                                                              course["likes"]);
                                                                          Firestore
                                                                              .instance
                                                                              .collection(
                                                                                  "Users")
                                                                              .document(course[
                                                                                  "uid"])
                                                                              .collection(
                                                                                  "posts")
                                                                              .document(course
                                                                                  .documentID)
                                                                              .updateData({
                                                                            "wow":
                                                                                FieldValue.increment(1)
                                                                          });
                                                                          setState(
                                                                              () {
                                                                            iswow =
                                                                                true;
                                                                            getTimerWidforwow();
                                                                            wow =
                                                                                i.toString();

                                                                            print("done");
                                                                          });
                                                                          print(
                                                                              i);
                                                                        },
                                                                        child:
                                                                            Row(
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
                                                                              style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Color(0xFF333640).withOpacity(1)),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 4,
                                                                    ),
                                                                    IconButton(
                                                                        icon:
                                                                            Icon(
                                                                          Icons
                                                                              .message_outlined,
                                                                          color:
                                                                              Color(0xFF1438D0).withOpacity(0.8),
                                                                        ),
                                                                        onPressed:
                                                                            () {
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
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          left:
                                                                              0),
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
                                                                            alignment:
                                                                                Alignment.center,
                                                                            width:
                                                                                100,
                                                                            height:
                                                                                30,
                                                                            decoration: BoxDecoration(
                                                                                borderRadius: BorderRadius.circular(
                                                                                    8),
                                                                                gradient: LinearGradient(colors: [
                                                                                  Color(0xFF1438D0),
                                                                                  Colors.blue
                                                                                ])),
                                                                            child:
                                                                                Text(
                                                                              "Learn More",
                                                                              style: TextStyle(
                                                                                fontSize: 22,
                                                                                fontFamily: "good",
                                                                                fontWeight: FontWeight.w500,
                                                                                color: Colors.white,
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
                                              ),
                                            );
                                    })
                                : ListView.separated(
                                    shrinkWrap: true,
                                    itemCount: 10,
                                    separatorBuilder:
                                        (BuildContext context, int index) {
                                      return SizedBox(
                                        height: 10,
                                      );
                                    },
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15, right: 15, top: 0),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          child: Shimmer(
                                            duration: Duration(
                                                milliseconds:
                                                    1500), //Default value
                                            interval: Duration(
                                                milliseconds:
                                                    100), //Default value: Duration(seconds: 0)
                                            color: Colors.blue, //Default value
                                            enabled: true, //Default value
                                            direction: ShimmerDirection
                                                .fromLTRB(), //De
                                            child: Material(
                                              elevation: 5,
                                              color: Colors.transparent,
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              shadowColor:
                                                  Colors.white.withOpacity(0.7),
                                              child: Container(
                                                padding: EdgeInsets.all(20),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20)),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      top: 5,
                                                                      bottom:
                                                                          5),
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
                                                                          0.25),
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 10,
                                                            ),
                                                            Container(
                                                              height: 30,
                                                              width: 140,
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8),
                                                                  color: Colors
                                                                      .white
                                                                      .withOpacity(
                                                                          0.25)),
                                                            )
                                                          ],
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 5,
                                                                  bottom: 5),
                                                          child: Container(
                                                            width: 50,
                                                            height: 60,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              color: Colors
                                                                  .white
                                                                  .withOpacity(
                                                                      0.25),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Container(
                                                        height: 200,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white
                                                              .withOpacity(
                                                                  0.25),
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
                                                        )),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 5.0),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Container(
                                                              width: 150,
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
                                                                        0.25),
                                                              )),
                                                          Container(
                                                            width: 100,
                                                            height: 30,
                                                            decoration: BoxDecoration(
                                                                color: Colors
                                                                    .white
                                                                    .withOpacity(
                                                                        0.25),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            7)),
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                          })),
                  SizedBox(
                    height: 100,
                  )
                ],
              ),
            ),
          ],
        ));
  }

  String likes;
  String wow;
}

FirebaseAuth auth = FirebaseAuth.instance;
String imageurl = auth.currentUser.photoURL.toString();
