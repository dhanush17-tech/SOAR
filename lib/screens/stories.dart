import 'package:SOAR/screens/feed.dart';
import 'package:SOAR/screens/profile.dart';
import 'package:SOAR/screens/stories_add.dart';
import 'package:SOAR/storiesvie.dart';
import 'package:fade/fade.dart';
import 'package:flutter/material.dart';
import 'package:easy_gradient_text/easy_gradient_text.dart  ';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:SOAR/main_constraints.dart  ';
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
    now = DateTime.now();

    getstory();

    getman();

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

  Future getstory() async {
    QuerySnapshot _query = await Firestore.instance
        .collection("stories")
        .getDocuments()
        .then((snapshot) {
      imgList.addAll(snapshot.documents
          .where((element) =>
              now.difference(DateTime.parse(element["timeago"])).abs().inHours <
              24)
          .map((e) => e.data()["storie_images"][0]));

      duration.addAll(snapshot.documents
          .where((element) =>
              now.difference(DateTime.parse(element["timeago"])).abs().inHours <
              24)
          .map((e) => e.data()["duration"][0]));
      documentidList.addAll(snapshot.documents
          .where((element) =>
              now.difference(DateTime.parse(element["timeago"])).abs().inHours <
              24)
          .map((e) => e.documentID.toString()));
      uidList.addAll(snapshot.documents
          .where((element) =>
              now.difference(DateTime.parse(element["timeago"])).abs().inHours <
              24)
          .map((e) => e.data()["uid"]));
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

  bool istodaycheck;
  DateTime now = DateTime.now();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: man == false ? light_background : dark_background,
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
                      colors: [Colors.blue, Colors.blueAccent],
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
                                    color: Colors.indigo,
                                  ),
                                  child: Icon(
                                    Icons.add_rounded,
                                    color: Colors.white,
                                    size: 30,
                                  )),
                            ),
                          )
                        ],
                      ))),
                ],
              ),
            ),
            imgList.length == 0
                ? Padding(
                    padding: EdgeInsets.only(top: 100),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "It seems to be that you will be\nthe first one to uplaod a quick pitch !!",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.sourceSansPro(
                              fontWeight: FontWeight.w600,
                              fontSize: 21,
                              color: Color(4278228470)),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Image.asset(
                          "assets/nothing.png",
                        )
                      ],
                    ),
                  )
                : Fade(
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
                                  options: CarouselOptions(
                                    height: MediaQuery.of(context).size.height *
                                        0.7,
                                    initialPage: 0,
                                    enlargeCenterPage: true,
                                    autoPlay: true,
                                    enableInfiniteScroll: false,
                                    autoPlayAnimationDuration:
                                        Duration(seconds: 5),
                                    autoPlayInterval: Duration(seconds: 10),
                                    scrollDirection: Axis.horizontal,
                                  ),
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
                                    return imgList.length == 0
                                        ? Column(
                                            children: [
                                              Text(
                                                "It seems to be that you will be\nthe first one to uplaod a quick pitch",
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    color: Color(4278228470)),
                                              ),
                                              Image.asset(
                                                "assets/nothing.png",
                                              )
                                            ],
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.only(
                                                top: 20,
                                                left: 10,
                                                right: 10,
                                                bottom: 20),
                                            child: GestureDetector(
                                              onTap: () {},
                                              child: Container(
                                                width: 250,
                                                decoration: BoxDecoration(
                                                    boxShadow: <BoxShadow>[
                                                      BoxShadow(
                                                          color: Colors.blue,
                                                          blurRadius: 15.0,
                                                          offset:
                                                              Offset(0.0, 0.75))
                                                    ],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    color: Color(4278190106)),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  child: Stack(
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {},
                                                        child: StoryView(
                                                          storyItems: [
                                                            StoryItem.pageVideo(
                                                              imgUrl,
                                                              ismute: true,
                                                              shown: true,
                                                              controller:
                                                                  storyController,
                                                              duration: Duration(
                                                                  milliseconds:
                                                                      duration[
                                                                              0]
                                                                          .round()),
                                                            )
                                                          ],
                                                          onStoryShow: (s) {
                                                            print(
                                                              MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width /
                                                                  MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height,
                                                            );
                                                          },
                                                          inline: true,
                                                          onComplete: () {},
                                                          progressPosition:
                                                              ProgressPosition
                                                                  .top,
                                                          repeat: false,
                                                          controller:
                                                              storyController,
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                top: 25,
                                                                left: 10,
                                                                right: 10),
                                                        child: FutureBuilder<
                                                                DocumentSnapshot>(
                                                              future: Firestore
                                                                  .instance
                                                                  .collection(
                                                                      "Users")
                                                                  .document(
                                                                      uidList[
                                                                          index])
                                                                  .get(),
                                                              builder: (context,
                                                                  snapshot) {
                                                                if (snapshot
                                                                        .connectionState !=
                                                                    ConnectionState
                                                                        .done) {
                                                                  //print('project snapshot data is: ${snap.data}');
                                                                  return Text(
                                                                    "",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            0),
                                                                  );
                                                                } else {
                                                                  if (snapshot
                                                                      .hasError) {
                                                                    return Text(
                                                                        "",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                0));
                                                                  } else {
                                                                    if (snapshot
                                                                        .hasData) {
                                                                      return Padding(
                                                                        padding: const EdgeInsets.only(
                                                                            top:
                                                                                25,
                                                                            left:
                                                                                0,
                                                                            right:
                                                                                10),
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            snapshot.data["location"] != null
                                                                                ? GestureDetector(
                                                                                    onTap: () {
                                                                                      Navigator.push(
                                                                                          context,
                                                                                          MaterialPageRoute(
                                                                                              builder: (_) => Profile(
                                                                                                    uidforprofile: snapshot.data["uid"],
                                                                                                  )));
                                                                                    },
                                                                                    child: CircleAvatar(
                                                                                      backgroundColor: Color(4278272638),
                                                                                      backgroundImage: NetworkImage(snapshot.data["location"]),
                                                                                      radius: 20,
                                                                                    ),
                                                                                  )
                                                                                : GestureDetector(
                                                                                    onTap: () {
                                                                                      Navigator.push(
                                                                                          context,
                                                                                          MaterialPageRoute(
                                                                                              builder: (_) => Profile(
                                                                                                    uidforprofile: snapshot.data["uid"],
                                                                                                  )));
                                                                                    },
                                                                                    child: CircleAvatar(
                                                                                      backgroundColor: Color(4278272638),
                                                                                      backgroundImage: AssetImage("assets/unknown.png"),
                                                                                      radius: 20,
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
                                                        alignment: Alignment
                                                            .bottomCenter,
                                                        child: Container(
                                                          width: 300,
                                                          height: 410,
                                                          child:
                                                              GestureDetector(
                                                            onTap: () {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (_) =>
                                                                          MoreStories(documentidList[index ??
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
