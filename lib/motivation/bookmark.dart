import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:SOAR/screens/feed.dart';
import 'package:easy_gradient_text/easy_gradient_text.dart';
import 'package:google_fonts/google_fonts.dart';
import 'video_motivation.dart';
import 'package:SOAR/motivation/video_promotion.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:SOAR/main_constraints.dart';

class BookMarkPage extends StatefulWidget {
  @override
  _BookMarkPageState createState() => _BookMarkPageState();
}

class _BookMarkPageState extends State<BookMarkPage> {
  @override
  void initState() {
    // TODO: implement initState
    getman();
    super.initState();
  }

  Future loadpass() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool(
      "keys",
    );
  }

  getman() {
    loadpass().then((ca) {
      setState(() {
        man = ca;
      });
    });
  }

  bool man;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: man == false ? light_background : dark_background,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 18, top: 18),
                child: GradientText(
                  text: "Bookmarks",
                  colors: [Colors.indigo, Colors.blue],
                  style: GoogleFonts.poppins(
                    fontSize: 35,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            FutureBuilder(
              future: Firestore.instance
                  .collection("Users")
                  .document(auth.currentUser.uid)
                  .collection("bookmarked")
                  .getDocuments(),
              builder: (BuildContext context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container();
                  } else {
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context, i) {
                          var success = snapshot.data.documents[i];
                          return GestureDetector(
                            onTap: () {
                              if (success["type"] == "Promotional") {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (c) => PromoVideo(
                                              id: success.id,
                                              url: success["video_url"],
                                            )));
                              } else
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (c) => MotivationHome(
                                            success["type"], success.id)));
                            },
                            child: Padding(
                              padding:
                                  EdgeInsets.only(top: 0, left: 5, right: 5),
                              child: Container(
                                decoration: BoxDecoration(
                                    gradient: man == false
                                        ? LinearGradient(colors: [
                                            Color(0xFF5894FA).withOpacity(0.9),
                                            Color(0xFF5894FA).withOpacity(0.9),
                                          ])
                                        : LinearGradient(colors: [
                                            Colors.white.withOpacity(0.25),
                                            Colors.white.withOpacity(0.25)
                                          ]),
                                    borderRadius: BorderRadius.circular(20)),
                                child: Stack(
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 20, top: 30),
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
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  220,
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
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 15.0, right: 20),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          child: Container(
                                            width: 130,
                                            height: 130,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                image: DecorationImage(
                                                    fit: BoxFit.fill,
                                                    image: NetworkImage(
                                                        success["lcation"]))),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        });
                  }
                } else if (snapshot.hasError) {
                  Container();
                }
                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }
}
