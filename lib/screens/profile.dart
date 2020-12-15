import 'package:SOAR/screens/feed_details.dart';
import 'dart:ui';
import 'package:SOAR/widgets/cards.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:SOAR/screens/feed.dart';
import 'package:google_fonts/google_fonts.dart';
import 'chat/chat_home.dart';
import 'for_users_feed_details.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Profile extends StatefulWidget {
  String uidforprofile;
  String name;
  Profile({this.uidforprofile, this.name});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Future<void> _fetchUserinfoForSettingsPage() async {
    try {
      await Firestore.instance
          .collection("Users")
          .document(widget.uidforprofile)
          .get()
          .then((value) {
        if (value.exists) {
          setState(() {
            dpurl = value.data()["dpurl"];
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

  Future connection() async {
    final QuerySnapshot qSnap = await Firestore.instance
        .collection("Users")
        .document(widget.uidforprofile)
        .collection("following")
        .getDocuments();

    connectionlenght = qSnap.documents.length.toString();
    print(connectionlenght);
  }

  Future checkfor_rentrepreneur() async {
    if (connectionlenght == "0") {
      final QuerySnapshot qSnap = await Firestore.instance
          .collection("Users")
          .document(widget.uidforprofile)
          .collection("followers")
          .getDocuments();
      connectionlenght = qSnap.documents.length.toString();
    } else {
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
            nowuser_dpurl = value.data()["dpurl"];
            nowuser_dpurl = value.data()["dpurl"];
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

  String isfollower;
  checkfollowerexists() async {
    QuerySnapshot _query = await Firestore.instance
        .collection("Users")
        .document(auth.currentUser.uid)
        .collection("following")
        .where('uid_entrepreneur', isEqualTo: widget.uidforprofile)
        .getDocuments();

    if (_query.documents.length > 0) {
      isfollower = "exists";
    } else {
      isfollower = "no";
      print("${isfollower}man");
    }
  }

  String currentusertype;

  Future<void> _usertype() async {
    try {
      await Firestore.instance
          .collection("Users")
          .document(auth.currentUser.uid)
          .get()
          .then((value) {
        if (value.exists) {
          setState(() {
            currentusertype = value.data()["usertype"];
          });
        }
      });
    } catch (e) {}
  }

  TextEditingController nameChange = TextEditingController();
  TextEditingController websiteUrlChnage = TextEditingController();
  TextEditingController taglineChange = TextEditingController();

  Future<void> _edit() async {
    try {
      await Firestore.instance
          .collection("Users")
          .document(auth.currentUser.uid)
          .get()
          .then((value) {
        if (value.exists) {
          setState(() {
            nameChange.text = value.data()["name"];
            websiteUrlChnage.text = value.data()["websiteurl"];
            taglineChange.text = value.data()["tagline"];
            usertype = value.data()["usertype"];
            location = value.data()["dpurl"];
          });
        }
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
            .set({"dpurl": location}, SetOptions(merge: true));
        await _fetchUserinfoForSettingsPage();

        print(location);
      });
    });
  }

  @override
  void initState() {
    checkfollowerexists();
    usertype == "entrepreneur" ? connection() : checkfor_rentrepreneur();
    // TODO: implement initState
    super.initState();
    _fetchUserinfoForSettingsPage();
    _nowuserdetails();
    print(widget.name);
    _edit();
    print(widget.uidforprofile);
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(4278190106),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Align(
                alignment: Alignment.topCenter,
                child: CustomPaint(
                  size: Size(MediaQuery.of(context).size.width, 260),
                  painter: RPSCustomPainter(),
                ),
              ),
            ),
            Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: EdgeInsets.only(top: 50, left: 20),
                  child: location == null
                      ? GestureDetector(
                          onTap: () async {
                            await uploadProfilePicture();
                          },
                          child: Container(
                            width: 200,
                            height: 200,
                            child: Stack(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.grey,
                                  backgroundImage: AssetImage(
                                    "assets/unknown.png",
                                  ),
                                  radius: 85.0,
                                ),
                                Positioned(
                                  bottom: 20,
                                  left: 120,
                                  child: FittedBox(
                                    child: Container(
                                      width: 45,
                                      height: 45,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.blue,
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
                                        size: 30,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : GestureDetector(
                          onTap: () async {
                            await uploadProfilePicture();
                          },
                          child: Container(
                            width: 200,
                            height: 200,
                            child: Stack(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.grey,
                                  backgroundImage: NetworkImage(location),
                                  radius: 85.0,
                                ),
                                Positioned(
                                  bottom: 20,
                                  left: 120,
                                  child: FittedBox(
                                    child: Container(
                                      width: 45,
                                      height: 45,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.blue,
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
                                        size: 30,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                )),
            Padding(
              padding: const EdgeInsets.only(
                top: 210,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 100,
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Positioned(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 0, right: 10),
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
                                                        userDocument["name"] ??
                                                            "It may take some time....",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 55,
                                                            fontFamily: "good"),
                                                      )
                                                    : Container();
                                              })
                                          : Row(
                                              children: [
                                                Container(
                                                  width: 320,
                                                  child: TextFormField(
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
                                                        });
                                                      }
                                                    },
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 55,
                                                        fontFamily: "good"),
                                                  ),
                                                ),
                                                Icon(
                                                  Icons.edit,
                                                  color: Color(4278228470),
                                                )
                                              ],
                                            ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                currentusertype != "entrepreneur"
                                    ? auth.currentUser.uid !=
                                            widget.uidforprofile
                                        ? isfollower == "no"
                                            ? Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 20),
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
                                                        "dpurl": dpurl,
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
                                                        _nowuserdetails();
                                                        _fetchUserinfoForSettingsPage();
                                                        checkfollowerexists();
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
                                                        "dpurl": nowuser_dpurl,
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
                                                        _nowuserdetails();
                                                        _fetchUserinfoForSettingsPage();
                                                        checkfollowerexists();
                                                      });
                                                    },
                                                    child: Container(
                                                      width: 120,
                                                      height: 30,
                                                      decoration: BoxDecoration(
                                                          color:
                                                              Color(4278228470),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10)),
                                                      child: Align(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                          "Follow",
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              color:
                                                                  Colors.white,
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
                                                    top: 20),
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
                                                        _nowuserdetails();
                                                        _fetchUserinfoForSettingsPage();
                                                        checkfollowerexists();
                                                      });

                                                      Firestore.instance
                                                          .collection("Users")
                                                          .document(widget
                                                              .uidforprofile)
                                                          .collection(
                                                              "followers")
                                                          .where('name',
                                                              isEqualTo:
                                                                  widget.name)
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
                                                        _nowuserdetails();
                                                        _fetchUserinfoForSettingsPage();
                                                        checkfollowerexists();
                                                      });
                                                    },
                                                    child: Container(
                                                      width: 120,
                                                      height: 30,
                                                      decoration: BoxDecoration(
                                                          color: Colors.grey,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10)),
                                                      child: Align(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                          "Unfollow",
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              color: Color(
                                                                  4278190106),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                        : Container()
                                    : Container(),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 60,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 13),
                            child: auth.currentUser.uid != widget.uidforprofile
                                ? StreamBuilder(
                                    stream: Firestore.instance
                                        .collection('Users')
                                        .document("${widget.uidforprofile}")
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      var userDocument = snapshot.data;
                                      return snapshot.data == null
                                          ? CircularProgressIndicator()
                                          : Text(
                                              userDocument["tagline"] ??
                                                  "It may take some time....",
                                              style: TextStyle(
                                                color: Colors.white
                                                    .withOpacity(0.7),
                                                fontWeight: FontWeight.w400,
                                                fontSize: 15,
                                              ),
                                            );
                                    })
                                : Container(
                                    width: 320,
                                    child: TextFormField(
                                      controller: taglineChange,
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.7),
                                        fontWeight: FontWeight.w400,
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
                                        }).then((value) => print("done"));
                                        if (usertype == "investor") {
                                          FirebaseFirestore.instance
                                              .collection('Investor')
                                              .document(auth.currentUser.uid)
                                              .setData({
                                            "name": nameChange.text,
                                            "tagline": taglineChange.text,
                                            "websiteurl": websiteUrlChnage.text,
                                          });
                                        }
                                        if (usertype == "entrepreneur") {
                                          FirebaseFirestore.instance
                                              .collection('Entrepreneur')
                                              .document(auth.currentUser.uid)
                                              .setData({
                                            "name": nameChange.text,
                                            "tagline": taglineChange.text,
                                            "websiteurl": websiteUrlChnage.text,
                                          });
                                        }
                                      },
                                      decoration: InputDecoration(
                                          border: InputBorder.none),
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 80,
                    child: Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Row(
                        children: [
                          Image.asset("assets/web.png"),
                          SizedBox(
                            width: 10,
                          ),
                          auth.currentUser.uid != widget.uidforprofile
                              ? StreamBuilder(
                                  stream: Firestore.instance
                                      .collection('Users')
                                      .document("${widget.uidforprofile}")
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    var userDocument = snapshot.data;
                                    return snapshot.data == null
                                        ? CircularProgressIndicator()
                                        : Text(
                                            userDocument["websiteurl"],
                                            style: TextStyle(
                                              color:
                                                  Colors.white.withOpacity(0.5),
                                              fontSize: 15,
                                            ),
                                          );
                                  })
                              : Container(
                                  width: 300,
                                  child: TextFormField(
                                    controller: websiteUrlChnage,
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.5),
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
                                      }).then((value) => print("done"));
                                      if (usertype == "investor") {
                                        FirebaseFirestore.instance
                                            .collection('Investor')
                                            .document(auth.currentUser.uid)
                                            .setData({
                                          "name": nameChange.text,
                                          "tagline": taglineChange.text,
                                          "websiteurl": websiteUrlChnage.text,
                                        });
                                      }
                                      if (usertype == "entrepreneur") {
                                        FirebaseFirestore.instance
                                            .collection('Entrepreneur')
                                            .document(auth.currentUser.uid)
                                            .setData({
                                          "name": nameChange.text,
                                          "tagline": taglineChange.text,
                                          "websiteurl": websiteUrlChnage.text,
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
                  Padding(
                    padding: const EdgeInsets.only(top: 15, left: 30),
                    child: Expanded(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  connectionlenght ?? "0",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 30,
                                      fontWeight: FontWeight.w500),
                                ),
                                Opacity(
                                    opacity: 0.9,
                                    child: Text(
                                      "Connections",
                                      style: TextStyle(
                                        color: Color(4286677377),
                                      ),
                                    )),
                              ],
                            ),
                            SizedBox(
                              width: 30,
                            ),
                            Column(
                              children: [
                                no_ofposts == null
                                    ? Text(
                                        "0",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 30,
                                            fontWeight: FontWeight.w500),
                                      )
                                    : Text(
                                        "$no_ofposts",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 30,
                                            fontWeight: FontWeight.w500),
                                      ),
                                Opacity(
                                    opacity: 0.9,
                                    child: Text(
                                      "Pitches",
                                      style: TextStyle(
                                        color: Color(4286677377),
                                      ),
                                    )),
                              ],
                            ),
                            SizedBox(
                              width: 30,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  "30",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 30,
                                      fontWeight: FontWeight.w500),
                                ),
                                Opacity(
                                    opacity: 0.9,
                                    child: Text(
                                      "Connections",
                                      style: TextStyle(
                                        color: Color(4286677377),
                                      ),
                                    )),
                              ],
                            ),
                            SizedBox(
                              width: 30,
                            ),
                          ]),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5, bottom: 0),
                    child: Text(
                      " Pitches",
                      style: TextStyle(
                          fontSize: 55,
                          fontFamily: "good",
                          color: Colors.white),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: StreamBuilder(
                      stream: Firestore.instance
                          .collection("Users")
                          .document(auth.currentUser.uid)
                          .collection("posts")
                          .orderBy("date", descending: true)
                          .snapshots(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        return snapshot.data != null
                            ? Align(
                                alignment: Alignment.bottomCenter,
                                child: ListView.separated(
                                  physics: NeverScrollableScrollPhysics(),
                                  separatorBuilder: (ctx, i) => SizedBox(
                                    height: 20,
                                  ),
                                  itemCount: snapshot.data.documents.length,
                                  shrinkWrap: true,
                                  itemBuilder: (BuildContext context, int i) {
                                    no_ofposts = snapshot.data.documents.length;
                                    DocumentSnapshot profiledata =
                                        snapshot.data.documents[i];

                                    print(snapshot.data);
                                    if (snapshot.data == null) {
                                      return Align(
                                          alignment: Alignment.bottomCenter,
                                          child: CircularProgressIndicator());
                                    }
                                    return Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Padding(
                                          padding: const EdgeInsets.only(
                                            left: 15,
                                            right: 15,
                                          ),
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(26),
                                              child: Container(
                                                  height: 203,
                                                  width: 350,
                                                  decoration: BoxDecoration(
                                                    color: Color(4280099132),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  alignment: Alignment
                                                      .center, // where to p
                                                  child: Stack(
                                                    children: [
                                                      Hero(
                                                        tag: "flyin+${i++}",
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              image: DecorationImage(
                                                                  image: NetworkImage(
                                                                    profiledata[
                                                                        "postimage"],
                                                                  ),
                                                                  fit: BoxFit.fill)),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 10,
                                                                bottom: 13),
                                                        child: Align(
                                                          alignment: Alignment
                                                              .bottomLeft,
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                profiledata[
                                                                    "title"],
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        40,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontFamily:
                                                                        "good",
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                              Text(
                                                                profiledata[
                                                                    "date"],
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Color(
                                                                        4278228470)),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                bottom: 10,
                                                                right: 10),
                                                        child: Align(
                                                          alignment: Alignment
                                                              .bottomRight,
                                                          child:
                                                              GestureDetector(
                                                            onTap: () {
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder: (_) =>
                                                                      FeedDetilsForEntrepreneurs(
                                                                    documnetid:
                                                                        profiledata
                                                                            .documentID,
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                            child: Container(
                                                                width: 80,
                                                                height: 30,
                                                                decoration: BoxDecoration(
                                                                    color: Color(
                                                                        4278190106),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            20)),
                                                                child: Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    child: Text(
                                                                      "Proceed",
                                                                      style: GoogleFonts.poppins(
                                                                          fontSize:
                                                                              13,
                                                                          color: Color(
                                                                              4278228470),
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ))),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  )),
                                            ),
                                          )),
                                    );
                                  },
                                ),
                              )
                            : Container();
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var rect = Offset.zero & size;

    Paint paint = new Paint()
      ..shader = LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [
          Colors.blue[900],
          Colors.blue[500],
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
