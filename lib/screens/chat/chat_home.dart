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
import 'package:SOAR/screens/assist.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'text_screen.dart';

void main() => runApp(ChatScreen());

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with SingleTickerProviderStateMixin {
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

  bool isCollapsed = true;

  final Duration duration = const Duration(milliseconds: 300);
  AnimationController _controller;
  Animation<double> _scaleAnimation;
  Animation<double> _menuScaleAnimation;
  Animation<Offset> _slideAnimation;

  bool isDrawerOpen = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _usertype();
    fetchcurrentuserdetails();
    print(usertype);
    _controller = AnimationController(vsync: this, duration: duration);
    _scaleAnimation = Tween<double>(begin: 1, end: 0.8).animate(_controller);
    _menuScaleAnimation =
        Tween<double>(begin: 0.5, end: 1).animate(_controller);
    _slideAnimation = Tween<Offset>(begin: Offset(-1, 0), end: Offset(0, 0))
        .animate(_controller);
  }

  var queryResult = [];
  var tempResult = [];


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
                        ? Column(
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
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 190),
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
                                padding: const EdgeInsets.only(left: 190),
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
                          left: MediaQuery.of(context).size.width * 0.535),
                      child: Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: GestureDetector(
                          onTap: () {
                            _signOut();
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Icon(
                                Icons.exit_to_app_outlined,
                                color: Colors.redAccent,
                                size: 31,
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
                              scale: 17,
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
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);

    return usertype == "entrepreneur"
        ? Scaffold(
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
                      animationDuration: duration,
                      borderRadius: BorderRadius.circular(20),
                      elevation: 8,
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: isCollapsed
                              ? BorderRadius.circular(0)
                              : BorderRadius.circular(20),
                          color: Color(0xFFE6EDFA),
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 30, left: 15, right: 15),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                            colors: [
                                              Colors.blue[400],
                                              Colors.blue[700]
                                            ],
                                            style: GoogleFonts.poppins(
                                              fontSize: 35,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          )),
                                    ),
                                    isCollapsed
                                        ? Container(
                                            width: 0,
                                            height: 0,
                                          )
                                        : Container(
                                            width: 0,
                                            height: 0,
                                          ),
                                    Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                PageRouteBuilder(
                                                    transitionDuration:
                                                        Duration(
                                                            milliseconds: 500),
                                                    pageBuilder:
                                                        (ctx, ani, i) =>
                                                            VideoCon()));
                                          },
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            child: Icon(
                                              Icons.video_call,
                                              color: Colors.blue,
                                              size: 30,
                                            ),
                                          )),
                                    )
                                  ],
                                ),
                              ),
                              Hero(
                                tag: "key",
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => Search()));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 30, left: 10, right: 10),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          border: Border.all(
                                              color: Color(0xFF5894FA)),
                                          color: Color(0xFF5894FA)
                                              .withOpacity(0.4)),
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
                                                    fontWeight:
                                                        FontWeight.w500),
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
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: ListView.separated(
                                                  itemCount: snapshot
                                                      .data.documents.length,
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  shrinkWrap: true,
                                                  itemBuilder: (ctx, i) {
                                                    DocumentSnapshot course =
                                                        snapshot
                                                            .data.documents[i];

                                                    return StreamBuilder(
                                                      stream: Firestore.instance
                                                          .collection("Users")
                                                          .document(course[
                                                              "uid_entrepreneur"])
                                                          .snapshots(),
                                                      builder:
                                                          (BuildContext context,
                                                              AsyncSnapshot
                                                                  snapshot) {
                                                        var man = snapshot.data;
                                                        return snapshot.data !=
                                                                null
                                                            ? GestureDetector(
                                                                onTap: () {
                                                                  Navigator.push(
                                                                      context,
                                                                      PageRouteBuilder(
                                                                          transitionDuration: Duration(milliseconds: 500),
                                                                          pageBuilder: (ctx, ani, inde) => TextScreen(
                                                                                widgeti: i,
                                                                                id: course["uid_entrepreneur"],
                                                                                dpurl: man["location"],
                                                                                uid: course["uid"],
                                                                                name: man["name"],
                                                                              )));
                                                                },
                                                                child: Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          right:
                                                                              10,
                                                                          left:
                                                                              10),
                                                                  child:
                                                                      Container(
                                                                    padding: EdgeInsets.only(
                                                                        right:
                                                                            10,
                                                                        left:
                                                                            10),
                                                                    height: 100,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: Colors
                                                                          .white
                                                                          .withOpacity(
                                                                              0.27),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              20),
                                                                    ),
                                                                    child: Row(
                                                                      children: [
                                                                        Hero(
                                                                          tag:
                                                                              "good+$i",
                                                                          child:
                                                                              Container(
                                                                            height:
                                                                                80,
                                                                            width:
                                                                                80,
                                                                            decoration: BoxDecoration(
                                                                                borderRadius: BorderRadius.circular(15),
                                                                                color: Color(4278272638),
                                                                                image: man["location"] == null ? DecorationImage(image: AssetImage("assets/unknown.png"), fit: BoxFit.fill) : DecorationImage(image: NetworkImage(man["location"]), fit: BoxFit.fill)),
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              15,
                                                                        ),
                                                                        Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Container(
                                                                              height: 50,
                                                                              width: MediaQuery.of(context).size.width * .57,
                                                                              child: SingleChildScrollView(
                                                                                scrollDirection: Axis.horizontal,
                                                                                child: Padding(
                                                                                    padding: const EdgeInsets.only(
                                                                                      top: 16,
                                                                                    ),
                                                                                    child: Text(man["name"],
                                                                                        style: GoogleFonts.poppins(
                                                                                          fontWeight: FontWeight.bold,
                                                                                          fontSize: 25,
                                                                                          color: Colors.white,
                                                                                        ))),
                                                                              ),
                                                                            ),
                                                                            Text(
                                                                              man["tagline"],
                                                                              style: GoogleFonts.poppins(
                                                                                fontWeight: FontWeight.w400,
                                                                                fontSize: 15,
                                                                                color: Color(
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
                                                  separatorBuilder:
                                                      (context, i) {
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
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: ListView.separated(
                                                  itemCount: snapshot
                                                      .data.documents.length,
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  shrinkWrap: true,
                                                  itemBuilder: (ctx, i) {
                                                    DocumentSnapshot course =
                                                        snapshot
                                                            .data.documents[i];

                                                    return StreamBuilder(
                                                      stream: Firestore.instance
                                                          .collection("Users")
                                                          .document(course[
                                                              "investor_uid"])
                                                          .snapshots(),
                                                      builder:
                                                          (BuildContext context,
                                                              AsyncSnapshot
                                                                  snapshot) {
                                                        var cool =
                                                            snapshot.data;
                                                        return snapshot.data !=
                                                                null
                                                            ? Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        right:
                                                                            10,
                                                                        left:
                                                                            10),
                                                                child:
                                                                    Container(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          right:
                                                                              10,
                                                                          left:
                                                                              10),
                                                                  height: 100,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                        .white
                                                                        .withOpacity(
                                                                            0.27),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            20),
                                                                  ),
                                                                  child:
                                                                      GestureDetector(
                                                                    onTap: () {
                                                                      Navigator.push(
                                                                          context,
                                                                          PageRouteBuilder(
                                                                              transitionDuration: Duration(milliseconds: 500),
                                                                              pageBuilder: (ctx, ani, inde) => TextScreen(
                                                                                    widgeti: i,
                                                                                    id: auth.currentUser.uid,
                                                                                    uid: course["investor_uid"],
                                                                                    name: cool["name"],
                                                                                    dpurl: cool["location"],
                                                                                  )));
                                                                    },
                                                                    child: Row(
                                                                      children: [
                                                                        Material(
                                                                            borderRadius: BorderRadius.circular(
                                                                                15),
                                                                            elevation:
                                                                                20,
                                                                            child:
                                                                                Hero(
                                                                              tag: "good+$i",
                                                                              child: Container(
                                                                                height: 80,
                                                                                width: 80,
                                                                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Color(4278272638), image: cool["location"] == null ? DecorationImage(image: AssetImage("assets/unknown.png"), fit: BoxFit.fill) : DecorationImage(image: NetworkImage(cool["location"]), fit: BoxFit.fill)),
                                                                              ),
                                                                            )),
                                                                        SizedBox(
                                                                          width:
                                                                              15,
                                                                        ),
                                                                        Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Container(
                                                                              height: 56,
                                                                              width: MediaQuery.of(context).size.width * .50,
                                                                              child: SingleChildScrollView(
                                                                                scrollDirection: Axis.horizontal,
                                                                                child: Padding(
                                                                                    padding: const EdgeInsets.only(
                                                                                      top: 16,
                                                                                    ),
                                                                                    child: Text(cool["name"],
                                                                                        style: GoogleFonts.poppins(
                                                                                          fontWeight: FontWeight.bold,
                                                                                          fontSize: 25,
                                                                                          color: Colors.white,
                                                                                        ))),
                                                                              ),
                                                                            ),
                                                                            Text(
                                                                              cool["tagline"],
                                                                              style: GoogleFonts.poppins(
                                                                                fontWeight: FontWeight.w400,
                                                                                fontSize: 15,
                                                                                color: Color(
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
                                                  separatorBuilder:
                                                      (context, i) {
                                                    return SizedBox(
                                                      height: 20,
                                                    );
                                                  },
                                                ),
                                              )
                                            : Container();
                                      })
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        : Scaffold(
            backgroundColor: Color(0xFFE6EDFA),
            body: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Color(0xFFE6EDFA),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 30,
                            left: 15,
                          ),
                          child: Row(children: [
                            Icon(
                              Icons.group,
                              size: 40,
                              color: Colors.indigo,
                            ),
                            SizedBox(width: 10),
                            Align(
                                alignment: Alignment.topLeft,
                                child: GradientText(
                                  text: "Connections",
                                  colors: [Colors.indigo, Colors.blue],
                                  style: GoogleFonts.poppins(
                                    fontSize: 35,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )),
                          ]),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
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
                                              var man = snapshot.data;
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
                                                                      dpurl: man[
                                                                          "location"],
                                                                      uid: course[
                                                                          "uid"],
                                                                      name: man[
                                                                          "name"],
                                                                    )));
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 10,
                                                                left: 10),
                                                        child: Material(
                                                          elevation: 5,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          child: Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    right: 10,
                                                                    left: 10),
                                                            height: 80,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Colors
                                                                  .white
                                                                  .withOpacity(
                                                                      1),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20),
                                                            ),
                                                            child: Row(
                                                              children: [
                                                                Hero(
                                                                  tag:
                                                                      "good+$i",
                                                                  child:
                                                                      Container(
                                                                    height: 60,
                                                                    width: 60,
                                                                    decoration: BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                15),
                                                                        color: Color(
                                                                            4278272638),
                                                                        image: man["location"] ==
                                                                                null
                                                                            ? DecorationImage(
                                                                                image: AssetImage("assets/unknown.png"),
                                                                                fit: BoxFit.fill)
                                                                            : DecorationImage(image: NetworkImage(man["location"]), fit: BoxFit.fill)),
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
                                                                      height:
                                                                          50,
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
                                                                              top: 13,
                                                                            ),
                                                                            child: Text(man["name"],
                                                                                style: GoogleFonts.poppins(
                                                                                  fontWeight: FontWeight.bold,
                                                                                  fontSize: 20,
                                                                                  color: Color(0xFF333640),
                                                                                ))),
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      man["tagline"],
                                                                      style: GoogleFonts
                                                                          .poppins(
                                                                        height:
                                                                            0.7,
                                                                        fontWeight:
                                                                            FontWeight.w400,
                                                                        fontSize:
                                                                            15,
                                                                        color:
                                                                            Color(
                                                                          0xFF333640,
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
                                                          color: Colors.white
                                                              .withOpacity(
                                                                  0.27),
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
                                                              Material(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              15),
                                                                  elevation: 20,
                                                                  child: Hero(
                                                                    tag:
                                                                        "good+$i",
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          80,
                                                                      width: 80,
                                                                      decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(
                                                                              15),
                                                                          color: Color(
                                                                              4278272638),
                                                                          image: cool["location"] == null
                                                                              ? DecorationImage(image: AssetImage("assets/unknown.png"), fit: BoxFit.fill)
                                                                              : DecorationImage(image: NetworkImage(cool["location"]), fit: BoxFit.fill)),
                                                                    ),
                                                                  )),
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
                                                                                color: Colors.white,
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
                            })
                  ],
                ),
              ),
            ),
          );
  }
}

String connectionlenght;
