import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math' as math;
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:SOAR/screens/feed.dart';
import 'package:flutter/rendering.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:SOAR/web.dart';

class PromoVideo extends StatefulWidget {
  String id;
  String url;

  PromoVideo({Key key, this.id, this.url});

  @override
  _PromoVideoState createState() => _PromoVideoState();
}

class _PromoVideoState extends State<PromoVideo> {
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;

  final double _initFabHeight = 120.0;
  double _fabHeight;
  bool isfill;

  checkifbookmarked() async {
    QuerySnapshot _query = await Firestore.instance
        .collection("Users")
        .document(auth.currentUser.uid)
        .collection("bookmarked")
        .where("document id for all", isEqualTo: widget.id)
        .getDocuments();
    if (_query.documents.length > 0) {
      setState(() {
        isfill = false;
      });
    } else {
      setState(() {
        isfill = true;
      });
      print("${isfill}man");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkifbookmarked();
    _controller = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        _controller.play();
        _controller.setLooping(true);
        _initializeVideoPlayerFuture = _controller.initialize();

        setState(() {});
      });

    _fabHeight = _initFabHeight;
  }

  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Color(4280032553),
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarIconBrightness:
          Brightness.dark, // navigation bar color
    ));
    double _panelHeightOpen;
    double _panelHeightClosed = MediaQuery.of(context).size.height * .22;
    _panelHeightOpen = MediaQuery.of(context).size.height * .7;
    return Scaffold(
        body: Stack(
      children: [
        SlidingUpPanel(
          maxHeight: _panelHeightOpen,
          minHeight: _panelHeightClosed,
          parallaxEnabled: true,
          parallaxOffset: 0.1,
          backdropColor: Color(4280032553),
          color: Color(4280032553),
          body: _body(),
          panelBuilder: (sc) => _panel(sc, context, widget.id),
          borderRadius: BorderRadius.only(topRight: Radius.circular(40)),
          onPanelSlide: (double pos) => setState(() {
            _fabHeight =
                pos * (_panelHeightOpen - _panelHeightClosed) + _initFabHeight;
          }),
        ),

        // the fab
      ],
    ));
  }

  int index = 1;

  Widget _body() {
    return GestureDetector(
      onTap: () {
        if (_controller.value.isPlaying) {
          _controller.pause();
        } else {
          // If the video is paused, play it.
          _controller.play();
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: VisibilityDetector(
          key: Key("unique key"),
          onVisibilityChanged: (VisibilityInfo info) {
            debugPrint("${info.visibleFraction} of my widget is visible");
            if (info.visibleFraction == 0) {
              _controller.pause();
            } else {
              _controller.play();
            }
          },
          child: FutureBuilder(
            future: _initializeVideoPlayerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: VideoPlayer(_controller),
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _panel(ScrollController sc, ctx, String id) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      child: MediaQuery.removePadding(
          context: ctx,
          removeTop: true,
          child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (OverscrollIndicatorNotification overScroll) {
              overScroll.disallowGlow();
              return false;
            },
            child: StreamBuilder(
                stream: Firestore.instance
                    .collection("all")
                    .document(id)
                    .snapshots(),
                builder: (context, snapshot) {
                  var moti = snapshot.data;
                  return ListView(
                    controller: sc,
                    children: <Widget>[
                      SizedBox(
                        height: 2.0,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Material(
                                type: MaterialType.transparency,
                                child: Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        right: 15.0, bottom: 0),
                                    child: moti["Title"] == null
                                        ? Text("")
                                        : Text(
                                            moti["Title"] ?? "",
                                            style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 27,
                                                color: Colors.blue),
                                          ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundImage:
                                            NetworkImage(moti["lcation"]),
                                        radius: 25,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            moti["name"],
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 4.0),
                                                child: Transform.rotate(
                                                  angle: 180 * math.pi / 180,
                                                  child: Image.asset(
                                                    "assets/thumbs_up.png",
                                                    scale: 19,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                "${moti["dislikes"]}",
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(
                                                width: 20,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: .0),
                                                child: Image.asset(
                                                  "assets/thumbs_up.png",
                                                  scale: 19,
                                                  color: Colors.blue,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                "${moti["likes"]}",
                                                style: TextStyle(
                                                    color: Colors.blue,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      isfill == false
                                          ? GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  isfill = true;
                                                });
                                                Firestore.instance
                                                    .collection("Users")
                                                    .doc(auth.currentUser.uid)
                                                    .collection("bookmarked")
                                                    .document(widget.id)
                                                    .delete();
                                              },
                                              child: Icon(
                                                Icons.bookmark_rounded,
                                                size: 25,
                                                color: Colors.indigo,
                                              ))
                                          : GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  isfill = false;
                                                });
                                                Firestore.instance
                                                    .collection("Users")
                                                    .doc(auth.currentUser.uid)
                                                    .collection("bookmarked")
                                                    .document(widget.id)
                                                    .setData({
                                                  "document id for all":
                                                      moti.id,
                                                  "Title": moti["Title"],
                                                  "handle": moti["handle"],
                                                  "lcation": moti["lcation"],
                                                  "name": moti["name"],
                                                  "sub": moti["sub"],
                                                  "type": moti["type"],
                                                  "years": moti["years"],
                                                  "images": images,
                                                  "video_url": widget.url
                                                });
                                              },
                                              child: Icon(
                                                Icons.bookmark_border_outlined,
                                                size: 25,
                                                color: Colors.indigo,
                                              )),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              ctx,
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      View(moti["handle"])));
                                        },
                                        child: Image.asset(
                                          "assets/share.png",
                                          scale: 5,
                                          color: Colors.blue,
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(height: 10),
                              Text(
                                moti["sub"],
                                style: GoogleFonts.robotoCondensed(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    GestureDetector(
                                        onTap: () {
                                          Firestore.instance
                                              .collection("all")
                                              .document(id)
                                              .updateData({
                                            "dislikes": FieldValue.increment(1)
                                          });
                                        },
                                        child: Container(
                                          width: 150,
                                          height: 45,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Color(4278656582)
                                                  .withOpacity(1)),
                                          child: Center(
                                              child: Center(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Transform.rotate(
                                                  angle: 180 * math.pi / 180,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 5.0),
                                                    child: Image.asset(
                                                      "assets/thumbs_up.png",
                                                      height: 20,
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 13,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 15.0),
                                                  child: Text(
                                                    "Dislike",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 17),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )),
                                        )),
                                    GestureDetector(
                                      onTap: () {
                                        Firestore.instance
                                            .collection("all")
                                            .document(id)
                                            .updateData({
                                          "likes": FieldValue.increment(1)
                                        });
                                      },
                                      child: Container(
                                          width: 150,
                                          height: 45,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Color(4278656582)
                                                  .withOpacity(1)),
                                          child: Center(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  "assets/thumbs_up.png",
                                                  height: 20,
                                                  color: Colors.blue,
                                                ),
                                                SizedBox(
                                                  width: 13,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 15.0),
                                                  child: Text(
                                                    "Like",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 17),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 5.0, right: 5),
                                child: Container(
                                  height: 210,
                                  child: StreamBuilder(
                                    stream: Firestore.instance
                                        .collection("all")
                                        .document(id)
                                        .snapshots(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot snapshot) {
                                      images = snapshot.data["images"];
                                      return snapshot.data == null
                                          ? Container()
                                          : ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: snapshot
                                                  .data["images"].length,
                                              scrollDirection: Axis.horizontal,
                                              itemBuilder: (ctx, i) {
                                                return Row(
                                                  children: <Widget>[
                                                    GestureDetector(
                                                      onTap: () {
                                                        showDialog(
                                                          barrierDismissible:
                                                              true,
                                                          context: context,
                                                          builder: (context) {
                                                            return Dialog(
                                                              backgroundColor:
                                                                  Colors
                                                                      .transparent,
                                                              child: Container(
                                                                  height: 410,
                                                                  decoration: BoxDecoration(
                                                                      image: DecorationImage(
                                                                          image: NetworkImage(snapshot.data["images"]
                                                                              [
                                                                              i]),
                                                                          fit: BoxFit
                                                                              .contain))),
                                                            );
                                                          },
                                                        );
                                                      },
                                                      child: Container(
                                                        width: 160,
                                                        height: 210,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15),
                                                            image: DecorationImage(
                                                                image: NetworkImage(
                                                                    snapshot.data[
                                                                            "images"]
                                                                        [i]),
                                                                fit: BoxFit
                                                                    .cover)),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                  ],
                                                );
                                              });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }),
          )),
    );
  }

  List images;
}
