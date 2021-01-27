import 'dart:ui';

import 'package:SOAR/auth/login.dart';
import 'package:SOAR/screens/chat/text_screen.dart';
import 'package:SOAR/services/search_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'feed.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  var queryResultSet = [];
  var tempSearchStore = [];

  initiateSearch(value) {
    if (value.length == 0) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
    }

    var capitalizedValue =
        value.substring(0, 1).toUpperCase() + value.substring(1);

    if (queryResultSet.length == 0 && value.length == 1) {
      SearchIndex().serachByName(value).then((QuerySnapshot docs) {
        for (int i = 0; i < docs.documents.length; ++i) {
          queryResultSet.add(docs.documents[i].data);
        }
      });
    } else {
      tempSearchStore = [];
      queryResultSet.forEach((element) {
        if (element['name'].startsWith(capitalizedValue)) {
          setState(() {
            tempSearchStore.add(element);
          });
        }
      });
    }
  }

  String searchString;
  TextEditingController _searchController;

  Future<void> _fetchUserinfoForSettingsPage() async {
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

  String usertype;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchUserinfoForSettingsPage();
    _searchController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);

    return new Scaffold(
        backgroundColor: Color(0xFFE6EDFA),
        body: Column(children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
              top: 30,
            ),
            child: Hero(
              tag: "key",
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Color(0xFF5894FA)),
                    color: Color(0xFF5894FA).withOpacity(0.4)),
                height: 60,
                width: MediaQuery.of(context).size.width * 0.9,
                child: Align(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search,
                        size: 30,
                        color: Color(4278228470),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: Material(
                          color: Colors.transparent,
                          child: TextField(
                              autofocus: true,
                              style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  color: Color(
                                    4278228470,
                                  ),
                                  fontWeight: FontWeight.w500),
                              controller: _searchController,
                              onChanged: (val) {
                                setState(() {
                                  searchString = val.toLowerCase();
                                });
                              },
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Search',
                                  hintStyle: GoogleFonts.poppins(
                                      fontSize: 20,
                                      color: Color(
                                        4278228470,
                                      ),
                                      fontWeight: FontWeight.w500),
                                  contentPadding: EdgeInsets.only(top: 13))),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 10.0),
          usertype == "investor"
              ? Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                      stream: (searchString == null ||
                              searchString.trim() == "")
                          ? Firestore.instance
                              .collection("Users")
                              .document(auth.currentUser.uid)
                              .collection("following")
                              .snapshots()
                          : Firestore.instance
                              .collection("Users")
                              .document(auth.currentUser.uid)
                              .collection("following")
                              .where("searchkey", arrayContains: searchString)
                              .snapshots(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        return snapshot.data != null
                            ? ListView(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                children: snapshot.data.documents
                                    .map<Widget>((DocumentSnapshot document) {
                                  return Column(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 10.0),
                                        child: new GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                PageRouteBuilder(
                                                    transitionDuration:
                                                        Duration(
                                                            milliseconds: 500),
                                                    pageBuilder: (ctx, ani,
                                                            i) =>
                                                        TextScreen(
                                                          id: document[
                                                              "uid_entrepreneur"],
                                                          dpurl: document[
                                                              "location"],
                                                          uid: document["uid"],
                                                          name:
                                                              document["name"],
                                                        )));
                                          },
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: 30,
                                              ),
                                              Material(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  elevation: 20,
                                                  child: Container(
                                                    height: 70,
                                                    width: 70,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                        color:
                                                            Color(4278272638),
                                                        image: document[
                                                                    "location"] ==
                                                                null
                                                            ? DecorationImage(
                                                                image: AssetImage(
                                                                    "assets/unknown.png"),
                                                                fit:
                                                                    BoxFit.fill)
                                                            : DecorationImage(
                                                                image: NetworkImage(
                                                                    document[
                                                                        "location"]),
                                                                fit: BoxFit
                                                                    .fill)),
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
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.55,
                                                    child:
                                                        SingleChildScrollView(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                            top: 16,
                                                          ),
                                                          child: Text(
                                                              document["name"],
                                                              style: GoogleFonts
                                                                  .poppins(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 23,
                                                                color: Colors
                                                                    .black,
                                                              ))),
                                                    ),
                                                  ),
                                                  Text(
                                                    document["tagline"],
                                                    style: GoogleFonts.poppins(
                                                      fontWeight:
                                                          FontWeight.w400,
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
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      )
                                    ],
                                  );
                                }).toList())
                            : Container();
                      }),
                )
              : Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                      stream: (searchString == null ||
                              searchString.trim() == "")
                          ? Firestore.instance
                              .collection("Users")
                              .document(auth.currentUser.uid)
                              .collection("followers")
                              .snapshots()
                          : Firestore.instance
                              .collection("Users")
                              .document(auth.currentUser.uid)
                              .collection("followers")
                              .where("searchkey", arrayContains: searchString)
                              .snapshots(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        return snapshot.data != null
                            ? Padding(
                                padding: const EdgeInsets.only(bottom: 20.0),
                                child: Column(
                                  children: [
                                    ListView(
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        children: snapshot.data.documents
                                            .map<Widget>(
                                                (DocumentSnapshot document) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                top: 20.0),
                                            child: new GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    PageRouteBuilder(
                                                        transitionDuration:
                                                            Duration(
                                                                milliseconds:
                                                                    500),
                                                        pageBuilder:
                                                            (ctx, ani, i) =>
                                                                TextScreen(
                                                                  id: document[
                                                                      "uid"],
                                                                  dpurl: document[
                                                                      "location"],
                                                                  uid: document[
                                                                      "investor_uid"],
                                                                  name: document[
                                                                      "name"],
                                                                )));
                                              },
                                              child: Row(
                                                children: [
                                                  SizedBox(
                                                    width: 30,
                                                  ),
                                                  Material(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      elevation: 20,
                                                      child: Container(
                                                        height: 70,
                                                        width: 70,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15),
                                                            color: Color(
                                                                4278272638),
                                                            image: document[
                                                                        "location"] ==
                                                                    null
                                                                ? DecorationImage(
                                                                    image: AssetImage(
                                                                        "assets/unknown.png"),
                                                                    fit: BoxFit
                                                                        .fill)
                                                                : DecorationImage(
                                                                    image: NetworkImage(
                                                                        document[
                                                                            "location"]),
                                                                    fit: BoxFit
                                                                        .fill)),
                                                      )),
                                                  SizedBox(
                                                    width: 15,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                        height: 50,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.55,
                                                        child:
                                                            SingleChildScrollView(
                                                          scrollDirection:
                                                              Axis.horizontal,
                                                          child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                top: 16,
                                                              ),
                                                              child: Text(
                                                                  document[
                                                                      "name"],
                                                                  style: GoogleFonts
                                                                      .poppins(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        23,
                                                                    color: Colors
                                                                        .black,
                                                                  ))),
                                                        ),
                                                      ),
                                                      Text(
                                                        document["tagline"],
                                                        style:
                                                            GoogleFonts.poppins(
                                                          fontWeight:
                                                              FontWeight.w400,
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
                                            ),
                                          );
                                        }).toList()),
                                    SizedBox(
                                      height: 30,
                                    )
                                  ],
                                ),
                              )
                            : Container();
                      }),
                )
        ]));
  }
}

Widget buildResultCard(data) {
  return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 2.0,
      child: Container(
          child: Center(
              child: Text(
        data['name'],
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.black,
          fontSize: 20.0,
        ),
      ))));
}
