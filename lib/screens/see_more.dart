import 'package:SOAR/screens/profile.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'feed.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:SOAR/main_constraints.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    getman();
    _fetchUserinfoForSettingsPage();
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

  TextEditingController _comment = TextEditingController();
  GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);

    return usertype == "investor"
        ? Scaffold(
            backgroundColor: man == false ? light_background : dark_background,
            body: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: man == false ? light_background : dark_background,
              child: Stack(children: [
                Container(
                  height: MediaQuery.of(context).size.height - 80,
                  child: SingleChildScrollView(
                      reverse: true,
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 05, left: 15),
                            child: StreamBuilder(
                              stream: Firestore.instance
                                  .collection("Feed")
                                  .document(widget.seemore)
                                  .snapshots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                return snapshot.data == null
                                    ? Container()
                                    : ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: 1,
                                        itemBuilder:
                                            (BuildContext context, int i) {
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
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 10.0),
                                                          child:
                                                              cool["location"] ==
                                                                      null
                                                                  ? Stack(
                                                                      children: [
                                                                        CircleAvatar(
                                                                          backgroundImage:
                                                                              AssetImage(
                                                                            "assets/unknown.png",
                                                                          ),
                                                                          backgroundColor:
                                                                              Color(4278272638),
                                                                          radius:
                                                                              35,
                                                                        ),
                                                                      ],
                                                                    )
                                                                  : Stack(
                                                                      children: [
                                                                        CircleAvatar(
                                                                          backgroundImage:
                                                                              NetworkImage(cool["location"]),
                                                                          backgroundColor:
                                                                              Color(4278272638),
                                                                          radius:
                                                                              35,
                                                                        ),
                                                                      ],
                                                                    ),
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              snap["title"],
                                                              style: TextStyle(
                                                                  fontSize: 55,
                                                                  fontFamily:
                                                                      "good",
                                                                  color: Color(
                                                                      4278228470)),
                                                            ),
                                                            Text(
                                                              cool["name"],
                                                              style: TextStyle(
                                                                  fontSize: 25,
                                                                  height: 0.3,
                                                                  fontFamily:
                                                                      "good",
                                                                  color: man ==
                                                                          false
                                                                      ? sub_heading_light
                                                                      : sub_heading_dark),
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
                            height: MediaQuery.of(context).size.height * 0.75,
                            child: SingleChildScrollView(
                              reverse: true,
                              scrollDirection: Axis.vertical,
                              child: Padding(
                                padding: EdgeInsets.only(bottom: bottom * 0.34),
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
                                                        separatorBuilder:
                                                            (ctx, i) =>
                                                                SizedBox(
                                                                    height: 20),
                                                        shrinkWrap: true,
                                                        physics:
                                                            NeverScrollableScrollPhysics(),
                                                        itemCount: snapshot.data
                                                            .documents.length,
                                                        itemBuilder: (ctx, i) {
                                                          DocumentSnapshot
                                                              comment = snapshot
                                                                  .data
                                                                  .documents[i];
                                                          return StreamBuilder(
                                                            stream: Firestore
                                                                .instance
                                                                .collection(
                                                                    "Users")
                                                                .document(
                                                                    comment[
                                                                        "uid"])
                                                                .snapshots(),
                                                            builder: (BuildContext
                                                                    context,
                                                                AsyncSnapshot
                                                                    snapshot) {
                                                              var can =
                                                                  snapshot.data;
                                                              return snapshot
                                                                          .data ==
                                                                      null
                                                                  ? Container()
                                                                  : Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              8.0),
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          can["location"] == null
                                                                              ? GestureDetector(
                                                                                  onTap: () {
                                                                                    Navigator.push(context, MaterialPageRoute(builder: (_) => Profile(uidforprofile: can["uid"])));
                                                                                  },
                                                                                  child: CircleAvatar(
                                                                                    backgroundImage: AssetImage(
                                                                                      "assets/unknown.png",
                                                                                    ),
                                                                                    backgroundColor: Color(4278272638),
                                                                                    radius: 25,
                                                                                  ),
                                                                                )
                                                                              : GestureDetector(
                                                                                  onTap: () {
                                                                                    Navigator.push(context, MaterialPageRoute(builder: (_) => Profile(uidforprofile: can["uid"])));
                                                                                  },
                                                                                  child: CircleAvatar(
                                                                                    backgroundImage: NetworkImage(can["location"]),
                                                                                    backgroundColor: Color(4278272638),
                                                                                    radius: 25,
                                                                                  ),
                                                                                ),
                                                                          SizedBox(
                                                                            width:
                                                                                10,
                                                                          ),
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(top: 5),
                                                                            child:
                                                                                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                                              Text(
                                                                                can["name"],
                                                                                style: TextStyle(color: man == false ? sub_heading_light : sub_heading_dark, fontWeight: FontWeight.bold),
                                                                              ),
                                                                              Text(comment["comment"], style: TextStyle(color: Color(4278228470).withOpacity(0.7), fontFamily: "good", fontSize: 20)),
                                                                            ]),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    );
                                                            },
                                                          );
                                                        }),
                                                  ],
                                                )
                                              : Container();
                                        }),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      )),
                ),
                typearea()
              ]),
            ))
        : Scaffold(
            backgroundColor: man == false ? light_background : dark_background,
            body: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: man == false ? light_background : dark_background,
              child: Stack(children: [
                Container(
                  child: SingleChildScrollView(
                      reverse: true,
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 05, left: 15),
                            child: StreamBuilder(
                              stream: Firestore.instance
                                  .collection("Feed")
                                  .document(widget.seemore)
                                  .snapshots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                return snapshot.data == null
                                    ? Container()
                                    : ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: 1,
                                        itemBuilder:
                                            (BuildContext context, int i) {
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
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 10.0),
                                                          child:
                                                              cool["location"] ==
                                                                      null
                                                                  ? Stack(
                                                                      children: [
                                                                        CircleAvatar(
                                                                          backgroundImage:
                                                                              AssetImage(
                                                                            "assets/unknown.png",
                                                                          ),
                                                                          backgroundColor:
                                                                              Color(4278272638),
                                                                          radius:
                                                                              35,
                                                                        ),
                                                                      ],
                                                                    )
                                                                  : Stack(
                                                                      children: [
                                                                        CircleAvatar(
                                                                          backgroundImage:
                                                                              NetworkImage(cool["location"]),
                                                                          backgroundColor:
                                                                              Color(4278272638),
                                                                          radius:
                                                                              35,
                                                                        ),
                                                                      ],
                                                                    ),
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              snap["title"],
                                                              style: TextStyle(
                                                                  fontSize: 55,
                                                                  fontFamily:
                                                                      "good",
                                                                  color: Color(
                                                                      4278228470)),
                                                            ),
                                                            Text(
                                                              cool["name"],
                                                              style: TextStyle(
                                                                  fontSize: 25,
                                                                  height: 0.3,
                                                                  fontFamily:
                                                                      "good",
                                                                  color: man ==
                                                                          false
                                                                      ? feed_details_title_light
                                                                      : feed_details_title_dark),
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
                            height: MediaQuery.of(context).size.height - 100,
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
                                                      separatorBuilder: (ctx,
                                                              i) =>
                                                          SizedBox(height: 20),
                                                      shrinkWrap: true,
                                                      physics:
                                                          NeverScrollableScrollPhysics(),
                                                      itemCount: snapshot.data
                                                          .documents.length,
                                                      itemBuilder: (ctx, i) {
                                                        DocumentSnapshot
                                                            comment = snapshot
                                                                .data
                                                                .documents[i];
                                                        return StreamBuilder(
                                                          stream: Firestore
                                                              .instance
                                                              .collection(
                                                                  "Users")
                                                              .document(comment[
                                                                  "uid"])
                                                              .snapshots(),
                                                          builder: (BuildContext
                                                                  context,
                                                              AsyncSnapshot
                                                                  snapshot) {
                                                            var can =
                                                                snapshot.data;
                                                            return snapshot
                                                                        .data ==
                                                                    null
                                                                ? Container()
                                                                : Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            8.0),
                                                                    child: Row(
                                                                      children: [
                                                                        can["location"] ==
                                                                                null
                                                                            ? GestureDetector(
                                                                                onTap: () {
                                                                                  Navigator.push(context, MaterialPageRoute(builder: (_) => Profile(uidforprofile: can["uid"])));
                                                                                },
                                                                                child: CircleAvatar(
                                                                                  backgroundImage: AssetImage(
                                                                                    "assets/unknown.png",
                                                                                  ),
                                                                                  backgroundColor: Color(4278272638),
                                                                                  radius: 25,
                                                                                ),
                                                                              )
                                                                            : GestureDetector(
                                                                                onTap: () {
                                                                                  Navigator.push(context, MaterialPageRoute(builder: (_) => Profile(uidforprofile: can["uid"])));
                                                                                },
                                                                                child: CircleAvatar(
                                                                                  backgroundImage: NetworkImage(can["location"]),
                                                                                  backgroundColor: Color(4278272638),
                                                                                  radius: 25,
                                                                                ),
                                                                              ),
                                                                        SizedBox(
                                                                          width:
                                                                              10,
                                                                        ),
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.only(top: 5),
                                                                          child: Column(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Text(
                                                                                  can["name"],
                                                                                  style: TextStyle(color: man == false ? sub_heading_light : sub_heading_dark, fontWeight: FontWeight.bold),
                                                                                ),
                                                                                Text(comment["comment"], style: TextStyle(color: Color(4278228470).withOpacity(0.7), fontFamily: "good", fontSize: 20)),
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
                        ],
                      )),
                ),
              ]),
            ));
  }

  Widget typearea() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Form(
        key: _key,
        child: Container(
          height: 80,
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              color: Colors.white),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Align(
                alignment: Alignment.center,
                child: Form(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Container(
                      width: 280,
                      child: TextFormField(
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        controller: _comment,
                        validator: (value) => value.length == 0 ? "" : null,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Type your message here",
                            hintStyle: GoogleFonts.poppins(
                                fontSize: 17, fontWeight: FontWeight.w500)),
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                child: Padding(
                  padding: const EdgeInsets.all(
                    10,
                  ),
                  child: FittedBox(
                    child: GestureDetector(
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
                          });
                          _comment.clear();
                        }
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(colors: [
                              Colors.blue[400],
                              Colors.blueAccent[700]
                            ])),
                        child: Icon(
                          Icons.send,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
