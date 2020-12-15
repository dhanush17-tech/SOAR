import 'package:SOAR/screens/chat/chat_home.dart';
import 'package:flutter/material.dart';
import 'package:SOAR/screens/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:SOAR/screens/feed.dart';

class TextScreen extends StatefulWidget {
  String id;
  String dpurl;
  String uid;
  String name;
  TextScreen({this.id, this.dpurl, this.name, this.uid});
  @override
  _TextScreenState createState() => _TextScreenState();
}

class _TextScreenState extends State<TextScreen>
    with SingleTickerProviderStateMixin {
  String dpurl;
  String name;
  String usertype;

  Future<void> _usertype() async {
    try {
      await Firestore.instance
          .collection("Users")
          .document(auth.currentUser.uid)
          .get()
          .then((value) {
        if (value.exists) {
          setState(() {
            usertype = value.data()["usertype"];
          });
        }
      });
    } catch (e) {}
  }

  fetchcurrentuserdetails() {
    Firestore.instance
        .collection("chat_room")
        .document(widget.id)
        .get()
        .then((value) {
      setState(() {
        usertype == "investor"
            ? dpurl = value.data()["dpurl_investor"]
            : dpurl = value.data()["dpurl"];
      });
    });
  }

  fetchnam() {
    Firestore.instance
        .collection("chat_room")
        .document(widget.id)
        .get()
        .then((value) {
      usertype == "investor"
          ? name = value.data()["name_investor"]
          : name = value.data()["name"];
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchcurrentuserdetails();
    print(widget.id);
    fetchnam();
    print(widget.uid);

    print(name);
    _usertype();
  }

  @override
  void dispose() {
    super.dispose();
  }

  TextEditingController _message = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color(4278190106),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 30, left: 10, right: 10),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                PageRouteBuilder(
                                    transitionDuration:
                                        Duration(milliseconds: 500),
                                    pageBuilder: (ctx, ani, i) => Profile()));
                          },
                          child: widget.dpurl != null
                              ? Hero(
                                  tag: "good",
                                  child: Container(
                                    height: 70,
                                    width: 70,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: NetworkImage(widget.dpurl),
                                            fit: BoxFit.fill),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                  ))
                              : Hero(
                                  tag: "good",
                                  child: Container(
                                    height: 70,
                                    width: 70,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(
                                                "assets/unknown.png"),
                                            fit: BoxFit.fill),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                  )),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 50,
                        width: 290,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Padding(
                              padding: const EdgeInsets.only(
                                top: 16,
                              ),
                              child: Text(widget.name,
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25,
                                    color: Colors.white,
                                  ))),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 0.83 * size.height,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(35),
                        topRight: Radius.circular(35)),
                    color: Color(4280099132)),
                child: Padding(
                  padding: EdgeInsets.only(bottom: 100),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: SingleChildScrollView(
                      reverse: true,
                      scrollDirection: Axis.vertical,
                      child: GestureDetector(
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 20,
                            left: 10,
                            right: 10,
                          ),
                          child: Align(
                            child: Column(
                              children: [
                                usertype == "investor"
                                    ? StreamBuilder(
                                        stream: Firestore.instance
                                            .collection("Users")
                                            .document(auth.currentUser.uid)
                                            .collection("following")
                                            .document(widget.id)
                                            .collection("chat")
                                            .orderBy("time", descending: false)
                                            .snapshots(),
                                        builder: (ctx, snapshot) {
                                          return snapshot.data != null
                                              ? ListView.separated(
                                                  reverse: false,
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  shrinkWrap: true,
                                                  itemCount: snapshot
                                                      .data.documents.length,
                                                  separatorBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    return SizedBox(
                                                      height: 20,
                                                    );
                                                  },
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    var c = snapshot
                                                        .data.documents[index];

                                                    return usertype ==
                                                            c["usertype"]
                                                        ? Align(
                                                            alignment: Alignment
                                                                .topRight,
                                                            child: Container(
                                                              width: 200,
                                                              height: 50,
                                                              decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.only(
                                                                      topLeft:
                                                                          Radius.circular(
                                                                              20),
                                                                      topRight:
                                                                          Radius.circular(
                                                                              20),
                                                                      bottomLeft:
                                                                          Radius.circular(
                                                                              20)),
                                                                  color: Colors
                                                                          .blue[
                                                                      900]),
                                                              child: Center(
                                                                child: Text(
                                                                  c["content"],
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        : Align(
                                                            alignment: Alignment
                                                                .topLeft,
                                                            child: Container(
                                                              width: 200,
                                                              height: 50,
                                                              decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.only(
                                                                      topLeft:
                                                                          Radius.circular(
                                                                              20),
                                                                      topRight:
                                                                          Radius.circular(
                                                                              20),
                                                                      bottomRight:
                                                                          Radius.circular(
                                                                              20)),
                                                                  color: Colors
                                                                      .blue),
                                                              child: Center(
                                                                child: Text(
                                                                  c["content"],
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                  },
                                                )
                                              : Container();
                                        })
                                    : StreamBuilder(
                                        stream: Firestore.instance
                                            .collection("Users")
                                            .document(widget.uid)
                                            .collection("following")
                                            .document(widget.id)
                                            .collection("chat")
                                            .orderBy("time", descending: false)
                                            .snapshots(),
                                        builder: (ctx, snapshot) {
                                          return snapshot.data != null
                                              ? ListView.separated(
                                                  reverse: false,
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  shrinkWrap: true,
                                                  itemCount: snapshot
                                                      .data.documents.length,
                                                  separatorBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    return SizedBox(
                                                      height: 20,
                                                    );
                                                  },
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    var c = snapshot
                                                        .data.documents[index];

                                                    return usertype ==
                                                            c["usertype"]
                                                        ? Align(
                                                            alignment: Alignment
                                                                .topRight,
                                                            child: Container(
                                                              width: 200,
                                                              height: 50,
                                                              decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.only(
                                                                      topLeft:
                                                                          Radius.circular(
                                                                              20),
                                                                      topRight:
                                                                          Radius.circular(
                                                                              20),
                                                                      bottomLeft:
                                                                          Radius.circular(
                                                                              20)),
                                                                  color: Colors
                                                                          .blue[
                                                                      900]),
                                                              child: Center(
                                                                child: Text(
                                                                  c["content"],
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        : Align(
                                                            alignment: Alignment
                                                                .topLeft,
                                                            child: Container(
                                                              width: 200,
                                                              height: 50,
                                                              decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.only(
                                                                      topLeft:
                                                                          Radius.circular(
                                                                              20),
                                                                      topRight:
                                                                          Radius.circular(
                                                                              20),
                                                                      bottomRight:
                                                                          Radius.circular(
                                                                              20)),
                                                                  color: Colors
                                                                      .blue),
                                                              child: Center(
                                                                child: Text(
                                                                  c["content"],
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                  },
                                                )
                                              : Container();
                                        }),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )),
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
                child: Form(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      controller: _message,
                      decoration: InputDecoration(
                          suffix: Padding(
                            padding: const EdgeInsets.only(right: 10, top: 40),
                            child: FittedBox(
                              child: GestureDetector(
                                onTap: () {
                                  usertype == "investor"
                                      ? Firestore.instance
                                          .collection("Users")
                                          .document(auth.currentUser.uid) 
                                          .collection("following")
                                          .document(widget.id)
                                          .collection("chat")
                                          .add({
                                          "usertype": usertype,
                                          "content": _message.text,
                                          "time": DateTime.now().toString()
                                        }).then((value) => _message.clear()
                                        )
                                      : Firestore.instance
                                          .collection("Users")
                                          .document(widget.uid)
                                          .collection("following")
                                          .document(auth.currentUser.uid)
                                          .collection("chat")
                                          .add({
                                          "usertype": usertype,
                                          "content": _message.text,
                                          "time": DateTime.now().toString()
                                        }).then((value) => _message.clear());
                                },
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(4278190106),
                                  ),
                                  child: Icon(
                                    Icons.send,
                                    color: Color(4278228470),
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          border: InputBorder.none,
                          hintText: "Type your message here",
                          hintStyle: GoogleFonts.poppins(
                              fontSize: 17, fontWeight: FontWeight.w500)),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
