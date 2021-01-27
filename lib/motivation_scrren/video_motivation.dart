import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';
import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';

class MotivationHome extends StatefulWidget {
  String text;
  String id;

  MotivationHome(this.text, this.id);
  @override
  _MotivationHomeState createState() => _MotivationHomeState();
}

class _MotivationHomeState extends State<MotivationHome> {
  @override
  void initState() {
    super.initState();
    print(widget.id);
  }

  VideoPlayerController _controller;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Color(0xFFE6EDFA),
          body: Padding(
            padding: EdgeInsets.only(top: 10),
            child: StreamBuilder(
                stream: Firestore.instance
                    .collection("all")
                    .document(widget.id)
                    .snapshots(),
                builder: (context, snapshot) {
                  return ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 1,
                    itemBuilder: (BuildContext context, int index) {
                      var success = snapshot.data;

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.indigo,
                                        ),
                                        child: Icon(
                                          Icons.arrow_back_rounded,
                                          color: Colors.white,
                                          size: 25,
                                        )),
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.23,
                                ),
                                Align(
                                    alignment: Alignment.center,
                                    child: Text(widget.text,
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 20,
                                            color: Colors.black)))
                              ],
                            ),
                            SizedBox(height: 30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(success["name"],
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.poppins(
                                            fontSize: 24,
                                            
                                            color: Colors.indigo,
                                            fontWeight: FontWeight.w500)),
                                    Text(success["years"],
                                        style: GoogleFonts.poppins(
                                            fontSize: 20,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500))
                                  ],
                                ),
                                Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(success["lcation"]),
                                      )),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  Icons.bookmark_border_rounded,
                                  size: 25,
                                  color: Colors.indigo,
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.thumb_up_alt_outlined,
                                      size: 25,
                                      color: Colors.indigo,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Icon(
                                      Icons.share_outlined,
                                      size: 25,
                                      color: Colors.indigo,
                                    ),
                                  ],
                                )
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              success["sub"],
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                                fontSize: 17,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: GestureDetector(
                                onTap: () {},
                                child: Text(
                                  success["handle"],
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      color: Colors.blue[900], fontSize: 15),
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  );
                }),
          )),
    );
  }
}

String d =
    "ffffffffffffffffffffffffffffffffffffffffssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff";
