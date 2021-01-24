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
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: Color(0xFFE6EDFA),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
                  child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 40, left: 15, right: 15),
                child: Container(
                  height: 130,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        Color(0xFF4E82E8).withOpacity(1),
                        Color(0xFF5894FA).withOpacity(1)
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
                        width: 50,
                      ),
                      Container(
                          alignment: Alignment.bottomCenter,
                          height: 140,
                          width: 130,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                    "assets/hello.png",
                                  ),
                                  fit: BoxFit.cover)))
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
                padding: const EdgeInsets.only(top: 8.0),
                child: Container(
                  height: 300,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.separated(
                    itemCount: 3,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (ctx, i) => Padding(
                      padding: const EdgeInsets.only(top: 8.0, left: 15),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            colors: [Color(0xFF4E82E8), Colors.blue]
                          ),
                          image: DecorationImage(image: AssetImage("assets/carousel1.jpeg",
                          ),
                          fit: BoxFit.cover)
                        ),
                        width: 250.0,
                      ),
                    ),
                    separatorBuilder: (context, index) => SizedBox(width: 20),
                  ),
                ),
              ),
              SizedBox(height: 30,),
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
              Container(
                height: 100,
                child: PageView.builder(
                  itemBuilder: (ctx,i) =>
                    Container(
                      width: 100,
                      height: 60,
                      color: Colors.pink,
                    )
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
