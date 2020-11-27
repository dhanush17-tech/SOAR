import 'package:SOAR/auth/record.dart';
import 'package:SOAR/screens/chat/chat_home.dart';
import 'package:SOAR/screens/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'feed_details.dart';
import 'movivation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:SOAR/model/user_model.dart';

class Feed extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {});
    print(auth.currentUser.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(4278190106),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 10, top: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Material(
                      type: MaterialType.transparency,
                      child: Text(
                        "Top Pitches",
                        style: GoogleFonts.poppins(
                            color: Color(4278228470),
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 13),
                      child: Container(
                        height: 40,
                        width: 110,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Color(4278228470),
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Hero(
                              tag: "arrow",
                              child: FittedBox(
                                child: Container(
                                  height: 35,
                                  width: 35,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(4278190106),
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                              transitionDuration:
                                                  Duration(milliseconds: 700),
                                              pageBuilder: (ctx, ani, i) =>
                                                  ChatScreen()));
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 3, left: 3, bottom: 3, right: 3),
                                      child: Icon(
                                        Icons.message_outlined,
                                        color: Color(4278228470),
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            FittedBox(
                              child: Container(
                                height: 35,
                                width: 35,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(4278190106),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                              transitionDuration:
                                                  Duration(milliseconds: 700),
                                              pageBuilder: (ctx, ani, i) =>
                                                  SettingsPage()));
                                    },
                                    child: Hero(
                                      tag: "motivational",
                                      child: Image.asset(
                                        "assets/idea.png",
                                        color: Color(4278228470),
                                        height: 19,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
                child: Align(
                  alignment: Alignment.center,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(26),
                    child: Container(
                        height: 203,
                        width: 350,
                        decoration: BoxDecoration(
                          color: Color(4280099132),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        alignment: Alignment.center, // where to p
                        child: Stack(
                          children: [
                            GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => FeedDetails()));
                                },
                                child: Hero(
                                    tag: "mannna",
                                    child: Container(
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  "assets/upload.jpg"),
                                              fit: BoxFit.fill)),
                                    ))),
                            Padding(
                              padding: EdgeInsets.only(left: 10, bottom: 13),
                              child: Align(
                                alignment: Alignment.bottomLeft,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "ScanIn - Scanner",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontSize: 40,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "good",
                                          color: Colors.white),
                                    ),
                                    Text(
                                      "12/12/20",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Color(4278228470)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    transitionDuration:
                                        Duration(milliseconds: 700),
                                    pageBuilder: (_, __, ___) => FeedDetails(),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 10, right: 10),
                                child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: Container(
                                      width: 80,
                                      height: 30,
                                      decoration: BoxDecoration(
                                          color: Color(4278190106),
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            "Proceed",
                                            style: GoogleFonts.poppins(
                                                fontSize: 13,
                                                color: Color(4278228470),
                                                fontWeight: FontWeight.bold),
                                          ))),
                                ),
                              ),
                            )
                          ],
                        )),
                  ),
                )),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}

FirebaseAuth auth = FirebaseAuth.instance;
String imageurl = auth.currentUser.photoURL.toString();
