import 'package:SOAR/screens/profile.dart';
import 'package:SOAR/screens/search_screen.dart';
import 'package:SOAR/services/search_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'package:easy_gradient_text/easy_gradient_text.dart';


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

  initateSearch(value) {
    if (value.length == 0) {
      setState(() {
        queryResult = [];
        tempResult = [];
      });
    }
    var capitalizedLetter =
        value.substring(0, 1).toUpperCase() + value.substring(1);

    if (queryResult.length == 0 && value.length == 1) {
      SearchIndex().serachByName(value).then((QuerySnapshot docs) {
        for (int i = 0; i < docs.documents.length; i++) {
          queryResult.add(docs.documents[i].data);
        }
      });
    } else
      (tempResult = []);
    queryResult.forEach((element) {
      if (element["name"].startsWith(capitalizedLetter)) {
        setState(() {
          tempResult.add(element);
        });
      }
    });
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
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);

    return usertype == "entrepreneur"
        ? Scaffold(
            backgroundColor: Color(4280032553),
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
                          color: Color(4278190106),
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
                                      padding: const EdgeInsets.only(top: 7.0),
                                      child: Align(
                                        alignment: Alignment.topRight,
                                        child: Container(
                                            child: StreamBuilder(
                                          stream: Firestore.instance
                                              .collection("Users")
                                              .document(auth.currentUser.uid)
                                              .snapshots(),
                                          builder: (BuildContext context,
                                              AsyncSnapshot snapshot) {
                                            return snapshot.data != null
                                                ? snapshot.data["location"] !=
                                                        null
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
                                                                          i) =>
                                                                      Profile(
                                                                        uidforprofile: auth
                                                                            .currentUser
                                                                            .uid,
                                                                      )));
                                                        },
                                                        child: CircleAvatar(
                                                          backgroundImage:
                                                              NetworkImage(
                                                                  snapshot.data[
                                                                      "location"]),
                                                          backgroundColor:
                                                              Color(4278272638),
                                                          radius: 25,
                                                        ),
                                                      )
                                                    : GestureDetector(
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
                                                                          i) =>
                                                                      Profile(
                                                                        uidforprofile: auth
                                                                            .currentUser
                                                                            .uid,
                                                                      )));
                                                        },
                                                        child: CircleAvatar(
                                                          backgroundImage:
                                                              AssetImage(
                                                                  "assets/unknown.png"),
                                                          backgroundColor:
                                                              Color(4278272638),
                                                          radius: 25,
                                                        ),
                                                      )
                                                : GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          PageRouteBuilder(
                                                              transitionDuration:
                                                                  Duration(
                                                                      milliseconds:
                                                                          500),
                                                              pageBuilder: (ctx,
                                                                      ani, i) =>
                                                                  Profile(
                                                                    uidforprofile: auth
                                                                        .currentUser
                                                                        .uid,
                                                                  )));
                                                    },
                                                    child: CircleAvatar(
                                                      backgroundImage: AssetImage(
                                                          "assets/unknown.png"),
                                                      backgroundColor:
                                                          Color(4278272638),
                                                      radius: 20,
                                                    ),
                                                  );
                                          },
                                        )),
                                      ),
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
                                                bottom: 0, right: 0),
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
                              usertype == "entrepreneur"
                                  ? Padding(
                                      padding: const EdgeInsets.only(left: 30),
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          'Talk to \nyour investor',
                                          style: GoogleFonts.poppins(
                                              color: Colors.white,
                                              height: 1.2,
                                              fontSize: 30,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.only(left: 30),
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          'Talk to \nyour entrepreneur',
                                          style: GoogleFonts.poppins(
                                              color: Colors.white,
                                              height: 1.2,
                                              fontSize: 30,
                                              fontWeight: FontWeight.w500),
                                        ),
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
                                    padding: const EdgeInsets.only(top: 30),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Color(4280099132)),
                                      width: 350,
                                      height: 60,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.search,
                                              size: 30,
                                            ),
                                            SizedBox(
                                              width: 10,
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
            backgroundColor: Color(4280032553),
            body: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Color(4280032553),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 30, left: 15, right: 15),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Container(
                            child: StreamBuilder(
                          stream: Firestore.instance
                              .collection("Users")
                              .document(auth.currentUser.uid)
                              .snapshots(),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            return snapshot.data != null
                                ? snapshot.data["location"] != null
                                    ? GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              PageRouteBuilder(
                                                  transitionDuration: Duration(
                                                      milliseconds: 500),
                                                  pageBuilder: (ctx, ani, i) =>
                                                      Profile(
                                                        uidforprofile: auth
                                                            .currentUser.uid,
                                                      )));
                                        },
                                        child: CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              snapshot.data["location"]),
                                          backgroundColor: Color(4278272638),
                                          radius: 20,
                                        ),
                                      )
                                    : GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              PageRouteBuilder(
                                                  transitionDuration: Duration(
                                                      milliseconds: 500),
                                                  pageBuilder: (ctx, ani, i) =>
                                                      Profile(
                                                        uidforprofile: auth
                                                            .currentUser.uid,
                                                      )));
                                        },
                                        child: CircleAvatar(
                                          backgroundImage:
                                              AssetImage("assets/unknown.png"),
                                          backgroundColor: Color(4278272638),
                                          radius: 20,
                                        ),
                                      )
                                : GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                              transitionDuration:
                                                  Duration(milliseconds: 500),
                                              pageBuilder: (ctx, ani, i) =>
                                                  Profile(
                                                    uidforprofile:
                                                        auth.currentUser.uid,
                                                  )));
                                    },
                                    child: CircleAvatar(
                                      backgroundImage:
                                          AssetImage("assets/unknown.png"),
                                      backgroundColor: Color(4278272638),
                                      radius: 20,
                                    ),
                                  );
                          },
                        )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: usertype == "investor"
                            ? GradientText(
                                            text: "Connnections",
                                            colors: [Colors.blue[400], Colors.blue[700]],
                                            style: GoogleFonts.poppins(
                                                fontSize: 35,
                                                fontWeight: FontWeight.w600,),
                                          )
                            : GradientText(
                                            text: "Connections",
                                            colors: [Colors.blue[400], Colors.blue[700]],
                                            style: GoogleFonts.poppins(
                                                fontSize: 35,
                                                fontWeight: FontWeight.w600,),
                                          )
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
                          padding: const EdgeInsets.only(top: 30),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Color(4280099132)),
                            width: 350,
                            height: 40,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.search,
                                    size: 25,
                                    color: Colors.blue,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Material(
                                    type: MaterialType.transparency,
                                    child: Text(
                                      'Search',
                                      style: GoogleFonts.poppins(
                                          fontSize: 15,
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
