import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:SOAR/screens/feed.dart';
import 'package:SOAR/screens/profile.dart';

class UserSearch extends StatefulWidget {
  @override
  _UserSearchState createState() => _UserSearchState();
}

class _UserSearchState extends State<UserSearch> {
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
    return Scaffold(
        backgroundColor: Color(0xFFE6EDFA),
        body: Column(children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
              top: 30,
            ),
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
                    Hero(
                      tag: "mannn",
                      child: Icon(
                        Icons.search,
                        size: 30,
                        color: Color(4278228470),
                      ),
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
          SizedBox(height: 10.0),
          Expanded(
            child: StreamBuilder(
                stream: (searchString == null || searchString.trim() == "")
                    ? Firestore.instance.collection("Users").snapshots()
                    : Firestore.instance
                        .collection("Users")
                        .where("searchkey", arrayContains: searchString)
                        .snapshots(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  print(snapshot.data.documents.length);
                  return snapshot.data != null
                      ? ListView.builder(
                          itemCount: snapshot.data.documents.length,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemBuilder: (ctx, i) {
                            var document = snapshot.data.documents[i];
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: new GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                              transitionDuration:
                                                  Duration(milliseconds: 500),
                                              pageBuilder: (ctx, ani, i) =>
                                                  Profile(
                                                      uidforprofile:
                                                          document["uid"])));
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
                                                      BorderRadius.circular(15),
                                                  color: Color(4278272638),
                                                  image: document["location"] ==
                                                          null
                                                      ? DecorationImage(
                                                          image: AssetImage(
                                                              "assets/unknown.png"),
                                                          fit: BoxFit.fill)
                                                      : DecorationImage(
                                                          image: NetworkImage(
                                                              document[
                                                                  "location"]),
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
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.55,
                                              child: SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      top: 16,
                                                    ),
                                                    child: Text(
                                                        document["name"],
                                                        style:
                                                            GoogleFonts.poppins(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 23,
                                                          color: Colors.black,
                                                        ))),
                                              ),
                                            ),
                                            Text(
                                              document["tagline"],
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
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                )
                              ],
                            );
                          })
                      : Container();
                }),
          )
        ]));
  }
}
