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
  runApp(HomeScreen());
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE6EDFA),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 40, left: 5, right: 15),
              child: Container(
                height: 130,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Color(0xFF4E82E8).withOpacity(1),
                      Color(0xFF5894FA).withOpacity(1),
                    ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                    borderRadius: BorderRadius.circular(20)),
                child: Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.only(left: 15),
                              child: Text(
                                "Hello Dhanush",
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20,
                                ),
                              ),
                            )),
                        SizedBox(height: 5),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: Text(
                                "Soar high with soar throw!",
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                ),
                              ),
                            )),
                      ],
                    ),
                    SizedBox(
                      width: 70,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Image.asset("assets/hello.png"),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Container(
                alignment: Alignment.topLeft,
                child: GradientText(
                  text: "Trending",
                  colors: [Colors.indigo, Colors.blue],
                  style: GoogleFonts.poppins(
                      fontSize: 28, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 10),
              child: Container(
                height: 300,
                width: MediaQuery.of(context).size.width,
                child: StreamBuilder(
                    stream:
                        Firestore.instance.collection("trending").snapshots(),
                    builder: (context, snapshot) {
                      return ListView.separated(
                        itemCount: snapshot.data.documents.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (ctx, i) {
                          DocumentSnapshot trending =
                              snapshot.data.documents[i];
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  gradient: LinearGradient(
                                      colors: [Color(0xFF4E82E8), Colors.blue]),
                                  image: DecorationImage(
                                      image: NetworkImage(
                                        trending["url"],
                                      ),
                                      fit: BoxFit.fill)),
                              width: 250.0,
                            ),
                          );
                        },
                        separatorBuilder: (context, index) =>
                            SizedBox(width: 10),
                      );
                    }),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Container(
                alignment: Alignment.topLeft,
                child: GradientText(
                  text: "Categories",
                  colors: [Colors.indigo, Colors.blue],
                  style: GoogleFonts.poppins(
                      fontSize: 28, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              height: 50,
              child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: [
                    GestureDetector(
                      onTap: () => controller.animateToPage(0,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeIn),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                              color: Color(0xFF5894FA).withOpacity(0.9),
                              borderRadius: BorderRadius.circular(15)),
                          child: Center(
                              child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(
                              "Motivational",
                              style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                            ),
                          )),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    GestureDetector(
                      onTap: () => controller.animateToPage(1,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeIn),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 0.0),
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                              color: Colors.green[300],
                              borderRadius: BorderRadius.circular(15)),
                          child: Center(
                              child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(
                              "Sucess stories",
                              style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                            ),
                          )),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => controller.animateToPage(2,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeIn),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                              color: Colors.red[300],
                              borderRadius: BorderRadius.circular(15)),
                          child: Center(
                              child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(
                              "Promotional",
                              style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                            ),
                          )),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => controller.animateToPage(3,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeIn),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                              color: Colors.pinkAccent[100],
                              borderRadius: BorderRadius.circular(15)),
                          child: Center(
                              child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(
                              "Tips",
                              style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                            ),
                          )),
                        ),
                      ),
                    ),
                    SizedBox(width: 15)
                  ]),
            ),
            Container(
              height: 500,
              child: PageView(controller: controller, children: [
                BuildHomeCardMotivational(context),
                BuildHomeCardSuccess(context),
                BuildHomeCardPoromotional(context),
                BuildHomeCardTips(context)
              ]),
            ),
          ],
        ),
      ),
    );
  }

  PageController controller;
  @override
  void initState() {
    // TODO: implement initState
    controller = PageController();
  }
}

