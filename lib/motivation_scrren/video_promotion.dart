import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math' as math;
import 'package:drop_cap_text/drop_cap_text.dart';
import 'package:flutter/rendering.dart';
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

  final double _initFabHeight = 120.0;
  double _fabHeight;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _controller = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        _controller.play();
        setState(() {});
      });

    _controller.addListener(() {});
    _fabHeight = _initFabHeight;
  }

  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double _panelHeightOpen;
    double _panelHeightClosed = MediaQuery.of(context).size.height * .22;
    _panelHeightOpen = MediaQuery.of(context).size.height * .7;
    return Scaffold(
        body: Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: VideoPlayer(_controller),
          ),
        ),
        SlidingUpPanel(
          maxHeight: _panelHeightOpen,
          minHeight: _panelHeightClosed,
          parallaxEnabled: true,
          parallaxOffset: 0.1,
          body: _body(),
          backdropColor: Color(4280032553),
          color: Color(4280032553),
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
    return Hero(
      tag: "dd+$index",
      child: Container(
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: VideoPlayer(_controller),
        ),
      ),
    );
  }
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
                  .collection("motivation")
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
                                  child: moti["title"] == null
                                      ? Text("")
                                      : Text(
                                          moti["title"] ?? "",
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 25,
                                              color: Colors.blue),
                                        ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(moti["location"]),
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
                                              width: 2,
                                            ),
                                            Text(
                                              "${moti["dislikes"]}",
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.bold),
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
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        ctx,
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                View(moti["website"])));
                                  },
                                  child: Image.asset(
                                    "assets/share.png",
                                    scale: 5,
                                    color: Colors.blue,
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 10),
                            Text(
                              moti["about user"],
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
                                            .collection("motivation")
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
                                                padding: const EdgeInsets.only(
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
                                          .collection("motivation")
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
                                                padding: const EdgeInsets.only(
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
                                      .collection("motivation")
                                      .document(id)
                                      .snapshots(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot snapshot) {
                                    return snapshot.data == null
                                        ? Container()
                                        : ListView.builder(
                                            shrinkWrap: true,
                                            itemCount:
                                                snapshot.data["images"].length,
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (ctx, i) {
                                              var images =
                                                  snapshot.data["images"];
                                              return Row(
                                                children: <Widget>[
                                                  Container(
                                                    width: 160,
                                                    height: 210,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                        image: DecorationImage(
                                                            image: NetworkImage(
                                                                snapshot.data[
                                                                        "images"]
                                                                    [i]),
                                                            fit: BoxFit.fill)),
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
