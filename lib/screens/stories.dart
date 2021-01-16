import 'package:SOAR/screens/feed.dart';
import 'package:SOAR/screens/profile.dart';
import 'package:SOAR/screens/stories_add.dart';
import 'package:SOAR/storiesvie.dart';
import 'package:fade/fade.dart';
import 'package:flutter/material.dart';
import 'package:easy_gradient_text/easy_gradient_text.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:story_view/story_view.dart';

class Stories extends StatefulWidget {
  @override
  _StoriesState createState() => _StoriesState();
}

class _StoriesState extends State<Stories> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    man();

    setState(() {});

    print(imgList);
  }

  @override
  void dispose() {
    super.dispose();
    storyController.dispose();
  }

  List imgList = [];
  final storyController = StoryController();

  CarouselSlider carouselSlider;
  int _current = 0;
  List documentidList = [];
  List uidList = [];
  List dpurl = [];
  List duration = [];

  Future man() async {
    QuerySnapshot _query = await Firestore.instance
        .collection("stories")
        .getDocuments()
        .then((snapshot) {
      imgList
          .addAll(snapshot.documents.map((e) => e.data()["storie_images"][0]));
      duration.addAll(snapshot.documents.map((e) => e.data()["duration"][0]));
      documentidList
          .addAll(snapshot.documents.map((e) => e.documentID.toString()));
      uidList.addAll(snapshot.documents.map((e) => e.data()["uid"]));
      print(uidList);
      print(imgList);
      print(documentidList);
      uidList.map((e) {
        Firestore.instance.collection("Users").document(e).get().then((value) {
          dpurl.addAll(value.data()["location"]);
        });
      });
      print(uidList);
      print(dpurl);
    });
    setState(() {});
  }

  void setStateIfMounted() {
    if (mounted) setState(() {});
  }

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);

    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Color(4280032553),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30, left: 15, right: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: GradientText(
                      text: "Stories",
                      colors: [Colors.blue[400], Colors.blue[700]],
                      style: GoogleFonts.poppins(
                        fontSize: 35,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Align(
                      alignment: Alignment.topRight,
                      child: Container(
                          child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => StoriesAdd()));
                            },
                            child: Hero(
                              tag: "add",
                              child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                  ),
                                  child: Icon(
                                    Icons.add_rounded,
                                    color: Color(4278190106),
                                    size: 30,
                                  )),
                            ),
                          )
                        ],
                      ))),
                ],
              ),
            ),
            Fade(
              visible: true,
              duration: Duration(milliseconds: 500),
              child: Padding(
                padding: EdgeInsets.only(top: 30),
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      if (imgList.length != 0)
                        carouselSlider = CarouselSlider(
                            height: MediaQuery.of(context).size.height * 0.7,
                            initialPage: 0,
                            enlargeCenterPage: true,
                            autoPlay: true,
                            enableInfiniteScroll: false,
                            autoPlayAnimationDuration: Duration(seconds: 5),
                            autoPlayInterval: Duration(seconds: 10),
                            scrollDirection: Axis.horizontal,
                            onPageChanged: (index) {},
                            items: imgList.map((imgUrl) {
                              print(imgUrl);
                              var index = imgList.indexOf(imgUrl);
                              String image;
                              Firestore.instance
                                  .collection("Users")
                                  .document(uidList[index])
                                  .get()
                                  .then((value) {
                                image = value.data()["location"];
                                print(image);
                                print("donelllllllllll");
                              });
                              return Padding(
                                padding: const EdgeInsets.only(
                                    top: 10, left: 10, right: 10, bottom: 10),
                                child: GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    width: 250,
                                    decoration: BoxDecoration(
                                        boxShadow: <BoxShadow>[
                                          BoxShadow(
                                              color: Colors.blue,
                                              blurRadius: 15.0,
                                              offset: Offset(0.0, 0.75))
                                        ],
                                        borderRadius: BorderRadius.circular(20),
                                        color: Color(4278190106)),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Stack(
                                        children: [
                                          GestureDetector(
                                            onTap: () {},
                                            child: StoryView(
                                              storyItems: [
                                                StoryItem.pageVideo(imgUrl,
                                                    shown: true,
                                                    controller: storyController,
                                                    duration: Duration(
                                                        milliseconds:
                                                            duration[0]
                                                                .round()))
                                              ],
                                              onStoryShow: (s) {
                                                print(
                                                  MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      MediaQuery.of(context)
                                                          .size
                                                          .height,
                                                );
                                              },
                                              inline: true,
                                              onComplete: () {},
                                              progressPosition:
                                                  ProgressPosition.top,
                                              repeat: false,
                                              controller: storyController,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 25, left: 10, right: 10),
                                            child:
                                                FutureBuilder<DocumentSnapshot>(
                                                      future: Firestore.instance
                                                          .collection("Users")
                                                          .document(
                                                              uidList[index])
                                                          .get(),
                                                      builder:
                                                          (context, snapshot) {
                                                        if (snapshot
                                                                .connectionState !=
                                                            ConnectionState
                                                                .done) {
                                                          //print('project snapshot data is: ${snap.data}');
                                                          return Text(
                                                            "loading",
                                                            style: TextStyle(
                                                                fontSize: 0),
                                                          );
                                                        } else {
                                                          if (snapshot
                                                              .hasError) {
                                                            return Text(
                                                                "loading",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        0));
                                                          } else {
                                                            if (snapshot
                                                                .hasData) {
                                                              return Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top: 25,
                                                                        left: 0,
                                                                        right:
                                                                            10),
                                                                child: Row(
                                                                  children: [
                                                                    snapshot.data["location"] !=
                                                                            null
                                                                        ? GestureDetector(
                                                                            onTap:
                                                                                () {
                                                                              Navigator.push(
                                                                                  context,
                                                                                  MaterialPageRoute(
                                                                                      builder: (_) => Profile(
                                                                                            uidforprofile: snapshot.data["uid"],
                                                                                          )));
                                                                            },
                                                                            child:
                                                                                CircleAvatar(
                                                                              backgroundColor: Color(4278272638),
                                                                              backgroundImage: NetworkImage(snapshot.data["location"]),
                                                                            ),
                                                                          )
                                                                        : GestureDetector(
                                                                            onTap:
                                                                                () {
                                                                              Navigator.push(
                                                                                  context,
                                                                                  MaterialPageRoute(
                                                                                      builder: (_) => Profile(
                                                                                            uidforprofile: snapshot.data["uid"],
                                                                                          )));
                                                                            },
                                                                            child:
                                                                                CircleAvatar(
                                                                              backgroundColor: Color(4278272638),
                                                                              backgroundImage: AssetImage("assets/unknown.png"),
                                                                            ),
                                                                          ),
                                                                    SizedBox(
                                                                      width: 5,
                                                                    ),
                                                                    Expanded(
                                                                        child: SingleChildScrollView(
                                                                            scrollDirection: Axis.horizontal,
                                                                            child: Padding(
                                                                              padding: const EdgeInsets.only(right: 10),
                                                                              child: Text(snapshot.data["name"], style: TextStyle(fontSize: 25, fontFamily: "good", color: Colors.white)),
                                                                            )))
                                                                  ],
                                                                ),
                                                              );
                                                            } else {
                                                              return Text(
                                                                  "No Data");
                                                            }
                                                          }
                                                        }
                                                      },
                                                    ) ??
                                                    Container(),
                                          ),
                                          Align(
                                            alignment: Alignment.bottomCenter,
                                            child: Container(
                                              width: 300,
                                              height: 410,
                                              child: GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (_) =>
                                                              MoreStories(
                                                                  documentidList[
                                                                      index ??
                                                                          0])));
                                                },
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList()),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
