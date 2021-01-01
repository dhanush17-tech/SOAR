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
import 'auth/login.dart';
import 'screens/chat/chat_home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Start extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StartApp(),
    );
  }
}

class StartApp extends StatefulWidget {
  @override
  _StartAppState createState() => _StartAppState();
}

class _StartAppState extends State<StartApp> {
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
    fetchcurrentuserdetails();
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
    prefs.clear();
    prefs.commit();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);

    var screenheight = MediaQuery.of(context).size.height;
    var screenwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(4278190106),
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
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
    return ClipRRect(
         borderRadius: BorderRadius.only(
                topLeft: Radius.circular(
                  20,
                ),
                topRight: Radius.circular(20)),
          child: Container(
        height: 80,
        decoration: BoxDecoration(
     image: DecorationImage(
                image: AssetImage("assets/backpng.png"), fit: BoxFit.fill),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(
                  20,
                ),
                topRight: Radius.circular(20))),
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildOption(
                        Icon(
                          Icons.person,
                          color: Colors.blue,
                        ),
                        0),
                    buildOption(
                        Icon(
                          Icons.settings,
                        ),
                        1),
                    buildOption(
                        Icon(
                          Icons.home,
                        ),
                        2),
                    buildOption(
                        Icon(
                          Icons.message,
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
              color:isselected[index]
            ?Colors.white.withOpacity(0.9):Colors.blue,
              size: 27,
            )),
        SizedBox(
          height: 15,
        ),
        isselected[index]
            ? Container(
                height: 2,
                width: 2,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    
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
    Profile(
      uidforprofile: auth.currentUser.uid,
    ),
    SettingsPage(),
    Feed(),
    ChatScreen(),
    Stories()
  ];

  List isselected = [
    false,
    false,
    true,
    false,
    false,
  ];
}
