import 'package:SOAR/screens/feed.dart';
import 'package:SOAR/screens/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'settings_page.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class FeedDetails extends StatefulWidget {
  String documnetid;
  FeedDetails({this.documnetid});

  @override
  _FeedDetailsState createState() => _FeedDetailsState();
}

class _FeedDetailsState extends State<FeedDetails> {
  final double _initFabHeight = 120.0;
  double _fabHeight;
  double _panelHeightOpen;
  double _panelHeightClosed = 120.0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fabHeight = _initFabHeight;
    print("${widget.documnetid}");
    getname();
  }

  String name;
  getname() {
    Firestore.instance
        .collection("Users")
        .document(auth.currentUser.uid)
        .get()
        .then((value) {
      name = value.data()["name"];
      print(name);
    });
  }

  ScrollController sc;
  @override
  Widget build(BuildContext context) {
    _panelHeightOpen = MediaQuery.of(context).size.height * .80;
    return Scaffold(
      backgroundColor: Color(4278190106),
      body: StreamBuilder(
          stream: Firestore.instance
              .collection("Feed")
              .document(widget.documnetid)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Text('Loading... data');
            return snapshot.data != null
                ? ListView.builder(
                    itemCount: 1,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (ctx, i) {
                      DocumentSnapshot course = snapshot.data;

                      return Stack(children: [
                        Container(
                          height: MediaQuery.of(context).size.height,
                          child: SlidingUpPanel(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(70)),
                            maxHeight: _panelHeightOpen,
                            minHeight: _panelHeightClosed,
                            parallaxEnabled: true,
                            parallaxOffset: .5,
                            panelBuilder: (sc) {
                              return ClipRRect(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(70)),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Color(4278190106),
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(70))),
                                  child: ListView(
                                    controller: sc,
                                    children: [
                                      Container(
                                          padding: EdgeInsets.only(
                                              left: 15, top: 20),
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Align(
                                                  alignment: Alignment.topLeft,
                                                  child: Text(
                                                    "About the \npitch ",
                                                    style: GoogleFonts.poppins(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 35,
                                                        height: 0.9,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                (SizedBox(height: 40)),
                                                Row(
                                                  children: [
                                                    GestureDetector(
                                                        onTap: () {
                                                          Navigator.push(
                                                            context,
                                                            PageRouteBuilder(
                                                              transitionDuration:
                                                                  Duration(
                                                                      milliseconds:
                                                                          500),
                                                              pageBuilder: (_,
                                                                      __,
                                                                      ___) =>
                                                                  Profile(
                                                                uidforprofile:
                                                                    course[
                                                                        "uid"],
                                                                name: name,
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                        child:
                                                            course["dpurl"] !=
                                                                    null
                                                                ? Hero(
                                                                    tag: "good",
                                                                    child:
                                                                        CircleAvatar(
                                                                      backgroundColor:
                                                                          Color(
                                                                              4278272638),
                                                                      radius:
                                                                          40,
                                                                      backgroundImage:
                                                                          NetworkImage(
                                                                              course["dpurl"]),
                                                                    ),
                                                                  )
                                                                : Hero(
                                                                    tag: "good",
                                                                    child:
                                                                        CircleAvatar(
                                                                      backgroundColor:
                                                                          Color(
                                                                              4278272638),
                                                                      radius:
                                                                          40,
                                                                      backgroundImage:
                                                                          AssetImage(
                                                                              "assets/unknown.png"),
                                                                    ),
                                                                  )),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Expanded(
                                                      child:
                                                          SingleChildScrollView(
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 16,
                                                                    right: 15),
                                                            child: Text(
                                                                course[
                                                                    "owener"],
                                                                style:
                                                                    GoogleFonts
                                                                        .poppins(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 25,
                                                                  color: Colors
                                                                      .white,
                                                                ))),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10),
                                                  child: Opacity(
                                                      opacity: 0.6,
                                                      child: Text(
                                                        course["title"],
                                                        style:
                                                            GoogleFonts.poppins(
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .white),
                                                      )),
                                                ),
                                                SizedBox(
                                                  height: 7,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10, right: 10),
                                                  child: Text(course["summury"],
                                                      style:
                                                          GoogleFonts.poppins(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 13,
                                                              color:
                                                                  Colors.white,
                                                              height: 1.2)),
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10),
                                                  child: Opacity(
                                                      opacity: 0.6,
                                                      child: Text(
                                                        "Features",
                                                        style:
                                                            GoogleFonts.poppins(
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .white),
                                                      )),
                                                ),
                                                SizedBox(height: 15),
                                                StreamBuilder(
                                                    stream: Firestore.instance
                                                        .collection("Feed")
                                                        .document(
                                                            widget.documnetid)
                                                        .snapshots(),
                                                    builder: (ctx, snapshot) {
                                                      var features =
                                                          snapshot.data;
                                                      return ListView.separated(
                                                        separatorBuilder:
                                                            (ctx, i) =>
                                                                SizedBox(
                                                                    height: 10),
                                                        physics:
                                                            NeverScrollableScrollPhysics(),
                                                        itemCount:
                                                            features['features']
                                                                .length,
                                                        shrinkWrap: true,
                                                        itemBuilder: (ctx, i) {
                                                          print(features[
                                                                  "features"]
                                                              .length);
                                                          return Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    right: 20),
                                                            child: Align(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Container(
                                                                height: 130,
                                                                width: 350,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20),
                                                                  color: Color(
                                                                      4280099132),
                                                                ),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Opacity(
                                                                      opacity:
                                                                          0.6,
                                                                      child:
                                                                          Padding(
                                                                        padding: const EdgeInsets.only(
                                                                            top:
                                                                                10,
                                                                            left:
                                                                                15),
                                                                        child:
                                                                            Text(
                                                                          features["titles"][i]
                                                                              .toString(),
                                                                          style: GoogleFonts.poppins(
                                                                              fontSize: 17,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: Colors.white),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          left:
                                                                              15,
                                                                          top:
                                                                              5),
                                                                      child:
                                                                          Text(
                                                                        features["features"][i]
                                                                            .toString(),
                                                                        style: GoogleFonts.poppins(
                                                                            fontSize:
                                                                                13,
                                                                            color:
                                                                                Colors.white,
                                                                            fontWeight: FontWeight.bold),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    }),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                SizedBox(
                                                  height: 100,
                                                )
                                              ])),
                                    ],
                                  ),
                                ),
                              );
                            },
                            body: Stack(
                              children: [
                                Stack(
                                  children: [
                                    Hero(
                                      tag: "dssd+$i",
                                      child: Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                            image: NetworkImage(
                                                course["postimage"]),
                                      
                                          ))),
                                    ),
                                    Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 15, left: 8),
                                          child: Align(
                                            alignment: Alignment.topLeft,
                                            child: FittedBox(
                                              child: GestureDetector(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Container(
                                                  height: 50,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Color(4278190106),
                                                  ),
                                                  child: Icon(
                                                    Icons.arrow_back,
                                                    color: Color(4278228470),
                                                    size: 30,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.bottomLeft,
                                          child: Container(
                                            width: 220,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 20, left: 12),
                                              child: Align(
                                                alignment: Alignment.topLeft,
                                                child: Text(
                                                  course["title"],
                                                  style: GoogleFonts.poppins(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 40,
                                                      color: Color(4278228470),
                                                      height: 1.02),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 20,
                          right: 0,
                  
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: Container(
                              padding: EdgeInsets.only(left: 15,),
                              height: 69,
                              width: 180,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(40)),
                                  color: Color(4278228470)),
                              child: Text(course["owener"],
                                  style: GoogleFonts.poppins(
                                    height: 1.2,
                                      fontSize: 20,
                                      color: Color(4278190106),
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ),
                      ]);
                    })
                : Container();
          }),
    );
  }
}
