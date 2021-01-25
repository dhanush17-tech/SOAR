import 'package:SOAR/screens/feed_details.dart';
import 'dart:ui';
import 'package:SOAR/widgets/cards.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:SOAR/screens/feed.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'chat/chat_home.dart';
import 'for_users_feed_details.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:easy_gradient_text/easy_gradient_text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:SOAR/auth/login.dart';
import 'package:SOAR/screens/assist.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

class Profile extends StatefulWidget {
  String uidforprofile;
  String name;
  Profile({this.uidforprofile, this.name});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  Future<void> _fetchUserinfoForSettingsPage() async {
    try {
      await Firestore.instance
          .collection("Users")
          .document(widget.uidforprofile)
          .get()
          .then((value) {
        if (value.exists) {
          setState(() {
            dpurl = value.data()["location"];
            name = value.data()["name"];
            tagline = value.data()["tagline"];
            usertype = value.data()["usertype"];
            websiteurl = value.data()["websiteurl"];
            uid = value.data()["uid"];
          });
          print(uid);
        }
      });
    } catch (e) {}
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future checkfor_rentrepreneur() async {
    final QuerySnapshot qSnap = await Firestore.instance
        .collection("Users")
        .document(widget.uidforprofile)
        .collection("followers")
        .getDocuments();
    connectionlenght = qSnap.documents.length.toString();
    print(connectionlenght);
    if (connectionlenght == "0") {
      final QuerySnapshot snap = await Firestore.instance
          .collection("Users")
          .document(widget.uidforprofile)
          .collection("following")
          .getDocuments();
      setState(() {
        connectionlenght = snap.documents.length.toString();
        print(connectionlenght);
      });
    }
  }

  _nowuserdetails() async {
    try {
      var man =
          Firestore.instance.collection("Users").document(auth.currentUser.uid);
      await Firestore.instance
          .collection("Users")
          .document(auth.currentUser.uid)
          .get()
          .then((value) {
        if (value.exists) {
          setState(() {
            nowuser_dpurl = value.data()["location"];
            nowuser_dpurl = value.data()["location"];
            nowuser_name = value.data()["name"];
            nowuser_tagline = value.data()["tagline"];
            nowuser_usertype = value.data()["usertype"];
            nowuser_websiteurl = value.data()["websiteurl"];
            nowuser_uid = value.data()["uid"];
          });
        }
      });
    } catch (e) {}
  }

  bro() {
    Firestore.instance
        .collection("Users")
        .document(auth.currentUser.uid)
        .get()
        .then((value) {
      setState(() {
        currentusertype = value["usertype"];
      });
    });
  }

  String isfollower;
  checkfollowerexists() async {
    QuerySnapshot _query = await Firestore.instance
        .collection("Users")
        .document(auth.currentUser.uid)
        .collection("following")
        .where('uid_entrepreneur', isEqualTo: widget.uidforprofile)
        .getDocuments();

    if (_query.documents.length > 0) {
      setState(() {
        isfollower = "exists";
      });
    } else {
      setState(() {
        isfollower = "no";
      });
      print("${isfollower}man");
    }
  }

  String currentusertype;

  TextEditingController nameChange = TextEditingController();
  TextEditingController websiteUrlChnage = TextEditingController();
  TextEditingController taglineChange = TextEditingController();

  Future<void> _edit() async {
    try {
      await Firestore.instance
          .collection("Users")
          .document(widget.uidforprofile)
          .get()
          .then((value) {
        setState(() {
          nameChange.text = value.data()["name"];
          websiteUrlChnage.text = value.data()["websiteurl"];
          taglineChange.text = value.data()["tagline"];
          usertype = value.data()["usertype"];
          location = value.data()["location"];
        });
      });
    } catch (e) {}
  }

  String location;

  Future uploadProfilePicture() async {
    DateTime _time = DateTime.now();
    var postImage = await ImagePicker.pickImage(source: ImageSource.gallery);

    final Reference storageRef = FirebaseStorage.instance.ref();

    UploadTask uploadTask = await storageRef
        .child("post_${auth.currentUser.uid + _time.toString()}.jpg")
        .putFile(postImage)
        .then((val) {
      val.ref.getDownloadURL().then((val) async {
        setState(() {
          location = val;
        });
        await Firestore.instance
            .collection("Users")
            .document(auth.currentUser.uid)
            .set({"location": location}, SetOptions(merge: true));
        await _fetchUserinfoForSettingsPage();

        print(location);
      });
    });
  }

  noofposts() {
    Firestore.instance
        .collection("Users")
        .document(widget.uidforprofile)
        .collection("posts")
        .get()
        .then((value) {
      setState(() {
        no_ofposts = value.documents.length;
      });
    });
  }

  @override
  void initState() {
    checkfollowerexists();
    checkfor_rentrepreneur();
    // TODO: implement initState
    super.initState();
    _fetchUserinfoForSettingsPage();
    _nowuserdetails();
    checkfor_rentrepreneur();
    print(widget.name);
    _edit();
    print(widget.uidforprofile);
    noofposts();
    bro();
    _controller = AnimationController(vsync: this, duration: duration);
    _scaleAnimation = Tween<double>(begin: 1, end: 0.8).animate(_controller);
    _menuScaleAnimation =
        Tween<double>(begin: 0.5, end: 1).animate(_controller);
    _slideAnimation = Tween<Offset>(begin: Offset(-1, 0), end: Offset(0, 0))
        .animate(_controller);
  }

  int no_ofposts;

  String dpurl;
  String name;
  String tagline;
  String usertype;
  String websiteurl;
  String uid;

  String nowuser_dpurl;
  String nowuser_name;
  String nowuser_tagline;
  String nowuser_usertype;
  String nowuser_websiteurl;
  String nowuser_uid;

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
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Color(0xFFE6EDFA),
        body: auth.currentUser.uid == widget.uidforprofile
            ? Stack(
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
                            color: Color(0xFFE6EDFA),
                          ),
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child: SingleChildScrollView(
                            child: Stack(
                              children: [
                                Column(children: [
                                  Padding(
                                    padding: EdgeInsets.only(top: 25, left: 10),
                                    child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(Icons.person,
                                                      size: 40,
                                                      color: Colors.indigo),
                                                  SizedBox(width: 10),
                                                  GradientText(
                                                    text: "Profile",
                                                    colors: [
                                                      Colors.indigo,
                                                      Colors.blue
                                                    ],
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 35,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              if (auth.currentUser.uid ==
                                                  widget.uidforprofile)
                                                (isCollapsed
                                                    ? Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                bottom: 30,
                                                                right: 0),
                                                        child:
                                                            Column(children: [
                                                          SizedBox(height: 25),
                                                          IconButton(
                                                            icon: Icon(
                                                              Icons.menu,
                                                              size: 30,
                                                              color:
                                                                  Colors.blue,
                                                            ),
                                                            onPressed: () {
                                                              setState(() {
                                                                if (isCollapsed)
                                                                  _controller
                                                                      .forward();
                                                                else
                                                                  _controller
                                                                      .reverse();

                                                                isCollapsed =
                                                                    !isCollapsed;
                                                              });
                                                            },
                                                          ),
                                                        ]))
                                                    : Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                bottom: 50,
                                                                right: 0),
                                                        child: IconButton(
                                                          icon: Icon(
                                                            Icons
                                                                .arrow_back_ios,
                                                            color: Colors.blue,
                                                          ),
                                                          onPressed: () {
                                                            setState(() {
                                                              if (isCollapsed)
                                                                _controller
                                                                    .forward();
                                                              else
                                                                _controller
                                                                    .reverse();

                                                              isCollapsed =
                                                                  !isCollapsed;
                                                            });
                                                          },
                                                        )))
                                              else
                                                (Container(
                                                  width: 0,
                                                  height: 0,
                                                ))
                                            ])),
                                  ),
                                  location == null
                                      ? GestureDetector(
                                          onTap: widget.uidforprofile !=
                                                  auth.currentUser.uid
                                              ? null
                                              : () async {
                                                  await uploadProfilePicture();
                                                },
                                          child: Container(
                                            width: 200,
                                            height: 200,
                                            child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                Hero(
                                                  tag: "man +iii",
                                                  child: CircleAvatar(
                                                    backgroundColor:
                                                        Color(4278272638),
                                                    backgroundImage: AssetImage(
                                                      "assets/unknown.png",
                                                    ),
                                                    radius: 85.0,
                                                  ),
                                                ),
                                                widget.uidforprofile ==
                                                        auth.currentUser.uid
                                                    ? Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                          top: 130,
                                                          left: 120,
                                                        ),
                                                        child: FittedBox(
                                                          child: Container(
                                                            width: 45,
                                                            height: 45,
                                                            decoration:
                                                                BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              gradient:
                                                                  LinearGradient(
                                                                      colors: [
                                                                    Colors.blue[
                                                                        400],
                                                                    Colors.blue[
                                                                        700]
                                                                  ]),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: Colors
                                                                      .black
                                                                      .withOpacity(
                                                                          0.5),
                                                                  spreadRadius:
                                                                      10,
                                                                  blurRadius:
                                                                      20,
                                                                  offset: Offset(
                                                                      0,
                                                                      3), // changes position of shadow
                                                                ),
                                                              ],
                                                            ),
                                                            child: Icon(
                                                              Icons.edit,
                                                              size: 30,
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    : Container(),
                                              ],
                                            ),
                                          ),
                                        )
                                      : GestureDetector(
                                          onTap: widget.uidforprofile ==
                                                  auth.currentUser.uid
                                              ? () async {
                                                  await uploadProfilePicture();
                                                }
                                              : null,
                                          child: Container(
                                            width: 200,
                                            height: 200,
                                            child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                Hero(
                                                  tag: "man +iii",
                                                  child: CircleAvatar(
                                                    backgroundColor:
                                                        Color(4278272638),
                                                    backgroundImage:
                                                        NetworkImage(location),
                                                    radius: 85.0,
                                                  ),
                                                ),
                                                widget.uidforprofile ==
                                                        auth.currentUser.uid
                                                    ? Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                          top: 130,
                                                          left: 120,
                                                        ),
                                                        child: FittedBox(
                                                          child: Container(
                                                            width: 45,
                                                            height: 45,
                                                            decoration:
                                                                BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              color:
                                                                  Colors.blue,
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: Colors
                                                                      .black
                                                                      .withOpacity(
                                                                          0.5),
                                                                  spreadRadius:
                                                                      10,
                                                                  blurRadius:
                                                                      20,
                                                                  offset: Offset(
                                                                      0,
                                                                      3), // changes position of shadow
                                                                ),
                                                              ],
                                                            ),
                                                            child: Icon(
                                                              Icons.edit,
                                                              color:
                                                                  Colors.white,
                                                              size: 30,
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    : Container(),
                                              ],
                                            ),
                                          ),
                                        ),
                                ]),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 300,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 90,
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child:
                                                        SingleChildScrollView(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                top: 0,
                                                                right: 0),
                                                        child: auth.currentUser
                                                                    .uid !=
                                                                widget
                                                                    .uidforprofile
                                                            ? StreamBuilder(
                                                                stream: Firestore
                                                                    .instance
                                                                    .collection(
                                                                        'Users')
                                                                    .document(
                                                                        "${widget.uidforprofile}")
                                                                    .snapshots(),
                                                                builder: (context,
                                                                    snapshot) {
                                                                  var userDocument =
                                                                      snapshot
                                                                          .data;
                                                                  return snapshot
                                                                              .data !=
                                                                          null
                                                                      ? Text(
                                                                          userDocument["name"] ??
                                                                              "It may take some time....",
                                                                          style: TextStyle(
                                                                              color: Color(0xFF3D4254),
                                                                              fontSize: 55,
                                                                              fontFamily: "good"),
                                                                        )
                                                                      : Container();
                                                                })
                                                            : Align(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child:
                                                                    Container(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                                  child:
                                                                      TextFormField(
                                                                        textAlign: TextAlign.center,
                                                                    controller:
                                                                        nameChange,
                                                                    decoration:
                                                                        InputDecoration(
                                                                            border:
                                                                                InputBorder.none),
                                                                    onChanged:
                                                                        (val) async {
                                                                      print(auth
                                                                          .currentUser
                                                                          .uid);
                                                                      await FirebaseFirestore
                                                                          .instance
                                                                          .collection(
                                                                              'Users')
                                                                          .document(auth
                                                                              .currentUser
                                                                              .uid)
                                                                          .setData({
                                                                        "name":
                                                                            nameChange.text,
                                                                        "tagline":
                                                                            taglineChange.text,
                                                                        "websiteurl":
                                                                            websiteUrlChnage.text,
                                                                        "uid": auth
                                                                            .currentUser
                                                                            .uid,
                                                                        "location":
                                                                            location,
                                                                        "usertype":
                                                                            usertype
                                                                      }).then((value) =>
                                                                              print("done"));
                                                                      if (usertype ==
                                                                          "investor") {
                                                                        FirebaseFirestore
                                                                            .instance
                                                                            .collection('Investor')
                                                                            .document(auth.currentUser.uid)
                                                                            .setData({
                                                                          "name":
                                                                              nameChange.text,
                                                                          "tagline":
                                                                              taglineChange.text,
                                                                          "websiteurl":
                                                                              websiteUrlChnage.text,
                                                                          "uid": auth
                                                                              .currentUser
                                                                              .uid,
                                                                          "location":
                                                                              location,
                                                                          "usertype":
                                                                              usertype
                                                                        });
                                                                      }
                                                                      if (usertype ==
                                                                          "entrepreneur") {
                                                                        FirebaseFirestore
                                                                            .instance
                                                                            .collection('Entrepreneur')
                                                                            .document(auth.currentUser.uid)
                                                                            .setData({
                                                                          "name":
                                                                              nameChange.text,
                                                                          "tagline":
                                                                              taglineChange.text,
                                                                          "websiteurl":
                                                                              websiteUrlChnage.text,
                                                                          "uid": auth
                                                                              .currentUser
                                                                              .uid,
                                                                          "location":
                                                                              location,
                                                                          "usertype":
                                                                              usertype
                                                                        });
                                                                      }
                                                                    },
                                                                    style: TextStyle(
                                                                        color: Color(
                                                                            0xFF3D4254),
                                                                        fontSize:
                                                                            55,
                                                                        fontFamily:
                                                                            "good"),
                                                                  ),
                                                                ),
                                                              ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 20,
                                                  ),
                                                  if (currentusertype !=
                                                      "entrepreneur")
                                                    (widget.uidforprofile !=
                                                            auth.currentUser.uid
                                                        ? isfollower == "no"
                                                            ? Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top: 35,
                                                                        right:
                                                                            10),
                                                                child: Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .topRight,
                                                                  child:
                                                                      GestureDetector(
                                                                    onTap: () {
                                                                      List<String>
                                                                          spiltList =
                                                                          name.split(
                                                                              " ");
                                                                      List<String>
                                                                          indexList =
                                                                          [];
                                                                      for (int i =
                                                                              0;
                                                                          i < spiltList.length;
                                                                          i++) {
                                                                        for (int j =
                                                                                0;
                                                                            j < spiltList[i].length + i;
                                                                            j++) {
                                                                          indexList.add(spiltList[i]
                                                                              .substring(0, j)
                                                                              .toLowerCase());
                                                                        }
                                                                      }
                                                                      Firestore
                                                                          .instance
                                                                          .collection(
                                                                              "Users")
                                                                          .document(auth
                                                                              .currentUser
                                                                              .uid)
                                                                          .collection(
                                                                              "following")
                                                                          .document(
                                                                              widget.uidforprofile)
                                                                          .setData({
                                                                        "location":
                                                                            location,
                                                                        "name":
                                                                            name,
                                                                        "tagline":
                                                                            tagline,
                                                                        "usertype":
                                                                            usertype,
                                                                        "websiteurl":
                                                                            websiteurl,
                                                                        "uid": auth
                                                                            .currentUser
                                                                            .uid,
                                                                        "uid_entrepreneur":
                                                                            widget.uidforprofile,
                                                                        "searchkey":
                                                                            indexList
                                                                      }).then((value) {
                                                                        print(
                                                                            "done");
                                                                        setState(
                                                                            () {
                                                                          _nowuserdetails();
                                                                          _fetchUserinfoForSettingsPage();
                                                                          checkfollowerexists();
                                                                          checkfor_rentrepreneur();
                                                                        });
                                                                      });

                                                                      List<String>
                                                                          otherList =
                                                                          nowuser_name
                                                                              .split(" ");
                                                                      List<String>
                                                                          ndexList =
                                                                          [];
                                                                      for (int m =
                                                                              0;
                                                                          m < otherList.length;
                                                                          m++) {
                                                                        for (int f =
                                                                                0;
                                                                            f < otherList[m].length + m;
                                                                            f++) {
                                                                          ndexList.add(otherList[m]
                                                                              .substring(0, f)
                                                                              .toLowerCase());
                                                                        }
                                                                      }
                                                                      Firestore
                                                                          .instance
                                                                          .collection(
                                                                              "Users")
                                                                          .document(widget
                                                                              .uidforprofile)
                                                                          .collection(
                                                                              "followers")
                                                                          .add({
                                                                        "location":
                                                                            nowuser_dpurl,
                                                                        "name":
                                                                            nowuser_name,
                                                                        "tagline":
                                                                            nowuser_tagline,
                                                                        "usertype":
                                                                            nowuser_usertype,
                                                                        "websiteurl":
                                                                            nowuser_websiteurl,
                                                                        "uid": widget
                                                                            .uidforprofile,
                                                                        "investor_uid":
                                                                            nowuser_uid,
                                                                        "searchkey":
                                                                            ndexList
                                                                      }).then((value) {
                                                                        print(
                                                                            "done");
                                                                        setState(
                                                                            () {
                                                                          _nowuserdetails();
                                                                          _fetchUserinfoForSettingsPage();
                                                                          checkfollowerexists();
                                                                          checkfor_rentrepreneur();
                                                                        });
                                                                      });
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      width:
                                                                          120,
                                                                      height:
                                                                          30,
                                                                      decoration: BoxDecoration(
                                                                          gradient: LinearGradient(
                                                                              colors: [
                                                                                Colors.blue[400],
                                                                                Colors.blueAccent[700]
                                                                              ],
                                                                              begin: Alignment.centerLeft,
                                                                              end: Alignment.centerRight),
                                                                          borderRadius: BorderRadius.circular(10)),
                                                                      child:
                                                                          Align(
                                                                        alignment:
                                                                            Alignment.center,
                                                                        child:
                                                                            Text(
                                                                          "Follow",
                                                                          style: TextStyle(
                                                                              fontSize: 20,
                                                                              color: Colors.white,
                                                                              fontWeight: FontWeight.w500),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              )
                                                            : Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top: 35,
                                                                        right:
                                                                            13),
                                                                child: Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .topRight,
                                                                  child:
                                                                      GestureDetector(
                                                                    onTap: () {
                                                                      print(
                                                                          "jj");
                                                                      Firestore
                                                                          .instance
                                                                          .collection(
                                                                              "Users")
                                                                          .document(auth
                                                                              .currentUser
                                                                              .uid)
                                                                          .collection(
                                                                              "following")
                                                                          .where(
                                                                              'uid_entrepreneur',
                                                                              isEqualTo: widget.uidforprofile)
                                                                          .get()
                                                                          .then((value) {
                                                                        value
                                                                            .docs
                                                                            .forEach((element) {
                                                                          Firestore
                                                                              .instance
                                                                              .collection("Users")
                                                                              .document(auth.currentUser.uid)
                                                                              .collection("following")
                                                                              .doc(element.id)
                                                                              .delete()
                                                                              .then((value) => print("complete"));
                                                                        });
                                                                      }).then((value) {
                                                                        setState(
                                                                            () {
                                                                          _nowuserdetails();
                                                                          _fetchUserinfoForSettingsPage();
                                                                          checkfollowerexists();
                                                                          checkfor_rentrepreneur();
                                                                        });
                                                                      });

                                                                      Firestore
                                                                          .instance
                                                                          .collection(
                                                                              "Users")
                                                                          .document(widget
                                                                              .uidforprofile)
                                                                          .collection(
                                                                              "followers")
                                                                          .where(
                                                                              'investor_uid',
                                                                              isEqualTo: auth.currentUser.uid)
                                                                          .get()
                                                                          .then((value) {
                                                                        value
                                                                            .docs
                                                                            .forEach((element) {
                                                                          Firestore
                                                                              .instance
                                                                              .collection("Users")
                                                                              .document(widget.uidforprofile)
                                                                              .collection("followers")
                                                                              .doc(element.id)
                                                                              .delete()
                                                                              .then((value) => print("complete"));
                                                                        });
                                                                      }).then((value) {
                                                                        setState(
                                                                            () {
                                                                          _nowuserdetails();
                                                                          _fetchUserinfoForSettingsPage();
                                                                          checkfollowerexists();
                                                                          checkfor_rentrepreneur();
                                                                        });
                                                                      });
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      width:
                                                                          120,
                                                                      height:
                                                                          30,
                                                                      decoration: BoxDecoration(
                                                                          gradient: LinearGradient(
                                                                              colors: [
                                                                                Colors.blue[400],
                                                                                Colors.blueAccent[700]
                                                                              ],
                                                                              begin: Alignment.centerLeft,
                                                                              end: Alignment.centerRight),
                                                                          borderRadius: BorderRadius.circular(10)),
                                                                      child:
                                                                          Align(
                                                                        alignment:
                                                                            Alignment.center,
                                                                        child:
                                                                            Text(
                                                                          "Unfollow",
                                                                          style: TextStyle(
                                                                              fontSize: 20,
                                                                              color: Color(4278190106),
                                                                              fontWeight: FontWeight.w500),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              )
                                                        : Container())
                                                  else
                                                    Container()
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                top: 59,
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 0, top: 0),
                                                child: auth.currentUser.uid !=
                                                        widget.uidforprofile
                                                    ? StreamBuilder(
                                                        stream: Firestore
                                                            .instance
                                                            .collection('Users')
                                                            .document(
                                                                "${widget.uidforprofile}")
                                                            .snapshots(),
                                                        builder: (context,
                                                            snapshot) {
                                                          var userDocument =
                                                              snapshot.data;
                                                          return snapshot
                                                                      .data ==
                                                                  null
                                                              ? CircularProgressIndicator()
                                                              : Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .topLeft,
                                                                  child: Text(
                                                                    userDocument[
                                                                            "tagline"] ??
                                                                        "It may take some time....",
                                                                    textAlign:
                                                                        TextAlign
                                                                            .left,
                                                                    style:
                                                                        TextStyle(
                                                                      color: Color(
                                                                              0xFF3D4254)
                                                                          .withOpacity(
                                                                              1),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      fontSize:
                                                                          15,
                                                                    ),
                                                                  ),
                                                                );
                                                        })
                                                    : Align(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Container(
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          child: TextFormField(
                                                            textAlign: TextAlign
                                                                .center,
                                                            controller:
                                                                taglineChange,
                                                            style: TextStyle(
                                                              color: Color(
                                                                      0xFF3D4254)
                                                                  .withOpacity(
                                                                      1),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontSize: 15,
                                                            ),
                                                            onChanged:
                                                                (val) async {
                                                              print(auth
                                                                  .currentUser
                                                                  .uid);
                                                              await FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'Users')
                                                                  .document(auth
                                                                      .currentUser
                                                                      .uid)
                                                                  .setData({
                                                                "name":
                                                                    nameChange
                                                                        .text,
                                                                "tagline":
                                                                    taglineChange
                                                                        .text,
                                                                "websiteurl":
                                                                    websiteUrlChnage
                                                                        .text,
                                                                "location":
                                                                    location,
                                                                "usertype":
                                                                    usertype,
                                                                "uid": auth
                                                                    .currentUser
                                                                    .uid
                                                              }).then((value) =>
                                                                      print(
                                                                          "done"));
                                                              if (usertype ==
                                                                  "investor") {
                                                                FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        'Investor')
                                                                    .document(auth
                                                                        .currentUser
                                                                        .uid)
                                                                    .setData({
                                                                  "name":
                                                                      nameChange
                                                                          .text,
                                                                  "tagline":
                                                                      taglineChange
                                                                          .text,
                                                                  "websiteurl":
                                                                      websiteUrlChnage
                                                                          .text,
                                                                  "usertype":
                                                                      usertype,
                                                                  "location":
                                                                      location,
                                                                  "uid": auth
                                                                      .currentUser
                                                                      .uid
                                                                });
                                                              }
                                                              if (usertype ==
                                                                  "entrepreneur") {
                                                                FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        'Entrepreneur')
                                                                    .document(auth
                                                                        .currentUser
                                                                        .uid)
                                                                    .setData({
                                                                  "name":
                                                                      nameChange
                                                                          .text,
                                                                  "tagline":
                                                                      taglineChange
                                                                          .text,
                                                                  "websiteurl":
                                                                      websiteUrlChnage
                                                                          .text,
                                                                  "location":
                                                                      location,
                                                                  "uid": auth
                                                                      .currentUser
                                                                      .uid,
                                                                  "usertype":
                                                                      usertype
                                                                });
                                                              }
                                                            },
                                                            decoration:
                                                                InputDecoration(
                                                                    border:
                                                                        InputBorder
                                                                            .none),
                                                          ),
                                                        ),
                                                      ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                          top: auth.currentUser.uid ==
                                                  widget.uidforprofile
                                              ? 0
                                              : 0,
                                        ),
                                        child: Padding(
                                          padding:
                                              EdgeInsets.only(left: 0, top: 0),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Image.asset("assets/web.png"),
                                              auth.currentUser.uid !=
                                                      widget.uidforprofile
                                                  ? StreamBuilder(
                                                      stream: Firestore.instance
                                                          .collection('Users')
                                                          .document(
                                                              "${widget.uidforprofile}")
                                                          .snapshots(),
                                                      builder:
                                                          (context, snapshot) {
                                                        var userDocument =
                                                            snapshot.data;
                                                        return snapshot.data ==
                                                                null
                                                            ? CircularProgressIndicator()
                                                            : Text(
                                                                userDocument[
                                                                    "websiteurl"],
                                                                style:
                                                                    TextStyle(
                                                                  color: Color(
                                                                          0xFF3D4254)
                                                                      .withOpacity(
                                                                          1),
                                                                  fontSize: 15,
                                                                ),
                                                              );
                                                      })
                                                  : Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              45,
                                                      child: TextFormField(
                                                        textAlign:
                                                            TextAlign.center,
                                                        controller:
                                                            websiteUrlChnage,
                                                        style: TextStyle(
                                                          color: Color(
                                                                  0xFF3D4254)
                                                              .withOpacity(1),
                                                          fontSize: 15,
                                                        ),
                                                        onChanged: (val) async {
                                                          print(auth
                                                              .currentUser.uid);
                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'Users')
                                                              .document(auth
                                                                  .currentUser
                                                                  .uid)
                                                              .setData({
                                                            "name":
                                                                nameChange.text,
                                                            "tagline":
                                                                taglineChange
                                                                    .text,
                                                            "websiteurl":
                                                                websiteUrlChnage
                                                                    .text,
                                                            "location":
                                                                location,
                                                            "uid": auth
                                                                .currentUser
                                                                .uid,
                                                            "usertype": usertype
                                                          }).then((value) =>
                                                                  print(
                                                                      "done"));
                                                          if (usertype ==
                                                              "investor") {
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'Investor')
                                                                .document(auth
                                                                    .currentUser
                                                                    .uid)
                                                                .setData({
                                                              "name": nameChange
                                                                  .text,
                                                              "tagline":
                                                                  taglineChange
                                                                      .text,
                                                              "websiteurl":
                                                                  websiteUrlChnage
                                                                      .text,
                                                              "location":
                                                                  location,
                                                              "uid": auth
                                                                  .currentUser
                                                                  .uid,
                                                              "usertype":
                                                                  usertype
                                                            });
                                                          }
                                                          if (usertype ==
                                                              "entrepreneur") {
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'Entrepreneur')
                                                                .document(auth
                                                                    .currentUser
                                                                    .uid)
                                                                .setData({
                                                              "name": nameChange
                                                                  .text,
                                                              "tagline":
                                                                  taglineChange
                                                                      .text,
                                                              "websiteurl":
                                                                  websiteUrlChnage
                                                                      .text,
                                                              "location":
                                                                  location,
                                                              "uid": auth
                                                                  .currentUser
                                                                  .uid,
                                                              "usertype":
                                                                  usertype
                                                            });
                                                          }
                                                        },
                                                        decoration:
                                                            InputDecoration(
                                                                border:
                                                                    InputBorder
                                                                        .none),
                                                      ),
                                                    ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10, left: 40),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Container(
                                                width: 120,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    color: Colors.white),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      15.0),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        connectionlenght ?? "0",
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xFF3D4254),
                                                            fontSize: 30,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                      Opacity(
                                                          opacity: 0.9,
                                                          child: Text(
                                                            "Connections",
                                                            style: TextStyle(
                                                              color: Color(
                                                                  0xFF3D4254),
                                                            ),
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                width: 120,
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20)),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      15.0),
                                                  child: Column(
                                                    children: [
                                                      no_ofposts == null
                                                          ? Text(
                                                              "0",
                                                              style: TextStyle(
                                                                  color: Color(
                                                                      0xFF3D4254),
                                                                  fontSize: 30,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            )
                                                          : Text(
                                                              "$no_ofposts",
                                                              style: TextStyle(
                                                                  color: Color(
                                                                      0xFF3D4254),
                                                                  fontSize: 30,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                      Opacity(
                                                          opacity: 0.9,
                                                          child: Text(
                                                            "Pitches",
                                                            textAlign:
                                                                TextAlign.left,
                                                            style: TextStyle(
                                                              color: Color(
                                                                  0xFF3D4254),
                                                            ),
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 30,
                                              ),
                                            ]),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 5, bottom: 0),
                                          child: GradientText(
                                            text: " Pitches",
                                            colors: [
                                              Colors.blue[400],
                                              Colors.blue[700]
                                            ],
                                            style: TextStyle(
                                                fontSize: 55,
                                                fontFamily: "good",
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.bottomCenter,
                                        child: StreamBuilder(
                                            stream: Firestore.instance
                                                .collection("Users")
                                                .document(widget.uidforprofile)
                                                .collection("posts")
                                                .orderBy("date",
                                                    descending: true)
                                                .snapshots(),
                                            builder: (context, snapshot) {
                                              if (!snapshot.hasData)
                                                return Text('Loading... data');
                                              return snapshot.data != null
                                                  ? ListView.separated(
                                                      reverse: true,
                                                      separatorBuilder: (ctx,
                                                              i) =>
                                                          SizedBox(height: 20),
                                                      shrinkWrap: true,
                                                      physics:
                                                          NeverScrollableScrollPhysics(),
                                                      itemCount: snapshot.data
                                                          .documents.length,
                                                      itemBuilder: (ctx, i) {
                                                        DocumentSnapshot
                                                            course = snapshot
                                                                .data
                                                                .documents[i];

                                                        return snapshot.data ==
                                                                null
                                                            ? Container(
                                                                width: 20,
                                                                height: 20,
                                                              )
                                                            : Align(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left: 15,
                                                                      right: 15,
                                                                      top: 20),
                                                                  child:
                                                                      Container(
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            gradient:
                                                                                LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [
                                                                              Color(4280311451).withOpacity(0.4),
                                                                              Color(4278547942).withOpacity(0.4),
                                                                            ]),
                                                                            borderRadius:
                                                                                BorderRadius.circular(20),
                                                                          ),
                                                                          child:
                                                                              Stack(alignment: Alignment.center, children: [
                                                                            Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: Column(
                                                                                children: [
                                                                                  Padding(
                                                                                    padding: const EdgeInsets.only(top: 1, left: 10),
                                                                                    child: Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: [
                                                                                        Container(
                                                                                            child: Row(
                                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                          children: [
                                                                                            StreamBuilder(
                                                                                                stream: Firestore.instance.collection("Users").document(course["uid"]).snapshots(),
                                                                                                builder: (ctx, i) {
                                                                                                  return i.data == null
                                                                                                      ? Container(width: 20, height: 20)
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
                                                                                          padding: const EdgeInsets.all(8.0),
                                                                                          child: Container(
                                                                                            width: 50,
                                                                                            height: 50,
                                                                                            decoration: BoxDecoration(
                                                                                              borderRadius: BorderRadius.circular(10),
                                                                                              color: Colors.white.withOpacity(0.12),
                                                                                            ),
                                                                                            child: Padding(
                                                                                              padding: const EdgeInsets.only(top: 5),
                                                                                              child: Column(
                                                                                                children: [
                                                                                                  Padding(
                                                                                                    padding: const EdgeInsets.only(top: 5),
                                                                                                    child: Text(
                                                                                                      course["day"],
                                                                                                      style: GoogleFonts.poppins(fontSize: 15, height: 1, fontWeight: FontWeight.w600, color: Colors.white),
                                                                                                    ),
                                                                                                  ),
                                                                                                  SizedBox(
                                                                                                    height: 3,
                                                                                                  ),
                                                                                                  Text(
                                                                                                    course["month"],
                                                                                                    style: GoogleFonts.poppins(height: 1, fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white),
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
                                                                                    padding: const EdgeInsets.only(left: 10, right: 10),
                                                                                    child: Material(
                                                                                      borderRadius: BorderRadius.only(
                                                                                        topLeft: Radius.circular(5),
                                                                                        bottomRight: Radius.circular(5),
                                                                                        topRight: Radius.circular(20),
                                                                                        bottomLeft: Radius.circular(20),
                                                                                      ),
                                                                                      elevation: 3,
                                                                                      child: Stack(
                                                                                        alignment: Alignment.center,
                                                                                        children: [
                                                                                          Hero(
                                                                                            tag: "dssd+$i",
                                                                                            child: Material(
                                                                                                borderRadius: BorderRadius.only(
                                                                                                  topLeft: Radius.circular(5),
                                                                                                  bottomRight: Radius.circular(5),
                                                                                                  topRight: Radius.circular(20),
                                                                                                  bottomLeft: Radius.circular(20),
                                                                                                ),
                                                                                                elevation: 20,
                                                                                                child: Container(
                                                                                                  height: 170,
                                                                                                  decoration: BoxDecoration(
                                                                                                      borderRadius: BorderRadius.only(
                                                                                                        topLeft: Radius.circular(5),
                                                                                                        bottomRight: Radius.circular(5),
                                                                                                        topRight: Radius.circular(20),
                                                                                                        bottomLeft: Radius.circular(20),
                                                                                                      ),
                                                                                                      image: course["postimage"] != null ? DecorationImage(image: NetworkImage(course["postimage"]), fit: BoxFit.cover) : DecorationImage(image: AssetImage("assets/unknown.png"))),
                                                                                                )),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(
                                                                                    height: 10,
                                                                                  ),
                                                                                  Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                    children: [
                                                                                      Row(
                                                                                        children: [
                                                                                          Image.asset(
                                                                                            "assets/heart.png",
                                                                                            color: Color(4290118716),
                                                                                            scale: 10,
                                                                                          ),
                                                                                          Text(
                                                                                            "${course["likes"]}",
                                                                                            style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white.withOpacity(1)),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                      SizedBox(
                                                                                        width: 0,
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.only(right: 0),
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
                                                                                      auth.currentUser.uid == widget.uidforprofile
                                                                                          ? IconButton(
                                                                                              icon: Icon(
                                                                                                Icons.delete_rounded,
                                                                                                color: Colors.white,
                                                                                                size: 22,
                                                                                              ),
                                                                                              onPressed: () {
                                                                                                setState(() {
                                                                                                  documentid = course.documentID.toString();
                                                                                                });
                                                                                                print(documentid);
                                                                                                Firestore.instance.collection("Users").document(widget.uidforprofile).collection("posts").document(documentid).delete().then((value) {
                                                                                                  Firestore.instance.collection("Feed").document(documentid).delete();
                                                                                                });
                                                                                              })
                                                                                          : Container(
                                                                                              width: 0,
                                                                                              height: 0,
                                                                                            ),
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
                                                                                                    builder: (_) => FeedDetilsForEntrepreneurs(documnetid: course.documentID, id: widget.uidforprofile, url: course["video_url"], d: i),
                                                                                                  ));
                                                                                            },
                                                                                            child: Container(
                                                                                              alignment: Alignment.center,
                                                                                              width: 100,
                                                                                              height: 30,
                                                                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.white.withOpacity(0.3)),
                                                                                              child: Text(
                                                                                                "Learn More",
                                                                                                style: TextStyle(
                                                                                                  fontSize: 22,
                                                                                                  fontFamily: "good",
                                                                                                  fontWeight: FontWeight.w300,
                                                                                                  color: Colors.white,
                                                                                                ),
                                                                                              ),
                                                                                            )),
                                                                                      )
                                                                                    ],
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            )
                                                                          ])),
                                                                ),
                                                              );
                                                      })
                                                  : Container(
                                                      width: 20,
                                                      height: 30,
                                                    );
                                            }),
                                      ),
                                      SizedBox(
                                        height: 30,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : Stack(
                children: [
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
                            color: Color(0xFFE6EDFA),
                          ),
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child: SingleChildScrollView(
                            child: Stack(
                              children: [
                                Column(children: [
                                  Padding(
                                    padding: EdgeInsets.only(top: 25, left: 10),
                                    child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(Icons.person,
                                                      size: 40,
                                                      color: Colors.indigo),
                                                  SizedBox(width: 10),
                                                  GradientText(
                                                    text: "Profile",
                                                    colors: [
                                                      Colors.indigo,
                                                      Colors.blue
                                                    ],
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 35,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              if (auth.currentUser.uid ==
                                                  widget.uidforprofile)
                                                (isCollapsed
                                                    ? Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                bottom: 30,
                                                                right: 0),
                                                        child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              SizedBox(
                                                                  height: 25),
                                                              IconButton(
                                                                icon: Icon(
                                                                  Icons.menu,
                                                                  size: 30,
                                                                  color: Colors
                                                                      .blue,
                                                                ),
                                                                onPressed: () {
                                                                  setState(() {
                                                                    if (isCollapsed)
                                                                      _controller
                                                                          .forward();
                                                                    else
                                                                      _controller
                                                                          .reverse();

                                                                    isCollapsed =
                                                                        !isCollapsed;
                                                                  });
                                                                },
                                                              ),
                                                            ]))
                                                    : Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                bottom: 50,
                                                                right: 0),
                                                        child: IconButton(
                                                          icon: Icon(
                                                            Icons
                                                                .arrow_back_ios,
                                                            color: Colors.blue,
                                                          ),
                                                          onPressed: () {
                                                            setState(() {
                                                              if (isCollapsed)
                                                                _controller
                                                                    .forward();
                                                              else
                                                                _controller
                                                                    .reverse();

                                                              isCollapsed =
                                                                  !isCollapsed;
                                                            });
                                                          },
                                                        )))
                                              else
                                                (Container(
                                                  width: 0,
                                                  height: 0,
                                                ))
                                            ])),
                                  ),
                                  location == null
                                      ? GestureDetector(
                                          onTap: widget.uidforprofile !=
                                                  auth.currentUser.uid
                                              ? null
                                              : () async {
                                                  await uploadProfilePicture();
                                                },
                                          child: Container(
                                            width: 200,
                                            height: 200,
                                            child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                Hero(
                                                  tag: "man +iii",
                                                  child: CircleAvatar(
                                                    backgroundColor:
                                                        Color(4278272638),
                                                    backgroundImage: AssetImage(
                                                      "assets/unknown.png",
                                                    ),
                                                    radius: 85.0,
                                                  ),
                                                ),
                                                widget.uidforprofile ==
                                                        auth.currentUser.uid
                                                    ? Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                          top: 130,
                                                          left: 120,
                                                        ),
                                                        child: FittedBox(
                                                          child: Container(
                                                            width: 45,
                                                            height: 45,
                                                            decoration:
                                                                BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              gradient:
                                                                  LinearGradient(
                                                                      colors: [
                                                                    Colors.blue[
                                                                        400],
                                                                    Colors.blue[
                                                                        700]
                                                                  ]),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: Colors
                                                                      .black
                                                                      .withOpacity(
                                                                          0.5),
                                                                  spreadRadius:
                                                                      10,
                                                                  blurRadius:
                                                                      20,
                                                                  offset: Offset(
                                                                      0,
                                                                      3), // changes position of shadow
                                                                ),
                                                              ],
                                                            ),
                                                            child: Icon(
                                                              Icons.edit,
                                                              size: 30,
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    : Container(),
                                              ],
                                            ),
                                          ),
                                        )
                                      : GestureDetector(
                                          onTap: widget.uidforprofile ==
                                                  auth.currentUser.uid
                                              ? () async {
                                                  await uploadProfilePicture();
                                                }
                                              : null,
                                          child: Container(
                                            width: 200,
                                            height: 200,
                                            child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                Hero(
                                                  tag: "man +iii",
                                                  child: CircleAvatar(
                                                    backgroundColor:
                                                        Color(4278272638),
                                                    backgroundImage:
                                                        NetworkImage(location),
                                                    radius: 85.0,
                                                  ),
                                                ),
                                                widget.uidforprofile ==
                                                        auth.currentUser.uid
                                                    ? Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                          top: 130,
                                                          left: 120,
                                                        ),
                                                        child: FittedBox(
                                                          child: Container(
                                                            width: 45,
                                                            height: 45,
                                                            decoration:
                                                                BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              color:
                                                                  Colors.blue,
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: Colors
                                                                      .black
                                                                      .withOpacity(
                                                                          0.5),
                                                                  spreadRadius:
                                                                      10,
                                                                  blurRadius:
                                                                      20,
                                                                  offset: Offset(
                                                                      0,
                                                                      3), // changes position of shadow
                                                                ),
                                                              ],
                                                            ),
                                                            child: Icon(
                                                              Icons.edit,
                                                              color:
                                                                  Colors.white,
                                                              size: 30,
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    : Container(),
                                              ],
                                            ),
                                          ),
                                        ),
                                ]),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 270,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 90,
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child:
                                                        SingleChildScrollView(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                top: 0,
                                                                right: 10),
                                                        child: auth.currentUser
                                                                    .uid !=
                                                                widget
                                                                    .uidforprofile
                                                            ? StreamBuilder(
                                                                stream: Firestore
                                                                    .instance
                                                                    .collection(
                                                                        'Users')
                                                                    .document(
                                                                        "${widget.uidforprofile}")
                                                                    .snapshots(),
                                                                builder: (context,
                                                                    snapshot) {
                                                                  var userDocument =
                                                                      snapshot
                                                                          .data;
                                                                  return snapshot
                                                                              .data !=
                                                                          null
                                                                      ? Text(
                                                                          userDocument["name"] ??
                                                                              "It may take some time....",
                                                                          style: TextStyle(
                                                                              color: Color(0xFF3D4254),
                                                                              fontSize: 55,
                                                                              fontFamily: "good"),
                                                                        )
                                                                      : Container();
                                                                })
                                                            : Align(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child:
                                                                    Container(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.75,
                                                                  child:
                                                                      TextFormField(
                                                                    controller:
                                                                        nameChange,
                                                                    decoration:
                                                                        InputDecoration(
                                                                            border:
                                                                                InputBorder.none),
                                                                    onChanged:
                                                                        (val) async {
                                                                      print(auth
                                                                          .currentUser
                                                                          .uid);
                                                                      await FirebaseFirestore
                                                                          .instance
                                                                          .collection(
                                                                              'Users')
                                                                          .document(auth
                                                                              .currentUser
                                                                              .uid)
                                                                          .setData({
                                                                        "name":
                                                                            nameChange.text,
                                                                        "tagline":
                                                                            taglineChange.text,
                                                                        "websiteurl":
                                                                            websiteUrlChnage.text,
                                                                        "uid": auth
                                                                            .currentUser
                                                                            .uid,
                                                                        "location":
                                                                            location,
                                                                        "usertype":
                                                                            usertype
                                                                      }).then((value) =>
                                                                              print("done"));
                                                                      if (usertype ==
                                                                          "investor") {
                                                                        FirebaseFirestore
                                                                            .instance
                                                                            .collection('Investor')
                                                                            .document(auth.currentUser.uid)
                                                                            .setData({
                                                                          "name":
                                                                              nameChange.text,
                                                                          "tagline":
                                                                              taglineChange.text,
                                                                          "websiteurl":
                                                                              websiteUrlChnage.text,
                                                                          "uid": auth
                                                                              .currentUser
                                                                              .uid,
                                                                          "location":
                                                                              location,
                                                                          "usertype":
                                                                              usertype
                                                                        });
                                                                      }
                                                                      if (usertype ==
                                                                          "entrepreneur") {
                                                                        FirebaseFirestore
                                                                            .instance
                                                                            .collection('Entrepreneur')
                                                                            .document(auth.currentUser.uid)
                                                                            .setData({
                                                                          "name":
                                                                              nameChange.text,
                                                                          "tagline":
                                                                              taglineChange.text,
                                                                          "websiteurl":
                                                                              websiteUrlChnage.text,
                                                                          "uid": auth
                                                                              .currentUser
                                                                              .uid,
                                                                          "location":
                                                                              location,
                                                                          "usertype":
                                                                              usertype
                                                                        });
                                                                      }
                                                                    },
                                                                    style: TextStyle(
                                                                        color: Color(
                                                                            0xFF3D4254),
                                                                        fontSize:
                                                                            55,
                                                                        fontFamily:
                                                                            "good"),
                                                                  ),
                                                                ),
                                                              ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 20,
                                                  ),
                                                  if (currentusertype !=
                                                      "entrepreneur")
                                                    (widget.uidforprofile !=
                                                            auth.currentUser.uid
                                                        ? isfollower == "no"
                                                            ? Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top: 35,
                                                                        right:
                                                                            10),
                                                                child: Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .topRight,
                                                                  child:
                                                                      GestureDetector(
                                                                    onTap: () {
                                                                      List<String>
                                                                          spiltList =
                                                                          name.split(
                                                                              " ");
                                                                      List<String>
                                                                          indexList =
                                                                          [];
                                                                      for (int i =
                                                                              0;
                                                                          i < spiltList.length;
                                                                          i++) {
                                                                        for (int j =
                                                                                0;
                                                                            j < spiltList[i].length + i;
                                                                            j++) {
                                                                          indexList.add(spiltList[i]
                                                                              .substring(0, j)
                                                                              .toLowerCase());
                                                                        }
                                                                      }
                                                                      Firestore
                                                                          .instance
                                                                          .collection(
                                                                              "Users")
                                                                          .document(auth
                                                                              .currentUser
                                                                              .uid)
                                                                          .collection(
                                                                              "following")
                                                                          .document(
                                                                              widget.uidforprofile)
                                                                          .setData({
                                                                        "location":
                                                                            location,
                                                                        "name":
                                                                            name,
                                                                        "tagline":
                                                                            tagline,
                                                                        "usertype":
                                                                            usertype,
                                                                        "websiteurl":
                                                                            websiteurl,
                                                                        "uid": auth
                                                                            .currentUser
                                                                            .uid,
                                                                        "uid_entrepreneur":
                                                                            widget.uidforprofile,
                                                                        "searchkey":
                                                                            indexList
                                                                      }).then((value) {
                                                                        print(
                                                                            "done");
                                                                        setState(
                                                                            () {
                                                                          _nowuserdetails();
                                                                          _fetchUserinfoForSettingsPage();
                                                                          checkfollowerexists();
                                                                          checkfor_rentrepreneur();
                                                                        });
                                                                      });

                                                                      List<String>
                                                                          otherList =
                                                                          nowuser_name
                                                                              .split(" ");
                                                                      List<String>
                                                                          ndexList =
                                                                          [];
                                                                      for (int m =
                                                                              0;
                                                                          m < otherList.length;
                                                                          m++) {
                                                                        for (int f =
                                                                                0;
                                                                            f < otherList[m].length + m;
                                                                            f++) {
                                                                          ndexList.add(otherList[m]
                                                                              .substring(0, f)
                                                                              .toLowerCase());
                                                                        }
                                                                      }
                                                                      Firestore
                                                                          .instance
                                                                          .collection(
                                                                              "Users")
                                                                          .document(widget
                                                                              .uidforprofile)
                                                                          .collection(
                                                                              "followers")
                                                                          .add({
                                                                        "location":
                                                                            nowuser_dpurl,
                                                                        "name":
                                                                            nowuser_name,
                                                                        "tagline":
                                                                            nowuser_tagline,
                                                                        "usertype":
                                                                            nowuser_usertype,
                                                                        "websiteurl":
                                                                            nowuser_websiteurl,
                                                                        "uid": widget
                                                                            .uidforprofile,
                                                                        "investor_uid":
                                                                            nowuser_uid,
                                                                        "searchkey":
                                                                            ndexList
                                                                      }).then((value) {
                                                                        print(
                                                                            "done");
                                                                        setState(
                                                                            () {
                                                                          _nowuserdetails();
                                                                          _fetchUserinfoForSettingsPage();
                                                                          checkfollowerexists();
                                                                          checkfor_rentrepreneur();
                                                                        });
                                                                      });
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      width:
                                                                          120,
                                                                      height:
                                                                          30,
                                                                      decoration: BoxDecoration(
                                                                          gradient: LinearGradient(
                                                                              colors: [
                                                                                Colors.blue[400],
                                                                                Colors.blueAccent[700]
                                                                              ],
                                                                              begin: Alignment.centerLeft,
                                                                              end: Alignment.centerRight),
                                                                          borderRadius: BorderRadius.circular(10)),
                                                                      child:
                                                                          Align(
                                                                        alignment:
                                                                            Alignment.center,
                                                                        child:
                                                                            Text(
                                                                          "Follow",
                                                                          style: TextStyle(
                                                                              fontSize: 20,
                                                                              color: Colors.white,
                                                                              fontWeight: FontWeight.w500),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              )
                                                            : Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top: 35,
                                                                        right:
                                                                            13),
                                                                child: Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .topRight,
                                                                  child:
                                                                      GestureDetector(
                                                                    onTap: () {
                                                                      print(
                                                                          "jj");
                                                                      Firestore
                                                                          .instance
                                                                          .collection(
                                                                              "Users")
                                                                          .document(auth
                                                                              .currentUser
                                                                              .uid)
                                                                          .collection(
                                                                              "following")
                                                                          .where(
                                                                              'uid_entrepreneur',
                                                                              isEqualTo: widget.uidforprofile)
                                                                          .get()
                                                                          .then((value) {
                                                                        value
                                                                            .docs
                                                                            .forEach((element) {
                                                                          Firestore
                                                                              .instance
                                                                              .collection("Users")
                                                                              .document(auth.currentUser.uid)
                                                                              .collection("following")
                                                                              .doc(element.id)
                                                                              .delete()
                                                                              .then((value) => print("complete"));
                                                                        });
                                                                      }).then((value) {
                                                                        setState(
                                                                            () {
                                                                          _nowuserdetails();
                                                                          _fetchUserinfoForSettingsPage();
                                                                          checkfollowerexists();
                                                                          checkfor_rentrepreneur();
                                                                        });
                                                                      });

                                                                      Firestore
                                                                          .instance
                                                                          .collection(
                                                                              "Users")
                                                                          .document(widget
                                                                              .uidforprofile)
                                                                          .collection(
                                                                              "followers")
                                                                          .where(
                                                                              'investor_uid',
                                                                              isEqualTo: auth.currentUser.uid)
                                                                          .get()
                                                                          .then((value) {
                                                                        value
                                                                            .docs
                                                                            .forEach((element) {
                                                                          Firestore
                                                                              .instance
                                                                              .collection("Users")
                                                                              .document(widget.uidforprofile)
                                                                              .collection("followers")
                                                                              .doc(element.id)
                                                                              .delete()
                                                                              .then((value) => print("complete"));
                                                                        });
                                                                      }).then((value) {
                                                                        setState(
                                                                            () {
                                                                          _nowuserdetails();
                                                                          _fetchUserinfoForSettingsPage();
                                                                          checkfollowerexists();
                                                                          checkfor_rentrepreneur();
                                                                        });
                                                                      });
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      width:
                                                                          120,
                                                                      height:
                                                                          30,
                                                                      decoration: BoxDecoration(
                                                                          gradient: LinearGradient(
                                                                              colors: [
                                                                                Colors.blue[400],
                                                                                Colors.blueAccent[700]
                                                                              ],
                                                                              begin: Alignment.centerLeft,
                                                                              end: Alignment.centerRight),
                                                                          borderRadius: BorderRadius.circular(10)),
                                                                      child:
                                                                          Align(
                                                                        alignment:
                                                                            Alignment.center,
                                                                        child:
                                                                            Text(
                                                                          "Unfollow",
                                                                          style: TextStyle(
                                                                              fontSize: 20,
                                                                              color: Color(4278190106),
                                                                              fontWeight: FontWeight.w500),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              )
                                                        : Container())
                                                  else
                                                    Container()
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                top: 59,
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 13, top: 10),
                                                child: auth.currentUser.uid !=
                                                        widget.uidforprofile
                                                    ? StreamBuilder(
                                                        stream: Firestore
                                                            .instance
                                                            .collection('Users')
                                                            .document(
                                                                "${widget.uidforprofile}")
                                                            .snapshots(),
                                                        builder: (context,
                                                            snapshot) {
                                                          var userDocument =
                                                              snapshot.data;
                                                          return snapshot
                                                                      .data ==
                                                                  null
                                                              ? CircularProgressIndicator()
                                                              : Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .topLeft,
                                                                  child: Text(
                                                                    userDocument[
                                                                            "tagline"] ??
                                                                        "It may take some time....",
                                                                    style:
                                                                        TextStyle(
                                                                      color: Color(
                                                                              0xFF3D4254)
                                                                          .withOpacity(
                                                                              1),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      fontSize:
                                                                          15,
                                                                    ),
                                                                  ),
                                                                );
                                                        })
                                                    : Container(
                                                        width: 320,
                                                        child: TextFormField(
                                                          controller:
                                                              taglineChange,
                                                          style: TextStyle(
                                                            color: Color(
                                                                    0xFF3D4254)
                                                                .withOpacity(1),
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize: 15,
                                                          ),
                                                          onChanged:
                                                              (val) async {
                                                            print(auth
                                                                .currentUser
                                                                .uid);
                                                            await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'Users')
                                                                .document(auth
                                                                    .currentUser
                                                                    .uid)
                                                                .setData({
                                                              "name": nameChange
                                                                  .text,
                                                              "tagline":
                                                                  taglineChange
                                                                      .text,
                                                              "websiteurl":
                                                                  websiteUrlChnage
                                                                      .text,
                                                              "location":
                                                                  location,
                                                              "usertype":
                                                                  usertype,
                                                              "uid": auth
                                                                  .currentUser
                                                                  .uid
                                                            }).then((value) =>
                                                                    print(
                                                                        "done"));
                                                            if (usertype ==
                                                                "investor") {
                                                              FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'Investor')
                                                                  .document(auth
                                                                      .currentUser
                                                                      .uid)
                                                                  .setData({
                                                                "name":
                                                                    nameChange
                                                                        .text,
                                                                "tagline":
                                                                    taglineChange
                                                                        .text,
                                                                "websiteurl":
                                                                    websiteUrlChnage
                                                                        .text,
                                                                "usertype":
                                                                    usertype,
                                                                "location":
                                                                    location,
                                                                "uid": auth
                                                                    .currentUser
                                                                    .uid
                                                              });
                                                            }
                                                            if (usertype ==
                                                                "entrepreneur") {
                                                              FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'Entrepreneur')
                                                                  .document(auth
                                                                      .currentUser
                                                                      .uid)
                                                                  .setData({
                                                                "name":
                                                                    nameChange
                                                                        .text,
                                                                "tagline":
                                                                    taglineChange
                                                                        .text,
                                                                "websiteurl":
                                                                    websiteUrlChnage
                                                                        .text,
                                                                "location":
                                                                    location,
                                                                "uid": auth
                                                                    .currentUser
                                                                    .uid,
                                                                "usertype":
                                                                    usertype
                                                              });
                                                            }
                                                          },
                                                          decoration:
                                                              InputDecoration(
                                                                  border:
                                                                      InputBorder
                                                                          .none),
                                                        ),
                                                      ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                          top: auth.currentUser.uid ==
                                                  widget.uidforprofile
                                              ? 0
                                              : 10,
                                        ),
                                        child: Padding(
                                          padding:
                                              EdgeInsets.only(left: 10, top: 0),
                                          child: Row(
                                            children: [
                                              Image.asset("assets/web.png"),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              auth.currentUser.uid !=
                                                      widget.uidforprofile
                                                  ? StreamBuilder(
                                                      stream: Firestore.instance
                                                          .collection('Users')
                                                          .document(
                                                              "${widget.uidforprofile}")
                                                          .snapshots(),
                                                      builder:
                                                          (context, snapshot) {
                                                        var userDocument =
                                                            snapshot.data;
                                                        return snapshot.data ==
                                                                null
                                                            ? CircularProgressIndicator()
                                                            : Text(
                                                                userDocument[
                                                                    "websiteurl"],
                                                                style:
                                                                    TextStyle(
                                                                  color: Color(
                                                                          0xFF3D4254)
                                                                      .withOpacity(
                                                                          1),
                                                                  fontSize: 15,
                                                                ),
                                                              );
                                                      })
                                                  : Container(
                                                      width: 300,
                                                      child: TextFormField(
                                                        controller:
                                                            websiteUrlChnage,
                                                        style: TextStyle(
                                                          color: Color(
                                                                  0xFF3D4254)
                                                              .withOpacity(1),
                                                          fontSize: 15,
                                                        ),
                                                        onChanged: (val) async {
                                                          print(auth
                                                              .currentUser.uid);
                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'Users')
                                                              .document(auth
                                                                  .currentUser
                                                                  .uid)
                                                              .setData({
                                                            "name":
                                                                nameChange.text,
                                                            "tagline":
                                                                taglineChange
                                                                    .text,
                                                            "websiteurl":
                                                                websiteUrlChnage
                                                                    .text,
                                                            "location":
                                                                location,
                                                            "uid": auth
                                                                .currentUser
                                                                .uid,
                                                            "usertype": usertype
                                                          }).then((value) =>
                                                                  print(
                                                                      "done"));
                                                          if (usertype ==
                                                              "investor") {
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'Investor')
                                                                .document(auth
                                                                    .currentUser
                                                                    .uid)
                                                                .setData({
                                                              "name": nameChange
                                                                  .text,
                                                              "tagline":
                                                                  taglineChange
                                                                      .text,
                                                              "websiteurl":
                                                                  websiteUrlChnage
                                                                      .text,
                                                              "location":
                                                                  location,
                                                              "uid": auth
                                                                  .currentUser
                                                                  .uid,
                                                              "usertype":
                                                                  usertype
                                                            });
                                                          }
                                                          if (usertype ==
                                                              "entrepreneur") {
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'Entrepreneur')
                                                                .document(auth
                                                                    .currentUser
                                                                    .uid)
                                                                .setData({
                                                              "name": nameChange
                                                                  .text,
                                                              "tagline":
                                                                  taglineChange
                                                                      .text,
                                                              "websiteurl":
                                                                  websiteUrlChnage
                                                                      .text,
                                                              "location":
                                                                  location,
                                                              "uid": auth
                                                                  .currentUser
                                                                  .uid,
                                                              "usertype":
                                                                  usertype
                                                            });
                                                          }
                                                        },
                                                        decoration:
                                                            InputDecoration(
                                                                border:
                                                                    InputBorder
                                                                        .none),
                                                      ),
                                                    ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10, left: 40),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Container(
                                                width: 120,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    color: Colors.white),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      15.0),
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        connectionlenght ?? "0",
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xFF3D4254),
                                                            fontSize: 30,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                      Opacity(
                                                          opacity: 0.9,
                                                          child: Text(
                                                            "Connections",
                                                            style: TextStyle(
                                                              color: Color(
                                                                  0xFF3D4254),
                                                            ),
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                width: 120,
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20)),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      15.0),
                                                  child: Column(
                                                    children: [
                                                      no_ofposts == null
                                                          ? Text(
                                                              "0",
                                                              style: TextStyle(
                                                                  color: Color(
                                                                      0xFF3D4254),
                                                                  fontSize: 30,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            )
                                                          : Text(
                                                              "$no_ofposts",
                                                              style: TextStyle(
                                                                  color: Color(
                                                                      0xFF3D4254),
                                                                  fontSize: 30,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                      Opacity(
                                                          opacity: 0.9,
                                                          child: Text(
                                                            "Pitches",
                                                            style: TextStyle(
                                                              color: Color(
                                                                  0xFF3D4254),
                                                            ),
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 30,
                                              ),
                                            ]),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, bottom: 0),
                                        child: GradientText(
                                          text: " Pitches",
                                          colors: [
                                            Colors.blue[400],
                                            Colors.blue[700]
                                          ],
                                          style: TextStyle(
                                              fontSize: 55,
                                              fontFamily: "good",
                                              color: Colors.white),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.bottomCenter,
                                        child: StreamBuilder(
                                            stream: Firestore.instance
                                                .collection("Users")
                                                .document(widget.uidforprofile)
                                                .collection("posts")
                                                .orderBy("date",
                                                    descending: true)
                                                .snapshots(),
                                            builder: (context, snapshot) {
                                              if (!snapshot.hasData)
                                                return Text('Loading... data');
                                              return snapshot.data != null
                                                  ? ListView.separated(
                                                      reverse: true,
                                                      separatorBuilder: (ctx,
                                                              i) =>
                                                          SizedBox(height: 20),
                                                      shrinkWrap: true,
                                                      physics:
                                                          NeverScrollableScrollPhysics(),
                                                      itemCount: snapshot.data
                                                          .documents.length,
                                                      itemBuilder: (ctx, i) {
                                                        DocumentSnapshot
                                                            course = snapshot
                                                                .data
                                                                .documents[i];

                                                        return snapshot.data ==
                                                                null
                                                            ? Container(
                                                                width: 20,
                                                                height: 20,
                                                              )
                                                            : Align(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left: 15,
                                                                      right: 15,
                                                                      top: 20),
                                                                  child:
                                                                      Container(
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            gradient:
                                                                                LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [
                                                                              Color(4280311451).withOpacity(0.4),
                                                                              Color(4278547942).withOpacity(0.4),
                                                                            ]),
                                                                            borderRadius:
                                                                                BorderRadius.circular(20),
                                                                          ),
                                                                          child:
                                                                              Stack(alignment: Alignment.center, children: [
                                                                            Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: Column(
                                                                                children: [
                                                                                  Padding(
                                                                                    padding: const EdgeInsets.only(top: 1, left: 10),
                                                                                    child: Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: [
                                                                                        Container(
                                                                                            child: Row(
                                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                          children: [
                                                                                            StreamBuilder(
                                                                                                stream: Firestore.instance.collection("Users").document(course["uid"]).snapshots(),
                                                                                                builder: (ctx, i) {
                                                                                                  return i.data == null
                                                                                                      ? Container(width: 20, height: 20)
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
                                                                                          padding: const EdgeInsets.all(8.0),
                                                                                          child: Container(
                                                                                            width: 50,
                                                                                            height: 50,
                                                                                            decoration: BoxDecoration(
                                                                                              borderRadius: BorderRadius.circular(10),
                                                                                              color: Colors.white.withOpacity(0.12),
                                                                                            ),
                                                                                            child: Padding(
                                                                                              padding: const EdgeInsets.only(top: 5),
                                                                                              child: Column(
                                                                                                children: [
                                                                                                  Padding(
                                                                                                    padding: const EdgeInsets.only(top: 5),
                                                                                                    child: Text(
                                                                                                      course["day"],
                                                                                                      style: GoogleFonts.poppins(fontSize: 15, height: 1, fontWeight: FontWeight.w600, color: Colors.white),
                                                                                                    ),
                                                                                                  ),
                                                                                                  SizedBox(
                                                                                                    height: 3,
                                                                                                  ),
                                                                                                  Text(
                                                                                                    course["month"],
                                                                                                    style: GoogleFonts.poppins(height: 1, fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white),
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
                                                                                    padding: const EdgeInsets.only(left: 10, right: 10),
                                                                                    child: Material(
                                                                                      borderRadius: BorderRadius.only(
                                                                                        topLeft: Radius.circular(5),
                                                                                        bottomRight: Radius.circular(5),
                                                                                        topRight: Radius.circular(20),
                                                                                        bottomLeft: Radius.circular(20),
                                                                                      ),
                                                                                      elevation: 3,
                                                                                      child: Stack(
                                                                                        alignment: Alignment.center,
                                                                                        children: [
                                                                                          Hero(
                                                                                            tag: "dssd+$i",
                                                                                            child: Material(
                                                                                                borderRadius: BorderRadius.only(
                                                                                                  topLeft: Radius.circular(5),
                                                                                                  bottomRight: Radius.circular(5),
                                                                                                  topRight: Radius.circular(20),
                                                                                                  bottomLeft: Radius.circular(20),
                                                                                                ),
                                                                                                elevation: 20,
                                                                                                child: Container(
                                                                                                  height: 170,
                                                                                                  decoration: BoxDecoration(
                                                                                                      borderRadius: BorderRadius.only(
                                                                                                        topLeft: Radius.circular(5),
                                                                                                        bottomRight: Radius.circular(5),
                                                                                                        topRight: Radius.circular(20),
                                                                                                        bottomLeft: Radius.circular(20),
                                                                                                      ),
                                                                                                      image: course["postimage"] != null ? DecorationImage(image: NetworkImage(course["postimage"]), fit: BoxFit.cover) : DecorationImage(image: AssetImage("assets/unknown.png"))),
                                                                                                )),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(
                                                                                    height: 10,
                                                                                  ),
                                                                                  Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                    children: [
                                                                                      Row(
                                                                                        children: [
                                                                                          Image.asset(
                                                                                            "assets/heart.png",
                                                                                            color: Color(4290118716),
                                                                                            scale: 10,
                                                                                          ),
                                                                                          Text(
                                                                                            "${course["likes"]}",
                                                                                            style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white.withOpacity(1)),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                      SizedBox(
                                                                                        width: 0,
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.only(right: 0),
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
                                                                                      auth.currentUser.uid == widget.uidforprofile
                                                                                          ? IconButton(
                                                                                              icon: Icon(
                                                                                                Icons.delete_rounded,
                                                                                                color: Colors.white,
                                                                                                size: 22,
                                                                                              ),
                                                                                              onPressed: () {
                                                                                                setState(() {
                                                                                                  documentid = course.documentID.toString();
                                                                                                });
                                                                                                print(documentid);
                                                                                                Firestore.instance.collection("Users").document(widget.uidforprofile).collection("posts").document(documentid).delete().then((value) {
                                                                                                  Firestore.instance.collection("Feed").document(documentid).delete();
                                                                                                });
                                                                                              })
                                                                                          : Container(
                                                                                              width: 0,
                                                                                              height: 0,
                                                                                            ),
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
                                                                                                    builder: (_) => FeedDetilsForEntrepreneurs(documnetid: course.documentID, id: widget.uidforprofile, url: course["video_url"], d: i),
                                                                                                  ));
                                                                                            },
                                                                                            child: Container(
                                                                                              alignment: Alignment.center,
                                                                                              width: 100,
                                                                                              height: 30,
                                                                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.white.withOpacity(0.3)),
                                                                                              child: Text(
                                                                                                "Learn More",
                                                                                                style: TextStyle(
                                                                                                  fontSize: 22,
                                                                                                  fontFamily: "good",
                                                                                                  fontWeight: FontWeight.w300,
                                                                                                  color: Colors.white,
                                                                                                ),
                                                                                              ),
                                                                                            )),
                                                                                      )
                                                                                    ],
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            )
                                                                          ])),
                                                                ),
                                                              );
                                                      })
                                                  : Container(
                                                      width: 20,
                                                      height: 30,
                                                    );
                                            }),
                                      ),
                                      SizedBox(
                                        height: 30,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ));
  }

  String documentid;
}

class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var rect = Offset.zero & size;

    Paint paint = new Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomLeft,
        colors: [
          Colors.white.withOpacity(0.17),
          Colors.white.withOpacity(0.27),
        ],
      ).createShader(rect)
      ..style = PaintingStyle.fill
      ..strokeWidth = 1.48;

    Path path = Path();
    path.moveTo(0, size.height * 0.72);
    path.quadraticBezierTo(size.width * 0.20, size.height * 0.42,
        size.width * 0.45, size.height * 0.64);
    path.cubicTo(size.width * 0.71, size.height * 0.94, size.width * 0.94,
        size.height * 0.62, size.width, size.height);
    path.quadraticBezierTo(
        size.width * 1.10, size.height * 0.78, size.width, 0);
    path.lineTo(0, 0);
    path.lineTo(0, size.height * 0.72);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
