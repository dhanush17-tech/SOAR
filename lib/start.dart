import 'package:SOAR/screens/chat/chat_home.dart';
import 'package:SOAR/screens/chat/text_screen.dart';

import 'package:SOAR/screens/feed.dart';
import 'package:SOAR/screens/post/post_image.dart';
import 'package:SOAR/screens/profile.dart';
import 'package:SOAR/screens/settings_page.dart';
import 'package:flutter/material.dart';
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
        dpurl = value.data()["dpurl"];
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
  Widget build(BuildContext context) {
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
              buildsidenavigationabar()
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
      child: Padding(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildOption(
                Icon(
                  Icons.home,
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
                  Icons.add,
                ),
                2),
            buildOption(
                Icon(
                  Icons.person,
                ),
                3),
            buildOption(
                Icon(
                  Icons.message,
                ),
                4),
          ],
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
          height: 15,
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

  var selectedOption = 0;
  List alloptions = [
    Feed(),
    SettingsPage(),
    PostImage(),
    Profile(
      uidforprofile: auth.currentUser.uid,
    ),
    ChatScreen()
  ];

  List isselected = [true, false, false, false, false];
}
