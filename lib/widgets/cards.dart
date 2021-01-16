import 'package:SOAR/screens/feed_details.dart';
import 'package:SOAR/widgets/gradient_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileCard extends StatefulWidget {
  String title;
  String poster;
  String date;

  ProfileCard({this.title, this.date, this.poster});
  @override
  ProfileCardState createState() => ProfileCardState();
}

class ProfileCardState extends State<ProfileCard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(4278190106).withOpacity(0.9),
        body: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, ),
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
                        Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(widget.poster),
                                  fit: BoxFit.fill)),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10, bottom: 13),
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.title,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "good",
                                      color: Colors.white),
                                ),
                                Text(
                                  widget.date,
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
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10, right: 10),
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: Container(
                                width: 80,
                                height: 30,
                                decoration: BoxDecoration(
                                    color: Color(4278190106),
                                    borderRadius: BorderRadius.circular(20)),
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
                        )
                      ],
                    )),
              ),
            )));
  }
}
