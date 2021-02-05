import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';
import 'package:SOAR/web.dart';
import 'package:SOAR/screens/feed.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MotivationHome extends StatefulWidget {
  String text;
  String id;

  MotivationHome(this.text, this.id);
  @override
  _MotivationHomeState createState() => _MotivationHomeState();
}

class _MotivationHomeState extends State<MotivationHome> {
  @override
  void initState() {
    super.initState();
    checkifbookmarked();
    print(widget.id);
  }

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
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 35,
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.transparent,
          leading: Align(
            alignment: Alignment.topLeft,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.indigo,
                    ),
                    child: Icon(
                      Icons.arrow_back_rounded,
                      color: Colors.white,
                      size: 25,
                    )),
              ),
            ),
          ),
          title: RichText(
            text: TextSpan(
                text: widget.text,
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 23,
                    color: Colors.black)),
          ),
        ),
        backgroundColor: Color(0xFFE6EDFA),
        body: Padding(
          padding: EdgeInsets.only(top: 0),
          child: StreamBuilder(
              stream: Firestore.instance
                  .collection("all")
                  .document(widget.id)
                  .snapshots(),
              builder: (context, snapshot) {
                return ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: 1,
                  itemBuilder: (BuildContext context, int index) {
                    var success = snapshot.data;

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                  padding: const EdgeInsets.only(left: 0.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                150,
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 0, left: 5),
                                              child: Text(
                                                  success["name"] ??
                                                      "It may take some time....",
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 24,
                                                      color: Colors.indigo,
                                                      fontWeight:
                                                          FontWeight.w500))),
                                        ),
                                      ),
                                      Text(success["years"],
                                          style: GoogleFonts.poppins(
                                              fontSize: 20,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500))
                                    ],
                                  )),
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(success["lcation"]),
                                    )),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                          "document id for all": success.id,
                                          "Title": success["Title"],
                                          "handle": success["handle"],
                                          "lcation": success["lcation"],
                                          "name": success["name"],
                                          "sub": success["sub"],
                                          "type": success["type"],
                                          "years": success["years"]
                                        });
                                      },
                                      child: Icon(
                                        Icons.bookmark_border_outlined,
                                        size: 25,
                                        color: Colors.indigo,
                                      )),
                              Row(
                                children: [
                                  Icon(
                                    Icons.thumb_up_alt_outlined,
                                    size: 25,
                                    color: Colors.indigo,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Icon(
                                    Icons.share_outlined,
                                    size: 25,
                                    color: Colors.indigo,
                                  ),
                                ],
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            success["sub"],
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              fontSize: 17,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Image.asset("assets/web.png"),
                              SizedBox(
                                width: 4,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              View(success["handle"])));
                                },
                                child: Text(
                                  success["handle"],
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      color: Colors.blue[900], fontSize: 15),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  },
                );
              }),
        ));
  }
}
