import 'package:SOAR/screens/feed_details.dart';
import 'dart:ui';
import 'package:SOAR/widgets/cards.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:SOAR/screens/feed.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'chat/chat_home.dart';
import 'for_users_feed_details.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:easy_gradient_text/easy_gradient_text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:SOAR/main_constraints.dart';
import 'package:sticky_headers/sticky_headers.dart';

class Profile extends StatefulWidget {
  String uidforprofile;
  String name;
  Profile({this.uidforprofile, this.name});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  Future<void> _fetchUserinfoForSettingsPage() async {
    try {
      await Firestore.instance
          .collection("Users")
          .document(widget.uidforprofile)
          .get()
          .then((value) {
        if (value.exists) {
          setState(() {
            dpurl = value.data()["location"];
            name = value.data()["name"];
            tagline = value.data()["tagline"];
            usertype = value.data()["usertype"];
            websiteurl = value.data()["websiteurl"];
            uid = value.data()["uid"];
          });
          print(uid);
        }
      });
    } catch (e) {}
  }

  Future checkfor_rentrepreneur() async {
    final QuerySnapshot qSnap = await Firestore.instance
        .collection("Users")
        .document(widget.uidforprofile)
        .collection("followers")
        .getDocuments();
    connectionlenght = qSnap.documents.length.toString();
    print(connectionlenght);
    if (connectionlenght == "0") {
      final QuerySnapshot snap = await Firestore.instance
          .collection("Users")
          .document(widget.uidforprofile)
          .collection("following")
          .getDocuments();
      setState(() {
        connectionlenght = snap.documents.length.toString();
        print(connectionlenght);
      });
    }
  }

  _nowuserdetails() async {
    try {
      var man =
          Firestore.instance.collection("Users").document(auth.currentUser.uid);
      await Firestore.instance
          .collection("Users")
          .document(auth.currentUser.uid)
          .get()
          .then((value) {
        if (value.exists) {
          setState(() {
            nowuser_dpurl = value.data()["location"];
            nowuser_dpurl = value.data()["location"];
            nowuser_name = value.data()["name"];
            nowuser_tagline = value.data()["tagline"];
            nowuser_usertype = value.data()["usertype"];
            nowuser_websiteurl = value.data()["websiteurl"];
            nowuser_uid = value.data()["uid"];
          });
        }
      });
    } catch (e) {}
  }

  bro() {
    Firestore.instance
        .collection("Users")
        .document(auth.currentUser.uid)
        .get()
        .then((value) {
      setState(() {
        currentusertype = value["usertype"];
      });
    });
  }

  String isfollower;
  checkfollowerexists() async {
    QuerySnapshot _query = await Firestore.instance
        .collection("Users")
        .document(auth.currentUser.uid)
        .collection("following")
        .where('uid_entrepreneur', isEqualTo: widget.uidforprofile)
        .getDocuments();

    if (_query.documents.length > 0) {
      setState(() {
        isfollower = "exists";
      });
    } else {
      setState(() {
        isfollower = "no";
      });
      print("${isfollower}man");
    }
  }

  String currentusertype;

  TextEditingController nameChange = TextEditingController();
  TextEditingController websiteUrlChnage = TextEditingController();

  @override
  void dispose() {
    taglineChange.dispose();
    websiteUrlChnage.dispose();
    nameChange.dispose();
    super.dispose();
  }

  TextEditingController taglineChange = TextEditingController();

  Future<void> _edit() async {
    try {
      await Firestore.instance
          .collection("Users")
          .document(widget.uidforprofile)
          .get()
          .then((value) {
        setState(() {
          nameChange.text = value.data()["name"];
          websiteUrlChnage.text = value.data()["websiteurl"];
          taglineChange.text = value.data()["tagline"];
          usertype = value.data()["usertype"];
          location = value.data()["location"];
        });
      });
    } catch (e) {}
  }

  String location;

  Future uploadProfilePicture() async {
    DateTime _time = DateTime.now();
    var postImage = await ImagePicker.pickImage(source: ImageSource.gallery);

    final Reference storageRef = FirebaseStorage.instance.ref();

    UploadTask uploadTask = await storageRef
        .child("post_${auth.currentUser.uid + _time.toString()}.jpg")
        .putFile(postImage)
        .then((val) {
      val.ref.getDownloadURL().then((val) async {
        setState(() {
          location = val;
        });
        await Firestore.instance
            .collection("Users")
            .document(auth.currentUser.uid)
            .set({"location": location}, SetOptions(merge: true));
        await _fetchUserinfoForSettingsPage();

        print(location);
      });
    });
  }

