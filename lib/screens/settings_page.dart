import 'package:SOAR/screens/feed.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:SOAR/auth/login.dart';
import 'package:firebase_storage/firebase_storage.dart';

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
        backgroundColor: Color(4278190106),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 30,
              ),
              Text(" Edit Profile",
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 35,
                      color: Colors.white)),
              SizedBox(
                height: 20,
              ),
              location == null
                  ? GestureDetector(
                      onTap: () async {
                        await uploadProfilePicture();
                      },
                      child: Center(
                        child: Container(
                          width: 200,
                          height: 200,
                          child: Stack(
                            children: [
                              AvatarGlow(
                                glowColor: Color(4278228470),
                                endRadius: 200.0,
                                duration: Duration(milliseconds: 3000),
                                repeat: true,
                                showTwoGlows: true,
                                child: Material(
                                  elevation: 8.0,
                                  shape: CircleBorder(),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.grey,
                                    backgroundImage: AssetImage(
                                      "assets/unknown.png",
                                    ),
                                    radius: 70.0,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 20,
                                left: 130,
                                child: FittedBox(
                                  child: Container(
                                    width: 45,
                                    height: 45,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.blue,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.5),
                                          spreadRadius: 10,
                                          blurRadius: 20,
                                          offset: Offset(0,
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
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : GestureDetector(
                      onTap: () async {
                        await uploadProfilePicture();
                      },
                      child: Center(
                        child: Container(
                          width: 200,
                          height: 200,
                          child: Stack(
                            children: [
                              AvatarGlow(
                                glowColor: Color(4278228470),
                                endRadius: 200.0,
                                duration: Duration(milliseconds: 3000),
                                repeat: true,
                                showTwoGlows: true,
                                child: Material(
                                  elevation: 8.0,
                                  shape: CircleBorder(),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.grey,
                                    backgroundImage: NetworkImage(location),
                                    radius: 70.0,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 20,
                                left: 130,
                                child: FittedBox(
                                  child: Container(
                                    width: 45,
                                    height: 45,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.blue,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.5),
                                          spreadRadius: 10,
                                          blurRadius: 20,
                                          offset: Offset(0,
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
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text('Full Name',
                    style: GoogleFonts.poppins(
                      color: Colors.grey,
                      fontWeight: FontWeight.w400,
                      fontSize: 17,
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Center(
                  child: Container(
                    width: 360,
                    child: new TextFormField(
                        autofocus: false,
                        controller: nameChange,
                        style: GoogleFonts.poppins(
                            height: 1.02, color: Colors.white, fontSize: 20),
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(4278228470)),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(4278228470)),
                          ),
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(4278228470)),
                          ),
                        )),
                  ),
                ),
              ),
              SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text('Website URL',
                    style: GoogleFonts.poppins(
                      color: Colors.grey,
                      fontWeight: FontWeight.w400,
                      fontSize: 17,
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: TextFormField(
                    controller: websiteUrlChnage,
                    style: GoogleFonts.poppins(
                        height: 1.02, color: Colors.white, fontSize: 20),
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(4278228470)),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(4278228470)),
                      ),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(4278228470)),
                      ),
                    )),
              ),
              SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text('Profession',
                    style: GoogleFonts.poppins(
                      color: Colors.grey,
                      fontWeight: FontWeight.w400,
                      fontSize: 17,
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Center(
                  child: Container(
                    width: 360,
                    child: new TextFormField(
                        controller: taglineChange,
                        style: GoogleFonts.poppins(
                            height: 1.02, color: Colors.white, fontSize: 20),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        )),
                  ),
                ),
              ),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: GestureDetector(
                    onTap: () async {
                      print(auth.currentUser.uid);
                      await FirebaseFirestore.instance
                          .collection('Users')
                          .document(auth.currentUser.uid)
                          .setData({
                        "name": nameChange.text,
                        "tagline": taglineChange.text,
                        "websiteurl": websiteUrlChnage.text,
                        "location": location,
                        "uid": auth.currentUser.uid,
                        "usertype": usertype
                      }).then((value) => print("done"));
                      if (usertype == "investor") {
                        FirebaseFirestore.instance
                            .collection('Investor')
                            .document(auth.currentUser.uid)
                            .setData({
                          "name": nameChange.text,
                          "tagline": taglineChange.text,
                          "websiteurl": websiteUrlChnage.text,
                          "location": location,
                          "uid": auth.currentUser.uid,
                          "usertype": usertype
                        });
                      }
                      if (usertype == "entrepreneur") {
                        FirebaseFirestore.instance
                            .collection('Entrepreneur')
                            .document(auth.currentUser.uid)
                            .setData({
                          "name": nameChange.text,
                          "tagline": taglineChange.text,
                          "websiteurl": websiteUrlChnage.text,
                          "location": location,
                          "uid": auth.currentUser.uid,
                          "usertype": usertype
                        });
                      }
                    },
                    child: Container(
                      width: 160,
                      height: 40,
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Color(4278228470),
                          ),
                          borderRadius: BorderRadius.circular(14)),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Save",
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                              color: Color(4278228470)),
                        ),
                      ),
                    ),
                  ),
                ),
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
