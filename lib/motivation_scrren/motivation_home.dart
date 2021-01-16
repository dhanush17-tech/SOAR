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
import 'package:easy_gradient_text/easy_gradient_text.dart';
import 'package:firebase_storage/firebase_storage.dart';
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

class _SettingsPageState extends State<SettingsPage> {
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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);

    return Scaffold(
        backgroundColor: Color(4280032553),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 35, left: 15, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: GradientText(
                        text: "Trending",
                        colors: [Colors.blue[400], Colors.blue[700]],
                        style: GoogleFonts.poppins(
                          fontSize: 35,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Align(
                        alignment: Alignment.topRight,
                        child: Container(
                            child: Row(
                          children: [
                            location == null
                                ? Align(
                                    alignment: Alignment.topRight,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 110),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) => Profile(
                                                        uidforprofile: auth
                                                            .currentUser.uid,
                                                      )));
                                        },
                                        child: CircleAvatar(
                                          backgroundColor: Color(4278272638),
                                          backgroundImage: AssetImage(
                                            "assets/unknown.png",
                                          ),
                                          radius: 25,
                                        ),
                                      ),
                                    ),
                                  )
                                : Align(
                                    alignment: Alignment.topRight,
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => Profile(
                                                      uidforprofile:
                                                          auth.currentUser.uid,
                                                    )));
                                      },
                                      child: Center(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 110),
                                          child: CircleAvatar(
                                            backgroundColor: Color(4278272638),
                                            backgroundImage: NetworkImage(
                                              location,
                                            ),
                                            radius: 25,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                          ],
                        ))),
                  ],
                ),
              ),
              StreamBuilder(
                stream: Firestore.instance.collection("motivation").snapshots(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  return snapshot.data == null
                      ? Container()
                      : ListView.builder(
                          itemCount: snapshot.data.documents.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            var moti = snapshot.data.documents[index];
                            print(moti.documentID);
                            return Padding(
                                padding: const EdgeInsets.only(
                                    left: 20.0, right: 20, top: 40),
                                child: GestureDetector(
                                    onTap: () {
                                      if (moti["type"] == "promo") {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => PromoVideo(
                                                      id: moti.documentID,
                                                      url: moti["url"],
                                                    )));
                                      } else
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => MotivationHome(
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
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                color: Colors.white,
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                child: Image.network(
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
        ));
  }

  SharedPreferences prefs;

  Future<Null> _logoutUser() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final FacebookLogin facebookLogIn = FacebookLogin();
    await facebookLogIn.logOut();
    await googleSignIn.signOut();

    prefs = await SharedPreferences.getInstance();
    prefs.clear();
    prefs.commit();
  }

  Future _signOut() async {
    _logoutUser().then((value) {
      print("done");
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Loginscreen()));
    });
  }
}