  noofposts() {
    Firestore.instance
        .collection("Users")
        .document(widget.uidforprofile)
        .collection("posts")
        .get()
        .then((value) {
      setState(() {
        no_ofposts = value.documents.length;
      });
    });
  }

  @override
  void initState() {
    checkfollowerexists();
    checkfor_rentrepreneur();
    // TODO: implement initState
    super.initState();
    _fetchUserinfoForSettingsPage();
    _nowuserdetails();
    checkfor_rentrepreneur();
    print(widget.name);
    _edit();
    print(widget.uidforprofile);
    noofposts();
    getman();
    bro();
  }

  int no_ofposts;

  String dpurl;
  String name;
  String tagline;
  String usertype;
  String websiteurl;
  String uid;

  String nowuser_dpurl;
  String nowuser_name;
  String nowuser_tagline;
  String nowuser_usertype;
  String nowuser_websiteurl;
  String nowuser_uid;

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

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: man == false ? light_background : dark_background,
        body: Container(
          decoration: BoxDecoration(
            color: man == false ? light_background : dark_background,
          ),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Stack(
              children: [
                Column(children: [
                  Padding(
                    padding: EdgeInsets.only(top: 25, left: 10),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.person,
                                      size: 40, color: Colors.indigo),
                                  SizedBox(width: 10),
                                  GradientText(
                                    text: "Profile",
                                      colors: [Colors.blue, Colors.blueAccent],
                                    style: GoogleFonts.poppins(
                                      fontSize: 35,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ])),
                  ),
                  SizedBox(height: 20),
                  location == null
                      ? GestureDetector(
                          onTap: widget.uidforprofile == auth.currentUser.uid
                              ? () async {
                                  await uploadProfilePicture();
                                }
                              : null,
                          child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 20.0),
                                  child: Hero(
                                    tag: "man +iii",
                                    child: Container(
                                      width: 150,
                                      height: 150,
                                      decoration: BoxDecoration(
                                          color: Color(4278272638),
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  "assets/unknown.png"),
                                              fit: BoxFit.cover),
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                    ),
                                  ),
                                ),
                                widget.uidforprofile == auth.currentUser.uid
                                    ? Padding(
                                        padding: EdgeInsets.only(),
                                        child: Container(
                                          width: 75,
                                          height: 45,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors.indigo,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.5),
                                                spreadRadius: 10,
                                                blurRadius: 20,
                                                offset: Offset(0,
                                                    3), // changes position of shadow
                                              ),
                                            ],
                                          ),
                                          child: Icon(
                                            Icons.edit,
                                            color: Colors.white,
                                            size: 30,
                                          ),
                                        ),
                                      )
                                    : Container()
                              ]))
                      : GestureDetector(
                          onTap: widget.uidforprofile == auth.currentUser.uid
                              ? () async {
                                  await uploadProfilePicture();
                                }
                              : null,
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 20.0),
                                child: Hero(
                                  tag: "man +iii",
                                  child: FutureBuilder(
                                      future: _edit(),
                                      builder: (context, snapshot) {
                                        return snapshot.connectionState !=
                                                ConnectionState.done
                                            ? Container(
                                                width: 150,
                                                height: 150,
                                                decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        image: NetworkImage(
                                                            location),
                                                        fit: BoxFit.cover),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15)),
                                              )
                                            : Shimmer(
                                                duration: Duration(
                                                    milliseconds:
                                                        1500), //Default value
                                                interval: Duration(
                                                    milliseconds:
                                                        100), //Default value: Duration(seconds: 0)
                                                color:
                                                    Colors.blue, //Default value
                                                enabled: true, //Default value
                                                direction: ShimmerDirection
                                                    .fromLTRB(), //D
                                                child: Container(
                                                  width: 150,
                                                  height: 150,
                                                  decoration: BoxDecoration(
                                                      color: Colors.blue
                                                          .withOpacity(0.25),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15)),
                                                ),
                                              );
                                        ;
                                      }),
                                ),
                              ),
                              widget.uidforprofile == auth.currentUser.uid
                                  ? Padding(
                                      padding: EdgeInsets.only(),
                                      child: Container(
                                        width: 75,
                                        height: 45,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.indigo,
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                              spreadRadius: 10,
                                              blurRadius: 20,
                                              offset: Offset(0,
                                                  3), // changes position of shadow
                                            ),
                                          ],
                                        ),
                                        child: Icon(
                                          Icons.edit,
                                          color: Colors.white,
                                          size: 30,
                                        ),
                                      ),
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                ]),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 260,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 90,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 0, right: 0),
                                        child: auth.currentUser.uid !=
                                                widget.uidforprofile
                                            ? StreamBuilder(
                                                stream: Firestore.instance
                                                    .collection('Users')
                                                    .document(
                                                        "${widget.uidforprofile}")
                                                    .snapshots(),
                                                builder: (context, snapshot) {
                                                  var userDocument =
                                                      snapshot.data;
                                                  return snapshot.data != null
                                                      ? Text(
                                                          userDocument[
                                                                  "name"] ??
                                                              "It may take some time....",
                                                          style: TextStyle(
                                                              color: man ==
                                                                      false
                                                                  ? sub_heading_light
                                                                  : sub_heading_dark,
                                                              fontSize: 55,
                                                              fontFamily:
                                                                  "good"),
                                                        )
                                                      : Container();
                                                })
                                            : Align(
                                                alignment: Alignment.center,
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  child: TextFormField(
                                                    textAlign: TextAlign.center,
                                                    controller: nameChange,
                                                    decoration: InputDecoration(
                                                        border:
                                                            InputBorder.none),
                                                    onChanged: (val) async {
                                                      print(
                                                          auth.currentUser.uid);
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection('Users')
                                                          .document(auth
                                                              .currentUser.uid)
                                                          .setData({
                                                        "name": nameChange.text,
                                                        "tagline":
                                                            taglineChange.text,
                                                        "websiteurl":
                                                            websiteUrlChnage
                                                                .text,
                                                        "uid": auth
                                                            .currentUser.uid,
                                                        "location": location,
                                                        "usertype": usertype
                                                      }).then((value) =>
                                                              print("done"));
                                                      if (usertype ==
                                                          "investor") {
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'Investor')
                                                            .document(auth
                                                                .currentUser
                                                                .uid)
                                                            .setData({
                                                          "name":
                                                              nameChange.text,
                                                          "tagline":
                                                              taglineChange
                                                                  .text,
                                                          "websiteurl":
                                                              websiteUrlChnage
                                                                  .text,
                                                          "uid": auth
                                                              .currentUser.uid,
                                                          "location": location,
                                                          "usertype": usertype
                                                        });
                                                      }
                                                      if (usertype ==
                                                          "entrepreneur") {
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'Entrepreneur')
                                                            .document(auth
                                                                .currentUser
                                                                .uid)
                                                            .setData({
                                                          "name":
                                                              nameChange.text,
                                                          "tagline":
                                                              taglineChange
                                                                  .text,
                                                          "websiteurl":
                                                              websiteUrlChnage
                                                                  .text,
                                                          "uid": auth
                                                              .currentUser.uid,
                                                          "location": location,
                                                          "usertype": usertype
                                                        });
                                                      }
                                                    },
                                                    style: TextStyle(
                                                        color: man == false
                                                            ? sub_heading_light
                                                            : sub_heading_dark,
                                                        fontSize: 55,
                                                        fontFamily: "good"),
                                                  ),
                                                ),
                                              ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  if (currentusertype != "entrepreneur")
                                    (widget.uidforprofile !=
                                            auth.currentUser.uid
                                        ? isfollower == "no"
                                            ? Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 35, right: 10),
                                                child: Align(
                                                  alignment: Alignment.topRight,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      List<String> spiltList =
                                                          name.split(" ");
                                                      List<String> indexList =
                                                          [];
                                                      for (int i = 0;
                                                          i < spiltList.length;
                                                          i++) {
                                                        for (int j = 0;
                                                            j <
                                                                spiltList[i]
                                                                        .length +
                                                                    i;
                                                            j++) {
                                                          indexList.add(
                                                              spiltList[i]
                                                                  .substring(
                                                                      0, j)
                                                                  .toLowerCase());
                                                        }
                                                      }
                                                      Firestore.instance
                                                          .collection("Users")
                                                          .document(auth
                                                              .currentUser.uid)
                                                          .collection(
                                                              "following")
                                                          .document(widget
                                                              .uidforprofile)
                                                          .setData({
                                                        "location": location,
                                                        "name": name,
                                                        "tagline": tagline,
                                                        "usertype": usertype,
                                                        "websiteurl":
                                                            websiteurl,
                                                        "uid": auth
                                                            .currentUser.uid,
                                                        "uid_entrepreneur":
                                                            widget
                                                                .uidforprofile,
                                                        "searchkey": indexList
                                                      }).then((value) {
                                                        print("done");
                                                        setState(() {
                                                          _nowuserdetails();
                                                          _fetchUserinfoForSettingsPage();
                                                          checkfollowerexists();
                                                          checkfor_rentrepreneur();
                                                        });
                                                      });

                                                      List<String> otherList =
                                                          nowuser_name
                                                              .split(" ");
                                                      List<String> ndexList =
                                                          [];
                                                      for (int m = 0;
                                                          m < otherList.length;
                                                          m++) {
                                                        for (int f = 0;
                                                            f <
                                                                otherList[m]
                                                                        .length +
                                                                    m;
                                                            f++) {
                                                          ndexList.add(otherList[
                                                                  m]
                                                              .substring(0, f)
                                                              .toLowerCase());
                                                        }
                                                      }
                                                      Firestore.instance
                                                          .collection("Users")
                                                          .document(widget
                                                              .uidforprofile)
                                                          .collection(
                                                              "followers")
                                                          .add({
                                                        "location":
                                                            nowuser_dpurl,
                                                        "name": nowuser_name,
                                                        "tagline":
                                                            nowuser_tagline,
                                                        "usertype":
                                                            nowuser_usertype,
                                                        "websiteurl":
                                                            nowuser_websiteurl,
                                                        "uid": widget
                                                            .uidforprofile,
                                                        "investor_uid":
                                                            nowuser_uid,
                                                        "searchkey": ndexList
                                                      }).then((value) {
                                                        print("done");
                                                        setState(() {
                                                          _nowuserdetails();
                                                          _fetchUserinfoForSettingsPage();
                                                          checkfollowerexists();
                                                          checkfor_rentrepreneur();
                                                        });
                                                      });
                                                    },
                                                    child: Container(
                                                      width: 120,
                                                      height: 30,
                                                      decoration: BoxDecoration(
                                                          gradient: LinearGradient(
                                                              colors: [
                                                                Colors
                                                                    .blue[400],
                                                                Colors.blueAccent[
                                                                    700]
                                                              ],
                                                              begin: Alignment
                                                                  .centerLeft,
                                                              end: Alignment
                                                                  .centerRight),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10)),
                                                      child: Align(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                          "Follow",
                                                          style: GoogleFonts
                                                              .poppins(
                                                                  fontSize: 20,
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 35, right: 13),
                                                child: Align(
                                                  alignment: Alignment.topRight,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      print("jj");
                                                      Firestore.instance
                                                          .collection("Users")
                                                          .document(auth
                                                              .currentUser.uid)
                                                          .collection(
                                                              "following")
                                                          .where(
                                                              'uid_entrepreneur',
                                                              isEqualTo: widget
                                                                  .uidforprofile)
                                                          .get()
                                                          .then((value) {
                                                        value.docs
                                                            .forEach((element) {
                                                          Firestore.instance
                                                              .collection(
                                                                  "Users")
                                                              .document(auth
                                                                  .currentUser
                                                                  .uid)
                                                              .collection(
                                                                  "following")
                                                              .doc(element.id)
                                                              .delete()
                                                              .then((value) =>
                                                                  print(
                                                                      "complete"));
                                                        });
                                                      }).then((value) {
                                                        setState(() {
                                                          _nowuserdetails();
                                                          _fetchUserinfoForSettingsPage();
                                                          checkfollowerexists();
                                                          checkfor_rentrepreneur();
                                                        });
                                                      });

                                                      Firestore.instance
                                                          .collection("Users")
                                                          .document(widget
                                                              .uidforprofile)
                                                          .collection(
                                                              "followers")
                                                          .where('investor_uid',
                                                              isEqualTo: auth
                                                                  .currentUser
                                                                  .uid)
                                                          .get()
                                                          .then((value) {
                                                        value.docs
                                                            .forEach((element) {
                                                          Firestore.instance
                                                              .collection(
                                                                  "Users")
                                                              .document(widget
                                                                  .uidforprofile)
                                                              .collection(
                                                                  "followers")
                                                              .doc(element.id)
                                                              .delete()
                                                              .then((value) =>
                                                                  print(
                                                                      "complete"));
                                                        });
                                                      }).then((value) {
                                                        setState(() {
                                                          _nowuserdetails();
                                                          _fetchUserinfoForSettingsPage();
                                                          checkfollowerexists();
                                                          checkfor_rentrepreneur();
                                                        });
                                                      });
                                                    },
                                                    child: Container(
                                                      width: 120,
                                                      height: 30,
                                                      decoration: BoxDecoration(
                                                          gradient: LinearGradient(
                                                              colors: [
                                                                Colors
                                                                    .blue[400],
                                                                Colors.blueAccent[
                                                                    700]
                                                              ],
                                                              begin: Alignment
                                                                  .centerLeft,
                                                              end: Alignment
                                                                  .centerRight),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10)),
                                                      child: Align(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                          "Unfollow",
                                                          style: GoogleFonts
                                                              .poppins(
                                                                  fontSize: 20,
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                        : Container())
                                  else
                                    Container()
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                top: 59,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 0, top: 0),
                                child: auth.currentUser.uid !=
                                        widget.uidforprofile
                                    ? StreamBuilder(
                                        stream: Firestore.instance
                                            .collection('Users')
                                            .document("${widget.uidforprofile}")
                                            .snapshots(),
                                        builder: (context, snapshot) {
                                          var userDocument = snapshot.data;
                                          return snapshot.data == null
                                              ? CircularProgressIndicator()
                                              : Align(
                                                  alignment: Alignment.topLeft,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 11.0, top: 8),
                                                    child: Text(
                                                      userDocument["tagline"] ??
                                                          "It may take some time....",
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                        color: man == false
                                                            ? sub_heading_light
                                                            : sub_heading_dark,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 17,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                        })
                                    : Align(
                                        alignment: Alignment.center,
                                        child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: TextFormField(
                                            textAlign: TextAlign.center,
                                            controller: taglineChange,
                                            style: TextStyle(
                                              color: man == false
                                                  ? sub_heading_light
                                                  : sub_heading_dark,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 15,
                                            ),
                                            onChanged: (val) async {
                                              print(auth.currentUser.uid);
                                              await FirebaseFirestore.instance
                                                  .collection('Users')
                                                  .document(
                                                      auth.currentUser.uid)
                                                  .setData({
                                                "name": nameChange.text,
                                                "tagline": taglineChange.text,
                                                "websiteurl":
                                                    websiteUrlChnage.text,
                                                "location": location,
                                                "usertype": usertype,
                                                "uid": auth.currentUser.uid
                                              }).then((value) => print("done"));
                                              if (usertype == "investor") {
                                                FirebaseFirestore.instance
                                                    .collection('Investor')
                                                    .document(
                                                        auth.currentUser.uid)
                                                    .setData({
                                                  "name": nameChange.text,
                                                  "tagline": taglineChange.text,
                                                  "websiteurl":
                                                      websiteUrlChnage.text,
                                                  "usertype": usertype,
                                                  "location": location,
                                                  "uid": auth.currentUser.uid
                                                });
                                              }
                                              if (usertype == "entrepreneur") {
                                                FirebaseFirestore.instance
                                                    .collection('Entrepreneur')
                                                    .document(
                                                        auth.currentUser.uid)
                                                    .setData({
                                                  "name": nameChange.text,
                                                  "tagline": taglineChange.text,
                                                  "websiteurl":
                                                      websiteUrlChnage.text,
                                                  "location": location,
                                                  "uid": auth.currentUser.uid,
                                                  "usertype": usertype
                                                });
                                              }
                                            },
                                            decoration: InputDecoration(
                                                border: InputBorder.none),
                                          ),
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: auth.currentUser.uid == widget.uidforprofile
                              ? 0
                              : 0,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0, left: 0),
                          child: Row(
                            children: [
                              SizedBox(
                                width:
                                    auth.currentUser.uid == widget.uidforprofile
                                        ? 0
                                        : 10,
                              ),
                              auth.currentUser.uid != widget.uidforprofile
                                  ? Image.asset("assets/web.png")
                                  : Container(
                                      width: 0,
                                      height: 0,
                                    ),
                              auth.currentUser.uid != widget.uidforprofile
                                  ? Padding(
                                      padding:
                                          const EdgeInsets.only(left: 15.0),
                                      child: StreamBuilder(
                                          stream: Firestore.instance
                                              .collection('Users')
                                              .document(
                                                  "${widget.uidforprofile}")
                                              .snapshots(),
                                          builder: (context, snapshot) {
                                            var userDocument = snapshot.data;
                                            return snapshot.data == null
                                                ? CircularProgressIndicator()
                                                : Text(
                                                    userDocument["websiteurl"],
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: man == false
                                                          ? sub_heading_light
                                                          : sub_heading_dark,
                                                      fontSize: 15,
                                                    ),
                                                  );
                                          }),
                                    )
                                  : Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: TextFormField(
                                        textAlign: TextAlign.center,
                                        controller: websiteUrlChnage,
                                        style: TextStyle(
                                          color: man == false
                                              ? sub_heading_light
                                              : sub_heading_dark,
                                          fontSize: 15,
                                        ),
                                        onChanged: (val) async {
                                          print(auth.currentUser.uid);
                                          await FirebaseFirestore.instance
                                              .collection('Users')
                                              .document(auth.currentUser.uid)
                                              .setData({
                                            "name": nameChange.text,
                                            "tagline": taglineChange.text,
                                            "websiteurl": websiteUrlChnage.text,
                                            "location": location,
                                            "uid": auth.currentUser.uid,
                                            "usertype": usertype
                                          }).then((value) => print("done"));
                                          if (usertype == "investor") {
                                            FirebaseFirestore.instance
                                                .collection('Investor')
                                                .document(auth.currentUser.uid)
                                                .setData({
                                              "name": nameChange.text,
                                              "tagline": taglineChange.text,
                                              "websiteurl":
                                                  websiteUrlChnage.text,
                                              "location": location,
                                              "uid": auth.currentUser.uid,
                                              "usertype": usertype
                                            });
                                          }
                                          if (usertype == "entrepreneur") {
                                            FirebaseFirestore.instance
                                                .collection('Entrepreneur')
                                                .document(auth.currentUser.uid)
                                                .setData({
                                              "name": nameChange.text,
                                              "tagline": taglineChange.text,
                                              "websiteurl":
                                                  websiteUrlChnage.text,
                                              "location": location,
                                              "uid": auth.currentUser.uid,
                                              "usertype": usertype
                                            });
                                          }
                                        },
                                        decoration: InputDecoration(
                                            border: InputBorder.none),
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  connectionlenght ?? "0",
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 32,
                                      fontWeight: FontWeight.w500),
                                ),
                                Opacity(
                                    opacity: 0.9,
                                    child: Text(
                                      "Connections",
                                      style: GoogleFonts.poppins(
                                        letterSpacing: .6,
                                        fontWeight: FontWeight.w500,
                                        color: man == false
                                            ? feed_details_title_light
                                            : feed_details_title_dark,
                                      ),
                                    )),
                              ],
                            ),
                            Container(
                                width: 2,
                                height: 40,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.grey)),
                            Column(
                              children: [
                                no_ofposts == null
                                    ? Text(
                                        "0",
                                        style: TextStyle(
                                            color: Colors.blue,
                                            fontSize: 32,
                                            fontWeight: FontWeight.w500),
                                      )
                                    : Text(
                                        "$no_ofposts",
                                        style: TextStyle(
                                            color: Colors.blue,
                                            fontSize: 32,
                                            fontWeight: FontWeight.w500),
                                      ),
                                Opacity(
                                    opacity: 0.9,
                                    child: Text(
                                      "Pitches",
                                      textAlign: TextAlign.left,
                                      style: GoogleFonts.poppins(
                                        letterSpacing: .6,
                                        fontWeight: FontWeight.w500,
                                        color: man == false
                                            ? feed_details_title_light
                                            : feed_details_title_dark,
                                      ),
                                    )),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      usertype == "entrepreneur"
                          ? StickyHeader(
                              header: Align(
                                alignment: Alignment.bottomLeft,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 5, bottom: 0),
                                  child: Container(
                                    height: 50,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: man == false
                                          ? light_background
                                          : dark_background,
                                    ),
                                    child: GradientText(
                                      text: " Pitches",
                                                                        colors: [Colors.blue, Colors.blueAccent],

                                      style: TextStyle(
                                          fontSize: 55,
                                          fontFamily: "good",
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                              content: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: StreamBuilder(
                                      stream: Firestore.instance
                                          .collection("Users")
                                          .document(widget.uidforprofile)
                                          .collection("posts")
                                          .orderBy("date", descending: true)
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData)
                                          return Text('');
                                        return snapshot.data != null
                                            ? ListView.separated(
                                                reverse: true,
                                                separatorBuilder: (ctx, i) =>
                                                    SizedBox(height: 20),
                                                shrinkWrap: true,
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                itemCount: snapshot
                                                    .data.documents.length,
                                                itemBuilder: (ctx, i) {
                                                  DocumentSnapshot course =
                                                      snapshot
                                                          .data.documents[i];

                                                  return snapshot.data == null
                                                      ? Container(
                                                          width: 20,
                                                          height: 20,
                                                        )
                                                      : Align(
                                                          alignment:
                                                              Alignment.center,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 15,
                                                                    right: 15,
                                                                    top: 20),
                                                            child: Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  gradient: LinearGradient(
                                                                      begin: Alignment
                                                                          .topLeft,
                                                                      end: Alignment
                                                                          .bottomRight,
                                                                      colors: [
                                                                        Color(4280311451)
                                                                            .withOpacity(0.4),
                                                                        Color(4278547942)
                                                                            .withOpacity(0.4),
                                                                      ]),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20),
                                                                ),
                                                                child: Stack(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    children: [
                                                                      Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(8.0),
                                                                        child:
                                                                            Column(
                                                                          children: [
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(top: 1, left: 10),
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Container(
                                                                                      child: Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                    children: [
                                                                                      StreamBuilder(
                                                                                          stream: Firestore.instance.collection("Users").document(course["uid"]).snapshots(),
                                                                                          builder: (ctx, i) {
                                                                                            return i.data == null
                                                                                                ? Container(width: 20, height: 20)
                                                                                                : Row(
                                                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                                                    children: [
                                                                                                      i.data["location"] != null
                                                                                                          ? Container(
                                                                                                              width: 45,
                                                                                                              height: 45,
                                                                                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), image: DecorationImage(image: NetworkImage(i.data["location"]), fit: BoxFit.fill)),
                                                                                                            )
                                                                                                          : Container(
                                                                                                              width: 45,
                                                                                                              height: 45,
                                                                                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), image: DecorationImage(image: AssetImage("assets/unknown.png"), fit: BoxFit.fill)),
                                                                                                            ),
                                                                                                      SizedBox(
                                                                                                        width: 10,
                                                                                                      ),
                                                                                                      Padding(
                                                                                                        padding: const EdgeInsets.only(bottom: 10),
                                                                                                        child: Column(
                                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                                                          children: [
                                                                                                            Container(
                                                                                                              width: MediaQuery.of(context).size.width * 0.50,
                                                                                                              child: SingleChildScrollView(
                                                                                                                scrollDirection: Axis.horizontal,
                                                                                                                child: Padding(
                                                                                                                    padding: const EdgeInsets.only(
                                                                                                                      top: 16,
                                                                                                                    ),
                                                                                                                    child: Text(
                                                                                                                      i.data["name"],
                                                                                                                      style: GoogleFonts.poppins(
                                                                                                                        fontSize: 17,
                                                                                                                        fontWeight: FontWeight.w600,
                                                                                                                        color: Colors.white,
                                                                                                                      ),
                                                                                                                    )),
                                                                                                              ),
                                                                                                            ),
                                                                                                            Text(
                                                                                                              i.data["tagline"],
                                                                                                              style: GoogleFonts.poppins(fontSize: 13, color: Colors.white.withOpacity(0.6)),
                                                                                                            )
                                                                                                          ],
                                                                                                        ),
                                                                                                      ),
                                                                                                    ],
                                                                                                  );
                                                                                          }),
                                                                                    ],
                                                                                  )),
                                                                                  Padding(
                                                                                    padding: const EdgeInsets.all(8.0),
                                                                                    child: Container(
                                                                                      width: 50,
                                                                                      height: 50,
                                                                                      decoration: BoxDecoration(
                                                                                        borderRadius: BorderRadius.circular(10),
                                                                                        color: Colors.white.withOpacity(0.12),
                                                                                      ),
                                                                                      child: Padding(
                                                                                        padding: const EdgeInsets.only(top: 5),
                                                                                        child: Column(
                                                                                          children: [
                                                                                            Padding(
                                                                                              padding: const EdgeInsets.only(top: 5),
                                                                                              child: Text(
                                                                                                course["day"],
                                                                                                style: GoogleFonts.poppins(fontSize: 15, height: 1, fontWeight: FontWeight.w600, color: Colors.white),
                                                                                              ),
                                                                                            ),
                                                                                            SizedBox(
                                                                                              height: 3,
                                                                                            ),
                                                                                            Text(
                                                                                              course["month"],
                                                                                              style: GoogleFonts.poppins(height: 1, fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white),
                                                                                            )
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              height: 1,
                                                                            ),
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(left: 10, right: 10),
                                                                              child: Material(
                                                                                borderRadius: BorderRadius.only(
                                                                                  topLeft: Radius.circular(5),
                                                                                  bottomRight: Radius.circular(5),
                                                                                  topRight: Radius.circular(20),
                                                                                  bottomLeft: Radius.circular(20),
                                                                                ),
                                                                                elevation: 3,
                                                                                child: Stack(
                                                                                  alignment: Alignment.center,
                                                                                  children: [
                                                                                    Hero(
                                                                                      tag: "dssd+$i",
                                                                                      child: Material(
                                                                                          borderRadius: BorderRadius.only(
                                                                                            topLeft: Radius.circular(5),
                                                                                            bottomRight: Radius.circular(5),
                                                                                            topRight: Radius.circular(20),
                                                                                            bottomLeft: Radius.circular(20),
                                                                                          ),
                                                                                          elevation: 20,
                                                                                          child: Container(
                                                                                            height: 170,
                                                                                            decoration: BoxDecoration(
                                                                                                borderRadius: BorderRadius.only(
                                                                                                  topLeft: Radius.circular(5),
                                                                                                  bottomRight: Radius.circular(5),
                                                                                                  topRight: Radius.circular(20),
                                                                                                  bottomLeft: Radius.circular(20),
                                                                                                ),
                                                                                                image: course["postimage"] != null ? DecorationImage(image: NetworkImage(course["postimage"]), fit: BoxFit.cover) : DecorationImage(image: AssetImage("assets/unknown.png"))),
                                                                                          )),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              height: 10,
                                                                            ),
                                                                            Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                              children: [
                                                                                Row(
                                                                                  children: [
                                                                                    Image.asset(
                                                                                      "assets/heart.png",
                                                                                      color: Color(4290118716),
                                                                                      scale: 10,
                                                                                    ),
                                                                                    Text(
                                                                                      "${course["likes"]}",
                                                                                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white.withOpacity(1)),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                SizedBox(
                                                                                  width: 0,
                                                                                ),
                                                                                Padding(
                                                                                  padding: const EdgeInsets.only(right: 0),
                                                                                  child: Row(
                                                                                    children: [
                                                                                      Image.asset(
                                                                                        "assets/wow.png",
                                                                                        width: 20,
                                                                                      ),
                                                                                      SizedBox(
                                                                                        width: 5,
                                                                                      ),
                                                                                      Text(
                                                                                        "${course["wow"]}",
                                                                                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white.withOpacity(1)),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                                auth.currentUser.uid == widget.uidforprofile
                                                                                    ? IconButton(
                                                                                        icon: Icon(
                                                                                          Icons.delete_rounded,
                                                                                          color: Colors.white,
                                                                                          size: 22,
                                                                                        ),
                                                                                        onPressed: () {
                                                                                          setState(() {
                                                                                            documentid = course.documentID.toString();
                                                                                          });
                                                                                          print(documentid);
                                                                                          Firestore.instance.collection("Users").document(widget.uidforprofile).collection("posts").document(documentid).delete().then((value) {
                                                                                            Firestore.instance.collection("Feed").document(documentid).delete();
                                                                                          });
                                                                                        })
                                                                                    : Container(
                                                                                        width: 0,
                                                                                        height: 0,
                                                                                      ),
                                                                                SizedBox(
                                                                                  width: 50,
                                                                                ),
                                                                                Padding(
                                                                                  padding: const EdgeInsets.only(left: 0),
                                                                                  child: GestureDetector(
                                                                                      onTap: () {
                                                                                        Navigator.push(
                                                                                            context,
                                                                                            MaterialPageRoute(
                                                                                              builder: (_) => FeedDetilsForEntrepreneurs(documnetid: course.documentID, id: widget.uidforprofile, url: course["video_url"], d: i),
                                                                                            ));
                                                                                      },
                                                                                      child: Container(
                                                                                        alignment: Alignment.center,
                                                                                        width: 100,
                                                                                        height: 30,
                                                                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.white.withOpacity(0.3)),
                                                                                        child: Text(
                                                                                          "Learn More",
                                                                                          style: TextStyle(
                                                                                            fontSize: 22,
                                                                                            fontFamily: "good",
                                                                                            fontWeight: FontWeight.w300,
                                                                                            color: Colors.white,
                                                                                          ),
                                                                                        ),
                                                                                      )),
                                                                                )
                                                                              ],
                                                                            )
                                                                          ],
                                                                        ),
                                                                      )
                                                                    ])),
                                                          ),
                                                        );
                                                })
                                            : Container();
                                      })))
                          : Container(),
                      SizedBox(
                        height: 30,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  String documentid;
}

class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var rect = Offset.zero & size;

    Paint paint = new Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomLeft,
        colors: [
          Colors.white.withOpacity(0.17),
          Colors.white.withOpacity(0.27),
        ],
      ).createShader(rect)
      ..style = PaintingStyle.fill
      ..strokeWidth = 1.48;

    Path path = Path();
    path.moveTo(0, size.height * 0.72);
    path.quadraticBezierTo(size.width * 0.20, size.height * 0.42,
        size.width * 0.45, size.height * 0.64);
    path.cubicTo(size.width * 0.71, size.height * 0.94, size.width * 0.94,
        size.height * 0.62, size.width, size.height);
    path.quadraticBezierTo(
        size.width * 1.10, size.height * 0.78, size.width, 0);
    path.lineTo(0, 0);
    path.lineTo(0, size.height * 0.72);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
