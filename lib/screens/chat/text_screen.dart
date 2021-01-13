import 'package:SOAR/main.dart';
import 'package:SOAR/screens/chat/chat_home.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:SOAR/screens/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:SOAR/screens/feed.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../video_conferencing.dart';

class TextScreen extends StatefulWidget {
  String id;
  String dpurl;
  String uid;
  int widgeti;
  String name;
  TextScreen({this.id, this.dpurl, this.name, this.uid, this.widgeti});
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
            ? dpurl = value.data()["location_investor"]
            : dpurl = value.data()["location"];
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

    final fbm = FirebaseMessaging();
    fbm.requestNotificationPermissions();
    fbm.configure(
      onMessage: (msg) {
        print(msg);
        return;
      },
      onLaunch: (msg) {
        print(msg);
        return;
      },
      onResume: (msg) {
        print(msg);
        return;
      },
    );
    fbm.subscribeToTopic('Users');
  }

  @override
  void dispose() {
    super.dispose();
  }

  TextEditingController _message = TextEditingController();
  GlobalKey<FormState> _key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);

    return Scaffold(
      backgroundColor: Color(4278190106),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Color(4278190106),
        child: Stack(
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
                          padding: const EdgeInsets.only(
                              top: 30, left: 10, right: 10),
                          child: GestureDetector(
                            onTap: () {
                              usertype == "investor"
                                  ? Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                          transitionDuration:
                                              Duration(milliseconds: 500),
                                          pageBuilder: (ctx, ani, i) => Profile(
                                                uidforprofile: widget.id,
                                              )))
                                  : Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                          transitionDuration:
                                              Duration(milliseconds: 500),
                                          pageBuilder: (ctx, ani, i) => Profile(
                                                uidforprofile: widget.uid,
                                              )));
                            },
                            child: widget.dpurl != null
                                ? Hero(
                                    tag: "good+${widget.widgeti}",
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
                                    tag: "good+${widget.widgeti}",
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
                          width: MediaQuery.of(context).size.width * 0.6,
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
                  Hero(
                    tag: "hf",
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20, right: 10),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) => VideoCon()));
                        },
                        child: Container(
                            padding: EdgeInsets.all(3),
                            height: 35,
                            width: 35,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(4278228470),
                            ),
                            child: Image.asset("assets/camera.png",
                                color: Color(4278190106))),
                      ),
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
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(35),
                            topRight: Radius.circular(35)),
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
                                                .orderBy("time",
                                                    descending: false)
                                                .snapshots(),
                                            builder: (ctx, snapshot) {
                                              return snapshot.data != null
                                                  ? ListView.separated(
                                                      physics:
                                                          NeverScrollableScrollPhysics(),
                                                      shrinkWrap: true,
                                                      itemCount: snapshot.data
                                                          .documents.length,
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
                                                        var c = snapshot.data
                                                            .documents[index];

                                                        return usertype ==
                                                                c["usertype"]
                                                            ? Align(
                                                                alignment:
                                                                    Alignment
                                                                        .topRight,
                                                                child:
                                                                    Container(
                                                                  decoration: BoxDecoration(
                                                                      color: Colors
                                                                          .blue,
                                                                      borderRadius: BorderRadius.only(
                                                                          topLeft: Radius.circular(
                                                                              10),
                                                                          topRight: Radius.circular(
                                                                              10),
                                                                          bottomLeft:
                                                                              Radius.circular(10))),
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              8),
                                                                  width: 200,
                                                                  child:
                                                                      ClipRRect(
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Padding(
                                                                        padding: const EdgeInsets.only(
                                                                            top:
                                                                                8.0,
                                                                            left:
                                                                                8.0,
                                                                            right:
                                                                                8.0),
                                                                        child:
                                                                            Column(
                                                                          children: [
                                                                            Text(
                                                                              c["content"],
                                                                              style: GoogleFonts.poppins(fontWeight: FontWeight.bold, letterSpacing: 1, color: Colors.white),
                                                                            ),
                                                                            Align(
                                                                              alignment: Alignment.bottomRight,
                                                                              child: Text(
                                                                                timeago.format(DateTime.parse(c["timeago"])),
                                                                                style: GoogleFonts.poppins(fontWeight: FontWeight.bold, letterSpacing: 1, color: Colors.black.withOpacity(0.5), fontSize: 10),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              )
                                                            : Align(
                                                                alignment:
                                                                    Alignment
                                                                        .topLeft,
                                                                child:
                                                                    Container(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              8),
                                                                  width: 200,
                                                                  decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius.only(
                                                                          topLeft: Radius.circular(
                                                                            10,
                                                                          ),
                                                                          topRight: Radius.circular(10),
                                                                          bottomRight: Radius.circular(10)),
                                                                      color: Colors.blue.withOpacity(0.5)),
                                                                  child:
                                                                      ClipRRect(
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(8.0),
                                                                        child:
                                                                            Column(
                                                                          children: [
                                                                            Text(
                                                                              c["content"],
                                                                              style: GoogleFonts.poppins(fontWeight: FontWeight.bold, letterSpacing: 1, color: Colors.white),
                                                                            ),
                                                                            Align(
                                                                              alignment: Alignment.bottomLeft,
                                                                              child: Text(
                                                                                timeago.format(DateTime.parse(c["timeago"])),
                                                                                style: GoogleFonts.poppins(fontWeight: FontWeight.bold, letterSpacing: 1, color: Colors.black.withOpacity(0.5), fontSize: 10),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
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
                                                .orderBy("time",
                                                    descending: false)
                                                .snapshots(),
                                            builder: (ctx, snapshot) {
                                              return snapshot.data != null
                                                  ? ListView.separated(
                                                      physics:
                                                          NeverScrollableScrollPhysics(),
                                                      shrinkWrap: true,
                                                      itemCount: snapshot.data
                                                          .documents.length,
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
                                                        var c = snapshot.data
                                                            .documents[index];

                                                        return usertype ==
                                                                c["usertype"]
                                                            ? Align(
                                                                alignment:
                                                                    Alignment
                                                                        .topRight,
                                                                child:
                                                                    Container(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              8,
                                                                          right:
                                                                              8,
                                                                          top:
                                                                              8),
                                                                  width: 200,
                                                                  decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius.only(
                                                                          topLeft: Radius.circular(
                                                                              10),
                                                                          topRight: Radius.circular(
                                                                              10),
                                                                          bottomLeft: Radius.circular(
                                                                              10)),
                                                                      color: Colors
                                                                              .blue[
                                                                          900]),
                                                                  child: Center(
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Text(
                                                                          c["content"],
                                                                          style: GoogleFonts.poppins(
                                                                              fontWeight: FontWeight.bold,
                                                                              letterSpacing: 1,
                                                                              color: Colors.white),
                                                                        ),
                                                                        Align(
                                                                          alignment:
                                                                              Alignment.bottomRight,
                                                                          child:
                                                                              Text(
                                                                            timeago.format(DateTime.parse(c["timeago"])),
                                                                            style: GoogleFonts.poppins(
                                                                                fontWeight: FontWeight.bold,
                                                                                letterSpacing: 1,
                                                                                color: Colors.black.withOpacity(0.5),
                                                                                fontSize: 10),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              )
                                                            : Align(
                                                                alignment:
                                                                    Alignment
                                                                        .topLeft,
                                                                child:
                                                                    Container(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              8),
                                                                  width: 200,
                                                                  decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius.only(
                                                                          topLeft: Radius.circular(
                                                                            10,
                                                                          ),
                                                                          topRight: Radius.circular(10),
                                                                          bottomRight: Radius.circular(10)),
                                                                      color: Colors.blue.withOpacity(0.5)),
                                                                  child: Center(
                                                                    child:
                                                                        Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              8.0),
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          Text(
                                                                            c["content"],
                                                                            style: GoogleFonts.poppins(
                                                                                fontWeight: FontWeight.bold,
                                                                                letterSpacing: 1,
                                                                                color: Colors.white),
                                                                          ),
                                                                          Align(
                                                                            alignment:
                                                                                Alignment.bottomRight,
                                                                            child:
                                                                                Text(
                                                                              timeago.format(DateTime.parse(c["timeago"])),
                                                                              style: GoogleFonts.poppins(fontWeight: FontWeight.bold, letterSpacing: 1, color: Colors.black.withOpacity(0.5), fontSize: 10),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                      },
                                                    )
                                                  : Container();
                                            }),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )),
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                height: 80,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                    color: Colors.white),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Form(
                        key: _key,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Container(
                            width: 280,
                            child: TextFormField(
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              controller: _message,
                              validator: (val) => val.length == 0 ? "" : null,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Type your message here",
                                  hintStyle: GoogleFonts.poppins(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500)),
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
                                        "time": DateTime.now()
                                            .millisecondsSinceEpoch
                                            .toString(),
                                        "timeago": DateTime.now().toString()
                                      }).then((value) => _message.clear())
                                    : Firestore.instance
                                        .collection("Users")
                                        .document(widget.uid)
                                        .collection("following")
                                        .document(auth.currentUser.uid)
                                        .collection("chat")
                                        .add({
                                        "usertype": usertype,
                                        "content": _message.text,
                                        "time": DateTime.now()
                                            .millisecondsSinceEpoch
                                            .toString(),
                                        "timeago": DateTime.now().toString()
                                      }).then((value) => _message.clear());
                              }
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
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
