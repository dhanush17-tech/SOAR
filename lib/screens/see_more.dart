import 'package:SOAR/screens/profile.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'feed.dart';

class SeeMore extends StatefulWidget {
  String seemore;
  SeeMore({this.seemore});

  @override
  _SeeMoreState createState() => _SeeMoreState();
}

class _SeeMoreState extends State<SeeMore> {
  Future<void> _fetchUserinfoForSettingsPage() async {
    try {
      await Firestore.instance
          .collection("Users")
          .document(auth.currentUser.uid)
          .get()
          .then((value) {
        if (value.exists) {
          setState(() {
            dpurl = value.data()["location"];
            name = value.data()["name"];
            tagline = value.data()["tagline"];
            usertype = value.data()["usertype"];
          });
        }
      });
    } catch (e) {}
  }

  String usertype;
  String name;
  String dpurl;
  String tagline;

  AnimationController _controller;
  Animation _animation;
  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchUserinfoForSettingsPage();
  }

  TextEditingController _comment = TextEditingController();
  GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);

    return Scaffold(
        backgroundColor: Color(4278190106),
        body: Stack(children: [
          Column(children: [
            Padding(
              padding: EdgeInsets.only(top: 05, left: 15),
              child: StreamBuilder(
                stream: Firestore.instance
                    .collection("Feed")
                    .document(widget.seemore)
                    .snapshots(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  return snapshot.data == null
                      ? Container()
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: 1,
                          itemBuilder: (BuildContext context, int i) {
                            var snap = snapshot.data;
                            return StreamBuilder(
                              stream: Firestore.instance
                                  .collection("Users")
                                  .document(snap["uid"])
                                  .snapshots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                var cool = snapshot.data;
                                return cool == null
                                    ? Container()
                                    : Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 10.0),
                                            child: cool["location"] == null
                                                ? Stack(
                                                    children: [
                                                      CircleAvatar(
                                                        backgroundImage:
                                                            AssetImage(
                                                          "assets/unknown.png",
                                                        ),
                                                        backgroundColor:
                                                            Color(4278272638),
                                                        radius: 35,
                                                      ),
                                                    ],
                                                  )
                                                : Stack(
                                                    children: [
                                                      CircleAvatar(
                                                        backgroundImage:
                                                            NetworkImage(cool[
                                                                "location"]),
                                                        backgroundColor:
                                                            Color(4278272638),
                                                        radius: 35,
                                                      ),
                                                    ],
                                                  ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                snap["title"],
                                                style: TextStyle(
                                                    fontSize: 55,
                                                    fontFamily: "good",
                                                    color: Color(4278228470)),
                                              ),
                                              Text(
                                                cool["name"],
                                                style: TextStyle(
                                                    fontSize: 25,
                                                    height: 0.3,
                                                    fontFamily: "good",
                                                    color: Colors.white
                                                        .withOpacity(0.5)),
                                              ),
                                            ],
                                          ),
                                        ],
                                      );
                              },
                            );
                          },
                        );
                },
              ),
            ),
            SizedBox(height: 10),
            Container(
              height: MediaQuery.of(context).size.height * 0.72,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    StreamBuilder(
                        stream: Firestore.instance
                            .collection("Feed")
                            .document(widget.seemore.toString())
                            .collection("comments")
                            .orderBy("date", descending: false)
                            .snapshots(),
                        builder: (ctx, snapshot) {
                          return snapshot.data != null
                              ? Column(
                                  children: [
                                    ListView.separated(
                                        separatorBuilder: (ctx, i) =>
                                            SizedBox(height: 20),
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount:
                                            snapshot.data.documents.length,
                                        itemBuilder: (ctx, i) {
                                          DocumentSnapshot comment =
                                              snapshot.data.documents[i];
                                          return StreamBuilder(
                                            stream: Firestore.instance
                                                .collection("Users")
                                                .document(comment["uid"])
                                                .snapshots(),
                                            builder: (BuildContext context,
                                                AsyncSnapshot snapshot) {
                                              var man = snapshot.data;
                                              return snapshot.data == null
                                                  ? Container()
                                                  : Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Row(
                                                        children: [
                                                          man["location"] ==
                                                                  null
                                                              ? GestureDetector(
                                                                  onTap: () {
                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (_) =>
                                                                                Profile(uidforprofile: man["uid"])));
                                                                  },
                                                                  child:
                                                                      CircleAvatar(
                                                                    backgroundImage:
                                                                        AssetImage(
                                                                      "assets/unknown.png",
                                                                    ),
                                                                    backgroundColor:
                                                                        Color(
                                                                            4278272638),
                                                                    radius: 25,
                                                                  ),
                                                                )
                                                              : GestureDetector(
                                                                  onTap: () {
                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (_) =>
                                                                                Profile(uidforprofile: man["uid"])));
                                                                  },
                                                                  child:
                                                                      CircleAvatar(
                                                                    backgroundImage:
                                                                        NetworkImage(
                                                                            man["location"]),
                                                                    backgroundColor:
                                                                        Color(
                                                                            4278272638),
                                                                    radius: 25,
                                                                  ),
                                                                ),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 5),
                                                            child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    man["name"],
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                  Text(
                                                                      comment[
                                                                          "comment"],
                                                                      style: TextStyle(
                                                                          color: Colors.white.withOpacity(
                                                                              0.7),
                                                                          fontFamily:
                                                                              "good",
                                                                          fontSize:
                                                                              20)),
                                                                ]),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                            },
                                          );
                                        }),
                                    SizedBox(
                                      height: 5,
                                    ),
                                  ],
                                )
                              : Container();
                        }),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            )
          ]),
          usertype == "entrepreneur"
              ? Container()
              : Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 80,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20)),
                        color: Colors.white),
                    child: Align(
                      alignment: Alignment.center,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Form(
                              key: _key,
                              child: Container(
                                  height: 35,
                                  width: MediaQuery.of(context).size.width *
                                      0.83,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: Color(4278228470))),
                                  child: TextFormField(
                                    style: TextStyle(
                                      color: Color(4278190106),
                                    ),
                                    controller: _comment,
                                    validator: (value) =>
                                        value.length == 0 ? "" : null,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                        contentPadding: EdgeInsets.only(
                                            left: 10, right: 10, bottom: 10)),
                                  ))),
                                  SizedBox(width: 8,),
                          GestureDetector(
                            onTap: () {
                              if (_key.currentState.validate()) {
                                Firestore.instance
                                    .collection("Feed")
                                    .document(widget.seemore)
                                    .collection("comments")
                                    .add({
                                  "comment": _comment.text,
                                  "uid": auth.currentUser.uid,
                                  "date": DateTime.now().toString(),
                                  "location": dpurl,
                                  "name": name,
                                  "tagline": tagline
                                }).then((value) => _comment.clear());
                              }
                            },
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                            gradient: LinearGradient(colors: [Colors.blue[400], Colors.blueAccent[700]])                                  ),
                              child: Icon(
                                Icons.send,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
        ]));
  }
}