Widget BuildHomeCardSuccess(context) {
  return StreamBuilder(
      stream: Firestore.instance.collection("success").snapshots(),
      builder: (context, snapshot) {
        return snapshot.data == null
            ? Container()
            : ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (ctx, i) {
                  var success = snapshot.data.documents[i];

                  return Padding(
                    padding: EdgeInsets.only(top: 0, left: 15, right: 15),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.green[300],
                          borderRadius: BorderRadius.circular(20)),
                      child: Row(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 20, top: 30),
                                child: Text(
                                  success["Title"],
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 5, left: 20, bottom: 10),
                                child: SingleChildScrollView(
                                  child: Container(
                                    height: 90,
                                    width: 200,
                                    child: Text(
                                      success["sub"],
                                      style: GoogleFonts.poppins(
                                        height: 1.2,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 25,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 10.0, bottom: 5),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                height: 95,
                                width: 95,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image:
                                            NetworkImage(success["lcation"]))),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          )
                        ],
                      ),
                    ),
                  );
                },
                scrollDirection: Axis.vertical,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
              );
      });
}

Widget BuildHomeCardMotivational(context) {
  return StreamBuilder(
      stream: Firestore.instance.collection("motivation").snapshots(),
      builder: (context, snapshot) {
        return snapshot.data == null
            ? Container()
            : ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (ctx, i) {
                  var success = snapshot.data.documents[i];

                  return Padding(
                    padding: EdgeInsets.only(top: 0, left: 15, right: 15),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Color(0xFF5894FA).withOpacity(0.9),
                          borderRadius: BorderRadius.circular(20)),
                      child: Row(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 20, top: 30),
                                child: Text(
                                  success["Title"],
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 5, left: 20, bottom: 10),
                                child: SingleChildScrollView(
                                  child: Container(
                                    height: 90,
                                    width: 200,
                                    child: Text(
                                      success["sub"],
                                      style: GoogleFonts.poppins(
                                        height: 1.2,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 25,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 10.0, bottom: 5),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                height: 95,
                                width: 95,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image:
                                            NetworkImage(success["lcation"]))),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          )
                        ],
                      ),
                    ),
                  );
                },
                scrollDirection: Axis.vertical,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
              );
      });
}

Widget BuildHomeCardPoromotional(context) {
  return StreamBuilder(
      stream: Firestore.instance.collection("promo").snapshots(),
      builder: (context, snapshot) {
        return snapshot.data == null
            ? Container()
            : ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (ctx, i) {
                  var success = snapshot.data.documents[i];

                  return Padding(
                    padding: EdgeInsets.only(top: 0, left: 15, right: 15),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.red[300],
                          borderRadius: BorderRadius.circular(20)),
                      child: Row(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 20, top: 30),
                                child: Text(
                                  success["Title"],
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 5, left: 20, bottom: 10),
                                child: SingleChildScrollView(
                                  child: Container(
                                    height: 90,
                                    width: 200,
                                    child: Text(
                                      success["sub"],
                                      style: GoogleFonts.poppins(
                                        height: 1.2,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 25,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 10.0, bottom: 5),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                height: 95,
                                width: 95,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image:
                                            NetworkImage(success["lcation"]))),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          )
                        ],
                      ),
                    ),
                  );
                },
                scrollDirection: Axis.vertical,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
              );
      });
}

Widget BuildHomeCardTips(context) {
  return StreamBuilder(
      stream: Firestore.instance.collection("tips").snapshots(),
      builder: (context, snapshot) {
        return snapshot.data == null
            ? Container()
            : ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (ctx, i) {
                  var success = snapshot.data.documents[i];

                  return Padding(
                    padding: EdgeInsets.only(top: 0, left: 15, right: 15),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.pinkAccent[100],
                          borderRadius: BorderRadius.circular(20)),
                      child: Row(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 20, top: 30),
                                child: Text(
                                  success["Title"],
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 5, left: 20, bottom: 10),
                                child: SingleChildScrollView(
                                  child: Container(
                                    height: 90,
                                    width: 200,
                                    child: Text(
                                      success["sub"],
                                      style: GoogleFonts.poppins(
                                        height: 1.2,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 25,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 10.0, bottom: 5),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                height: 95,
                                width: 95,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image:
                                            NetworkImage(success["lcation"]))),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          )
                        ],
                      ),
                    ),
                  );
                },
                scrollDirection: Axis.vertical,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
              );
      });
}
