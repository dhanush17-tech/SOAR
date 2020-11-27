import 'package:SOAR/screens/feed_details.dart';
import 'package:SOAR/widgets/gradient_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileCard extends StatefulWidget {
  @override
  ProfileCardState createState() => ProfileCardState();
}

class ProfileCardState extends State<ProfileCard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Opacity(
          opacity: 1,
          child: Align(
            alignment: Alignment.center,
            child: Container(
              height: 350,
              width: 350,
              decoration: BoxDecoration(
                color: Color(4280099132),
                borderRadius: BorderRadius.circular(20),
              ),
              alignment: Alignment.center, // where to position the child
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 0),
          child: Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: 350,
              height: 320,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          transitionDuration: Duration(milliseconds: 500),
                          pageBuilder: (_, __, ___) => FeedDetails(),
                        ),
                      );
                    },
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Hero(
                          tag: "mannna",
                          child: Container(
                            width: 350,
                            height: 200,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage("assets/upload.jpg"),
                                    fit: BoxFit.fill)),
                          ),
                        )),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: GradientText("ScanIn",
                          gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [
                              Color(4278224383),
                              Color(4278251775),
                            ],
                          )),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: 2, left: 17, bottom: 5, right: 5),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "It is a light weight document scaning app that ensures the privacy of the user by usign only local databases for stoarge",
                          style: GoogleFonts.poppins(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ));
  }
}
