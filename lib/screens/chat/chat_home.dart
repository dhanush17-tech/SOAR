import 'package:SOAR/screens/profile.dart';
import 'package:SOAR/screens/search_screen.dart';
import 'package:SOAR/services/search_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:SOAR/screens/feed.dart';
import 'text_screen.dart';

void main() => runApp(ChatScreen());

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
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

  String dpurl;

  fetchcurrentuserdetails() {
    Firestore.instance
        .collection("Users")
        .document(auth.currentUser.uid)
        .get()
        .then((value) {
      setState(() {
        dpurl = value.data()["location"];
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _usertype();
    fetchcurrentuserdetails();
    print(usertype);
  }

  var queryResult = [];
  var tempResult = [];

  initateSearch(value) {
    if (value.length == 0) {
      setState(() {
        queryResult = [];
        tempResult = [];
      });
    }
    var capitalizedLetter =
        value.substring(0, 1).toUpperCase() + value.substring(1);

    if (queryResult.length == 0 && value.length == 1) {
      SearchIndex().serachByName(value).then((QuerySnapshot docs) {
        for (int i = 0; i < docs.documents.length; i++) {
          queryResult.add(docs.documents[i].data);
        }
      });
    } else
      (tempResult = []);
    queryResult.forEach((element) {
      if (element["name"].startsWith(capitalizedLetter)) {
        setState(() {
          tempResult.add(element);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(4278190106),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30, left: 15, right: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Hero(
                      tag: "arrow",
                      child: FittedBox(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(4278228470),
                            ),
                            child: Icon(
                              Icons.arrow_back,
                              color: Color(4278190106),
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                      child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              PageRouteBuilder(
                                  transitionDuration:
                                      Duration(milliseconds: 500),
                                  pageBuilder: (ctx, ani, i) => Profile(
                                        uidforprofile: auth.currentUser.uid,
                                      )));
                        },
                        child: Hero(
                          tag: "good",
                          child: CircleAvatar(
                            backgroundImage: AssetImage("assets/cool.png"),
                            backgroundColor: Colors.tealAccent,
                            radius: 20,
                          ),
                        ),
                      ),
                    ],
                  ))
                ],
              ),
            ),
            SizedBox(
              height: 60,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Talk to \nyour investor',
                  style: GoogleFonts.poppins(
                      color: Colors.white,
                      height: 1.2,
                      fontSize: 42,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
            Hero(
              tag: "key",
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => Search()));
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 60),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color(4280099132)),
                    width: 350,
                    height: 60,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.search,
                            size: 30,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Search',
                            style: GoogleFonts.poppins(
                                fontSize: 20,
                                color: Color(
                                  4278228470,
                                ),
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            usertype == "investor"
                ? StreamBuilder(
                    stream: Firestore.instance
                        .collection("Users")
                        .document(auth.currentUser.uid)
                        .collection("following")
                        .snapshots(),
                    builder: (ctx, snapshot) {
                      return snapshot.data!=null? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.separated(
                          itemCount: snapshot.data.documents.length,
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (ctx, i) {
                            DocumentSnapshot course =
                                snapshot.data.documents[i];

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                        transitionDuration:
                                            Duration(milliseconds: 500),
                                        pageBuilder: (ctx, ani, i) =>
                                            TextScreen(
                                              id: course["uid_entrepreneur"],
                                              dpurl: course["dpurl"],
                                              uid: course["uid"],
                                              name: course["name"],
                                            )));
                              },
                              child: Row(
                                children: [
                                  Material(
                                      borderRadius: BorderRadius.circular(15),
                                      elevation: 20,
                                      child: Container(
                                        height: 80,
                                        width: 80,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            color: Color(4278272638),
                                            image: course["dpurl"] == null
                                                ? DecorationImage(
                                                    image: AssetImage(
                                                        "assets/unknown.png"),
                                                    fit: BoxFit.fill)
                                                : DecorationImage(
                                                    image: NetworkImage(
                                                        course["dpurl"]),
                                                    fit: BoxFit.fill)),
                                      )),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 50,
                                        width: 200,
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Padding(
                                              padding: const EdgeInsets.only(
                                                top: 16,
                                              ),
                                              child: Text(course["name"],
                                                  style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 25,
                                                    color: Colors.white,
                                                  ))),
                                        ),
                                      ),
                                      Text(
                                        course["tagline"],
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 15,
                                          color: Color(
                                            4278228470,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (context, i) {
                            return SizedBox(
                              height: 20,
                            );
                          },
                        ),
                      ):Container();
                    })
                : StreamBuilder(
                    stream: Firestore.instance
                        .collection("Users")
                        .document(auth.currentUser.uid)
                        .collection("followers")
                        .snapshots(),
                    builder: (ctx, snapshot) {
                      return snapshot.data!=null? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.separated(
                          itemCount: snapshot.data.documents.length,
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (ctx, i) {
                            DocumentSnapshot course =
                                snapshot.data.documents[i];

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                        transitionDuration:
                                            Duration(milliseconds: 500),
                                        pageBuilder: (ctx, ani, i) =>
                                            TextScreen(
                                              id: auth.currentUser.uid,
                                              uid: course["investor_uid"],
                                              name: course["name"],
                                              dpurl: course["dpurl"],
                                            )));
                              },
                              child: Row(
                                children: [
                                  Material(
                                      borderRadius: BorderRadius.circular(15),
                                      elevation: 20,
                                      child: Container(
                                        height: 80,
                                        width: 80,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            color: Color(4278272638),
                                            image: course["dpurl"] == null
                                                ? DecorationImage(
                                                    image: AssetImage(
                                                        "assets/unknown.png"),
                                                    fit: BoxFit.contain)
                                                : DecorationImage(
                                                    image: NetworkImage(
                                                        course["dpurl"]),
                                                    fit: BoxFit.contain)),
                                      )),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 50,
                                        width: 200,
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Padding(
                                              padding: const EdgeInsets.only(
                                                top: 16,
                                              ),
                                              child: Text(course["name"],
                                                  style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 25,
                                                    color: Colors.white,
                                                  ))),
                                        ),
                                      ),
                                      Text(
                                        course["tagline"],
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 15,
                                          color: Color(
                                            4278228470,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (context, i) {
                            return SizedBox(
                              height: 20,
                            );
                          },
                        ),
                      ):Container();
                    })
          ],
        ),
      ),
    );
  }
}

String connectionlenght;
