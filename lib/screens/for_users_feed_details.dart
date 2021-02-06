import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'feed.dart';
import 'package:video_player/video_player.dart';
import 'profile.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'see_more.dart';

class FeedDetilsForEntrepreneurs extends StatefulWidget {
  String documnetid;
  String id;
  String url;
  int d;
  FeedDetilsForEntrepreneurs({this.documnetid, this.id, this.url, this.d});
  @override
  _FeedDetilsForEntrepreneursState createState() =>
      _FeedDetilsForEntrepreneursState();
}

class _FeedDetilsForEntrepreneursState
    extends State<FeedDetilsForEntrepreneurs> {
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;

  final double _initFabHeight = 130.0;
  double _fabHeight;
  double _panelHeightOpen;
  double _panelHeightClosed = 130.0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fabHeight = _initFabHeight;
    print(widget.documnetid);
    print("${widget.documnetid}");
    print(auth.currentUser.uid);
    getname();
    _controller = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        _controller.play();
        _initializeVideoPlayerFuture = _controller.initialize();
        _controller.setLooping(true);

        setState(() {});
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
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

  @override
  Widget build(BuildContext context) {
    _panelHeightOpen = MediaQuery.of(context).size.height * .80;
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);

    return Scaffold(
      backgroundColor: Color(4278190106),
      body: StreamBuilder(
          stream: Firestore.instance
              .collection("Users")
              .document(widget.id)
              .collection("posts")
              .document(widget.documnetid)
              .snapshots(),
          builder: (context, snap) {
            if (!snap.hasData) return Text('Loading... data');
            return snap.data == null
                ? Container()
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: 1,
                    itemBuilder: (ctx, i) {
                      var feed = snap.data;
                      return StreamBuilder<Object>(
                          stream: Firestore.instance
                              .collection("Feed")
                              .document(feed.id)
                              .snapshots(),
                          builder: (context, snapshot) {
                            var man = snap.data;
                            return Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 8.0, left: 8.0),
                                  child: StreamBuilder(
                                      stream: Firestore.instance
                                          .collection("Users")
                                          .document(feed["uid"])
                                          .snapshots(),
                                      builder: (ctx, i) {
                                        return i.data == null
                                            ? Container()
                                            : Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                top: 0,
                                                                left: 5),
                                                        child: Align(
                                                          alignment:
                                                              Alignment.topLeft,
                                                          child: FittedBox(
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: Container(
                                                                height: 35,
                                                                width: 35,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  gradient:
                                                                      LinearGradient(
                                                                          colors: [
                                                                        Colors.blue[
                                                                            400],
                                                                        Colors.blueAccent[
                                                                            700]
                                                                      ]),
                                                                  color: Color(
                                                                      4278228470),
                                                                ),
                                                                child: Icon(
                                                                  Icons
                                                                      .arrow_back,
                                                                  color: Colors
                                                                      .white,
                                                                  size: 30,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 20,
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                            height: 50,
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                .49,
                                                            child:
                                                                SingleChildScrollView(
                                                              scrollDirection:
                                                                  Axis.horizontal,
                                                              child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                    top: 0,
                                                                  ),
                                                                  child: Text(
                                                                    feed[
                                                                        "title"],
                                                                    style: GoogleFonts
                                                                        .poppins(
                                                                      fontSize:
                                                                          30,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  )),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  i.data["location"] == null
                                                      ? Align(
                                                          alignment: Alignment
                                                              .topRight,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 0),
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child:
                                                                  CircleAvatar(
                                                                backgroundColor:
                                                                    Color(
                                                                        4278272638),
                                                                backgroundImage:
                                                                    AssetImage(
                                                                  "assets/unknown.png",
                                                                ),
                                                                radius: 25,
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      : Align(
                                                          alignment: Alignment
                                                              .topRight,
                                                          child:
                                                              GestureDetector(
                                                            onTap: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Center(
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            0),
                                                                child:
                                                                    CircleAvatar(
                                                                  backgroundColor:
                                                                      Color(
                                                                          4278272638),
                                                                  backgroundImage:
                                                                      NetworkImage(
                                                                    i.data[
                                                                        "location"],
                                                                  ),
                                                                  radius: 25,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                ],
                                              );
                                      }),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Hero(
                                    tag: "dssd+${widget.d}",
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          // If the video is playing, pause it.
                                          if (_controller.value.isPlaying) {
                                            _controller.pause();
                                          } else {
                                            // If the video is paused, play it.
                                            _controller.play();
                                          }
                                        });
                                      },
                                      child: Container(
                                        height: 250,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: Color(4278190106)),
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            child: VisibilityDetector(
                                              key: Key("unique key"),
                                              onVisibilityChanged:
                                                  (VisibilityInfo info) {
                                                debugPrint(
                                                    "${info.visibleFraction} of my widget is visible");
                                                if (info.visibleFraction == 0) {
                                                  _controller.pause();
                                                } else {
                                                  _controller.play();
                                                }
                                              },
                                              child: FutureBuilder(
                                                future:
                                                    _initializeVideoPlayerFuture,
                                                builder: (context, snapshot) {
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.done) {
                                                    return Center(
                                                      child: AspectRatio(
                                                        aspectRatio: _controller
                                                            .value.aspectRatio,
                                                        child: VideoPlayer(
                                                            _controller),
                                                      ),
                                                    );
                                                  } else {
                                                    return Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                        backgroundColor:
                                                            Colors.blue,
                                                      ),
                                                    );
                                                  }
                                                },
                                              ),
                                            )),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 15.0, left: 15),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Row(
                                        children: [
                                          Image.asset("assets/heart.png",
                                              color: Color(4290118716),
                                              scale: 6.5),
                                          Text(
                                            "${feed["likes"]}",
                                            style: GoogleFonts.poppins(
                                                fontSize: 19,
                                                fontWeight: FontWeight.bold,
                                                color: Color(4290229943)),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        width: 2,
                                        height: 20,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color:
                                                Colors.grey.withOpacity(0.6)),
                                      ),
                                      Row(
                                        children: [
                                          Image.asset(
                                            "assets/wow.png",
                                            width: 30,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            "${feed["wow"]}",
                                            style: GoogleFonts.poppins(
                                                fontSize: 19,
                                                fontWeight: FontWeight.bold,
                                                color: Color(4290229943)),
                                          ),
                                          SizedBox(
                                            width: 30,
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                width: 2,
                                                height: 20,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color: Colors.grey
                                                        .withOpacity(0.6)),
                                              ),
                                              SizedBox(
                                                width: 30,
                                              ),
                                              IconButton(
                                                  icon: Icon(
                                                    Icons.message_outlined,
                                                    color: Color(4278228470)
                                                        .withOpacity(0.8),
                                                    size: 30,
                                                  ),
                                                  onPressed: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (_) =>
                                                                SeeMore(
                                                                  seemore: man[
                                                                      "date"],
                                                                )));
                                                  }),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20.0, top: 10),
                                    child: Text(
                                      "Summary",
                                      style: TextStyle(
                                          fontSize: 40,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: "good",
                                          color: Color(4283848280)),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 25.0, top: 0, right: 25),
                                    child: Text(
                                      feed["summury"],
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: "good",
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 15),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20.0, top: 10),
                                    child: Text(
                                      "Value Proposition",
                                      style: TextStyle(
                                          fontSize: 40,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: "good",
                                          color: Color(4283848280)),
                                    ),
                                  ),
                                ),
                                StreamBuilder(
                                    stream: Firestore.instance
                                        .collection("Users")
                                        .document(widget.id)
                                        .collection("posts")
                                        .document(widget.documnetid)
                                        .snapshots(),
                                    builder: (ctx, snapshot) {
                                      var features = snapshot.data;
                                      return snapshot.data == null
                                          ? Container()
                                          : ListView.separated(
                                              separatorBuilder: (ctx, i) =>
                                                  SizedBox(height: 10),
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              itemCount:
                                                  features['features'].length,
                                              shrinkWrap: true,
                                              itemBuilder: (ctx, i) {
                                                print(features["features"]
                                                    .length);
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 0),
                                                  child: Align(
                                                    alignment: Alignment.center,
                                                    child: Container(
                                                      height: 130,
                                                      width: 350,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                        color:
                                                            Color(4280099132),
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Opacity(
                                                            opacity: 0.6,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 10,
                                                                      left: 15),
                                                              child: Text(
                                                                features["titles"]
                                                                        [i]
                                                                    .toString(),
                                                                style: GoogleFonts.poppins(
                                                                    fontSize:
                                                                        17,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 15,
                                                                    top: 5),
                                                            child: Text(
                                                              features["features"]
                                                                      [i]
                                                                  .toString(),
                                                              style: GoogleFonts.poppins(
                                                                  fontSize: 13,
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
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
                                  height: 15,
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20.0, top: 10),
                                    child: Text(
                                      'Target Audience',
                                      style: TextStyle(
                                          fontSize: 40,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: "good",
                                          color: Color(4283848280)),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20.0, top: 0, right: 25),
                                    child: Text(
                                      feed["target_audience"],
                                      style: GoogleFonts.poppins(
                                          fontSize: 20,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20.0, top: 10),
                                    child: Text(
                                      'Investment Needed',
                                      style: TextStyle(
                                          fontSize: 40,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: "good",
                                          color: Color(4283848280)),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20.0, top: 0, right: 25),
                                    child: Row(
                                      children: [
                                        Text(feed["value_propotion"],
                                            style: GoogleFonts.poppins(
                                                fontSize: 20,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold)),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        feed["currency"] == null
                                            ? Text("",
                                                style: GoogleFonts.poppins(
                                                    fontSize: 20,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold))
                                            : Text(feed["currency"] ?? "",
                                                style: GoogleFonts.poppins(
                                                    fontSize: 20,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20.0, top: 10),
                                    child: Text(
                                      'Revenue Model',
                                      style: TextStyle(
                                          fontSize: 40,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: "good",
                                          color: Color(4283848280)),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 19.0, top: 0, right: 25),
                                    child: Text(
                                      feed["revenue_model"],
                                      style: GoogleFonts.poppins(
                                          fontSize: 20,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20.0, top: 10),
                                    child: Text(
                                      'Poster',
                                      style: TextStyle(
                                          fontSize: 43,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: "good",
                                          color: Color(4283848280)),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      barrierDismissible: true,
                                      context: context,
                                      builder: (context) {
                                        return Dialog(
                                          backgroundColor: Colors.transparent,
                                          child: Container(
                                              height: 410,
                                              decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      image: NetworkImage(
                                                          feed["postimage"]),
                                                      fit: BoxFit.contain))),
                                        );
                                      },
                                    );
                                  },
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 19.0, top: 0, right: 25),
                                      child: Container(
                                        width: 200,
                                        height: 300,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    feed["postimage"]),
                                                fit: BoxFit.fill)),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                              ],
                            );
                          });
                    });
          }),
    );
  }
}
