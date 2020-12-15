import 'package:SOAR/screens/profile.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
            dpurl = value.data()["dpurl"];
            name = value.data()["name"];
            tagline = value.data()["tagline"];
          });
        }
      });
    } catch (e) {}
  }

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
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: 1,
                    itemBuilder: (BuildContext context, int i) {
                      var snap = snapshot.data;
                      return Row(
                        children: [
                          snap["dpurl"] == null
                              ? Stack(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: AssetImage(
                                        "assets/unknown.png",
                                      ),
                                      backgroundColor: Color(4278272638),
                                      radius: 45,
                                    ),
                                  ],
                                )
                              : Stack(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(snap["dpurl"]),
                                      backgroundColor: Colors.white,
                                      radius: 55,
                                    ),
                                  ],
                                ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                snap["title"],
                                style: TextStyle(
                                    fontSize: 75,
                                    fontFamily: "good",
                                    color: Color(4278228470)),
                              ),
                              Text(
                                snap["owener"],
                                style: TextStyle(
                                    fontSize: 25,
                                    fontFamily: "good",
                                    color: Colors.white.withOpacity(0.5)),
                              ),
                            ],
                          ),
                        ],
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
                reverse: true,
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
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                comment["dpurl"] == null
                                                    ? Stack(
                                                        children: [
                                                          GestureDetector(
                                                            onTap: () {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (_) =>
                                                                          Profile(
                                                                              uidforprofile: comment["uid"])));
                                                            },
                                                            child: CircleAvatar(
                                                              backgroundImage:
                                                                  AssetImage(
                                                                "assets/unknown.png",
                                                              ),
                                                              backgroundColor:
                                                                  Color(
                                                                      4278272638),
                                                              radius: 25,
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    : Stack(
                                                        children: [
                                                          GestureDetector(
                                                            onTap: () {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (_) =>
                                                                          Profile(
                                                                              uidforprofile: comment["uid"])));
                                                            },
                                                            child: GestureDetector(
                                                              onTap: (){
                                                                 Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (_) =>
                                                                          Profile(
                                                                              uidforprofile: comment["uid"])));
                                                              },
                                                                                                                          child: CircleAvatar(
                                                                backgroundImage:
                                                                    NetworkImage(
                                                                        comment[
                                                                            "dpurl"]),
                                                                backgroundColor:
                                                                    Colors.white,
                                                                radius: 25,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 25),
                                                  child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          comment["name"],
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        Text(comment["comment"],
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white
                                                                    .withOpacity(
                                                                        0.7),
                                                                fontFamily:
                                                                    "good",
                                                                fontSize: 20)),
                                                        Text(
                                                            comment["comment"]),
                                                      ]),
                                                ),
                                              ],
                                            ),
                                          );
                                        }),
                                    SizedBox(
                                      height: 5,
                                    ),
                                  ],
                                )
                              : Container();
                        }),
                  ],
                ),
              ),
            )
          ]),
          Align(
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
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Form(
                            key: _key,
                            child: Container(
                                height: 35,
                                width: MediaQuery.of(context).size.width * 0.83,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border:
                                        Border.all(color: Color(4278228470))),
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
                        Padding(
                          padding: const EdgeInsets.all(8),
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
                                  "dpurl": dpurl,
                                  "name": name,
                                  "tagline": tagline
                                }).then((value) => _comment.clear());
                              }
                            },
                            child: Container(
                              height: 33,
                              width: 33,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(4278228470),
                              ),
                              child: Icon(
                                Icons.arrow_forward_rounded,
                                color: Color(4278190106),
                                size: 25,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )),
        ]));
  }
}
