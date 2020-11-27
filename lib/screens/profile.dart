import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:SOAR/widgets/cards.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:SOAR/screens/feed.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String location;
  Future<void> _fetchUserinfoForSettingsPage() async {
    try {
      await Firestore.instance
          .collection("Users")
          .document(auth.currentUser.uid)
          .get()
          .then((value) {
        if (value.exists) {
          setState(() {
            location = value.data()["dpurl"];
          });
        }
      });
    } catch (e) {}
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchUserinfoForSettingsPage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(4278190106),
      body: Container(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Stack(children: [
                CustomPaint(
                  size: Size(500, 260),
                  painter: RPSCustomPainter(),
                ),
              ]),
              Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: EdgeInsets.only(top: 50, left: 20),
                    child: Hero(
                        tag: "good",
                        child: location == null
                            ? Stack(
                                children: [
                                  CircleAvatar(
                                    backgroundImage: AssetImage(
                                      "assets/unknown.png",
                                    ),
                                    backgroundColor: Color(4278272638),
                                    radius: 85,
                                  ),
                                ],
                              )
                            : Stack(
                                children: [
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(location),
                                    backgroundColor: Colors.white,
                                    radius: 85,
                                  ),
                                ],
                              )),
                  )),
              Padding(
                padding: const EdgeInsets.only(
                  top: 220,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 16, right: 10),
                                child: StreamBuilder(
                                    stream: Firestore.instance
                                        .collection('Users')
                                        .document(auth.currentUser.uid)
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData) {
                                        return CircularProgressIndicator();
                                      }
                                      var userDocument = snapshot.data;
                                      return Text(
                                        userDocument["name"] ??
                                            "It may take some time....",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 55,
                                            fontFamily: "good"),
                                      );
                                    }),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Align(
                              alignment: Alignment.topRight,
                              child: GestureDetector(
                                onTap: () {},
                                child: Container(
                                  width: 120,
                                  height: 30,
                                  decoration: BoxDecoration(
                                      color: Color(4278228470),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Follow",
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 13),
                      child: StreamBuilder(
                          stream: Firestore.instance
                              .collection('Users')
                              .document(auth.currentUser.uid)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return CircularProgressIndicator();
                            }
                            var userDocument = snapshot.data;
                            return userDocument == null
                                ? CircularProgressIndicator()
                                : Text(
                                    userDocument["tagline"] ??
                                        "It may take some time....",
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.7),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 15,
                                    ),
                                  );
                          }),
                    ),
                                       SizedBox(height: 15),

                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Row(
                        children: [
                          Image.asset("assets/web.png"),
                          SizedBox(
                            width: 10,
                          ),
                          StreamBuilder(
                              stream: Firestore.instance
                                  .collection('Users')
                                  .document(auth.currentUser.uid)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return CircularProgressIndicator();
                                }
                                var userDocument = snapshot.data;
                                return userDocument == null
                                    ? CircularProgressIndicator()
                                    : Text(
                                        userDocument["websiteurl"] ??
                                            "It may take some time....",
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.5),
                                          fontSize: 15,
                                        ),
                                      );
                              }),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 25, left: 30),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  "30",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 30,
                                      fontWeight: FontWeight.w500),
                                ),
                                Opacity(
                                    opacity: 0.9,
                                    child: Text(
                                      "Connections",
                                      style: TextStyle(
                                        color: Color(4286677377),
                                      ),
                                    )),
                              ],
                            ),
                            SizedBox(
                              width: 30,
                            ),
                            Column(
                              children: [
                                Text(
                                  "30",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 30,
                                      fontWeight: FontWeight.w500),
                                ),
                                Opacity(
                                    opacity: 0.9,
                                    child: Text(
                                      "Pitches",
                                      style: TextStyle(
                                        color: Color(4286677377),
                                      ),
                                    )),
                              ],
                            ),
                            SizedBox(
                              width: 30,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  "30",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 30,
                                      fontWeight: FontWeight.w500),
                                ),
                                Opacity(
                                    opacity: 0.9,
                                    child: Text(
                                      "Connections",
                                      style: TextStyle(
                                        color: Color(4286677377),
                                      ),
                                    )),
                              ],
                            ),
                            SizedBox(
                              width: 30,
                            ),
                          ]),
                    ),
                    SizedBox(
                      height: 28,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, bottom: 0),
                      child: Text(
                        " Pitches",
                        style: TextStyle(
                            fontSize: 55,
                            fontFamily: "good",
                            color: Colors.white),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Align(
                        alignment: Alignment.center,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(26),
                          child: Container(
                            height: 330,
                            width: 350,
                            decoration: BoxDecoration(
                              color: Color(4280099132),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            alignment: Alignment.center, // where to p
                            child: ProfileCard(),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var rect = Offset.zero & size;

    Paint paint = new Paint()
      ..shader = LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [
          Colors.blue[900],
          Colors.blue[500],
        ],
      ).createShader(rect)
      ..style = PaintingStyle.fill
      ..strokeWidth = 1.48;

    Path path = Path();
    path.moveTo(0, size.height * 0.72);
    path.quadraticBezierTo(size.width * 0.20, size.height * 0.42,
        size.width * 0.45, size.height * 0.64);
    path.cubicTo(size.width * 0.71, size.height * 0.94, size.width * 0.94,
        size.height * 0.62, size.width, size.height);
    path.quadraticBezierTo(
        size.width * 1.10, size.height * 0.78, size.width, 0);
    path.lineTo(0, 0);
    path.lineTo(0, size.height * 0.72);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  String location;
}
