import 'package:SOAR/auth/login.dart';
import 'package:SOAR/screens/chat/chat_home.dart';
import 'package:SOAR/screens/chat/text_screen.dart';
import 'package:SOAR/screens/stories.dart';
import 'package:SOAR/screens/feed.dart';
import 'package:SOAR/screens/post/post_image.dart';
import 'package:SOAR/screens/profile.dart';
import 'package:SOAR/screens/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class StartEnt extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StartEntrepreneur(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class StartEntrepreneur extends StatefulWidget {
  @override
  _StartEntrepreneurState createState() => _StartEntrepreneurState();
}

class _StartEntrepreneurState extends State<StartEntrepreneur> {
  Future _signOut() async {
    _logoutUser().then((value) {
      print("done");
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Loginscreen()));
    });
  }

  String usertype;

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
    fetchcurrentuserdetails();
  }

  @override
  Widget build(BuildContext context) { SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);

    return Scaffold(
      backgroundColor: Color(4278190106),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        child: Container(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * .93,
                child: alloptions[selectedOption],
              ),
              buildsidenavigationabar(),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10, left: 10),
                child: GestureDetector(
                  onTap: () {
                    _signOut();
                  },
                  child: Container(
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
                              fontWeight: FontWeight.w600,
                              color: Colors.red),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  buildsidenavigationabar() {
    return Container(
      height: 60,
      decoration: BoxDecoration(
          color: Color(4279899448),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(
                20,
              ),
              topRight: Radius.circular(20))),
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildOption(
                      Icon(
                        Icons.settings,
                      ),
                      0),
                  buildOption(
                      Icon(
                        Icons.add,
                      ),
                      1),
                  buildOption(
                      Icon(
                        Icons.message,
                      ),
                      2),
                  buildOption(
                      Icon(
                        Icons.person,
                      ),
                      3),
                  buildOption(
                      Icon(
                        Icons.near_me,
                      ),
                      4),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  buildOption(Icon man, int index) {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        GestureDetector(
            onTap: () {
              setState(() {
                selectedOption = index;
                isSelectedOption(index);
              });
            },
            child: Icon(
              man.icon,
              color: Colors.blue,
              size: 27,
            )),
        SizedBox(
          height: 10,
        ),
        isselected[index]
            ? Container(
                height: 2,
                width: 2,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.blue,
                          blurRadius: 6.0,
                          spreadRadius: 10.0,
                          offset: Offset(
                            0.0,
                            3.0,
                          ),
                        ),
                    ]),
              )
            : Container(
                height: 8,
                width: 8,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Colors.transparent)),
      ],
    );
  }

  isSelectedOption(index) {
    var previousIndex = isselected.indexOf(true);
    isselected[index] = true;
    isselected[previousIndex] = false;
  }

  var selectedOption = 2;
  List alloptions = [
    SettingsPage(),
    PostImage(),
    ChatScreen(),
    Profile(
      uidforprofile: auth.currentUser.uid,
    ),
    Stories()
  ];

  List isselected = [false, false, true, false, false];
}
