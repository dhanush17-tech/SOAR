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
  runApp(SettingsPage());
}

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with SingleTickerProviderStateMixin {
  TextEditingController nameChange = TextEditingController();
  TextEditingController websiteUrlChnage = TextEditingController();
  TextEditingController taglineChange = TextEditingController();

  Future<void> _fetchUserinfoForSettingsPage() async {
    try {
      await Firestore.instance
          .collection("Users")
          .document(auth.currentUser.uid)
          .get()
          .then((value) {
        if (value.exists) {
          setState(() {
            nameChange.text = value.data()["name"];
            websiteUrlChnage.text = value.data()["websiteurl"];
            taglineChange.text = value.data()["tagline"];
            location = value.data()["location"];
            usertype = value.data()["usertype"];
          });
        }
      });
    } catch (e) {}
  }

  String usertype;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchUserinfoForSettingsPage();
    _controller = AnimationController(vsync: this, duration: duration);
    _scaleAnimation = Tween<double>(begin: 1, end: 0.8).animate(_controller);
    _menuScaleAnimation =
        Tween<double>(begin: 0.5, end: 1).animate(_controller);
    _slideAnimation = Tween<Offset>(begin: Offset(-1, 0), end: Offset(0, 0))
        .animate(_controller);
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

  bool isCollapsed = true;

  final Duration duration = const Duration(milliseconds: 300);
  AnimationController _controller;
  Animation<double> _scaleAnimation;
  Animation<double> _menuScaleAnimation;
  Animation<Offset> _slideAnimation;

  bool isDrawerOpen = false;



  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);

    return Scaffold(
      backgroundColor: Color(0xFFE6EDFA).withOpacity(1),
        body: Stack(
          children: [
            usertype == "entrepreneur" ? (context) : Container(),
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
                      scrollDirection: Axis.vertical,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 30, left: 15, right: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Align(
                                    alignment: Alignment.topLeft,
                                    child: GradientText(
                                      text: "Hello there",
                                      colors: [
                                        Colors.indigo,
                                        Colors.blue
                                      ],
                                      style: GoogleFonts.poppins(
                                        fontSize: 35,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    )),
                                Align(
                                  alignment: Alignment.topRight,
                                  child:   usertype == "entrepreneur" ? isCollapsed
                                      ? Padding(
                                          padding: EdgeInsets.only(
                                              bottom: 0, right: 0),
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
                                          )):Container(),
                                ),
                              ],
                            ),
                          ),
                          StreamBuilder(
                            stream: Firestore.instance
                                .collection("motivation")
                                .snapshots(),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              return snapshot.data == null
                                  ? Container()
                                  : ListView.builder(
                                      itemCount: snapshot.data.documents.length,
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        var moti =
                                            snapshot.data.documents[index];
                                        print(moti.documentID);
                                        return Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20.0, right: 20, top: 0),
                                            child: GestureDetector(
                                                onTap: () {
                                                  if (moti["type"] == "promo") {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (_) =>
                                                                PromoVideo(
                                                                  id: moti
                                                                      .documentID,
                                                                  url: moti[
                                                                      "url"],
                                                                )));
                                                  } else
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (_) =>
                                                                MotivationHome(
                                                                  moti["url"],
                                                                  moti.documentID,
                                                                )));
                                                },
                                                child: Hero(
                                                  tag: "dd+$index",
                                                  child: Container(
                                                    width: 360,
                                                    height: 350,
                                                    child: Stack(
                                                      children: [
                                                        Container(
                                                          width: 360,
                                                          height: 350,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        16),
                                                            color: Colors.white,
                                                          ),
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        16),
                                                            child:
                                                                Image.network(
                                                              moti["thumbnail"],
                                                              fit: BoxFit.cover,
                                                              width: 190,
                                                              height: 250,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )));
                                      },
                                    );
                            },
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

  SharedPreferences prefs;

  Future<Null> _logoutUser() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final FacebookLogin facebookLogIn = FacebookLogin();
    await facebookLogIn.logOut();
    await googleSignIn.signOut();

    prefs = await SharedPreferences.getInstance();
    await prefs.remove("useremail");
    await prefs.commit();
  }

  Future _signOut() async {
    _logoutUser().then((value) {
      print("done");
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Loginscreen()));
    });
  }
}
