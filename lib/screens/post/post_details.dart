import 'package:SOAR/screens/post/post_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:SOAR/screens/feed.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:SOAR/screens/start_entrepreneur.dart';
import 'package:fade/fade.dart';
import 'package:intl/intl.dart';

class PostDetails extends StatefulWidget {
  @override
  _PostDetailsState createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> {
  GlobalKey<FormState> _addwidgetfromkey = GlobalKey<FormState>();
  TextEditingController summaryController = TextEditingController();

  String name;
  String dpurl;
  Future<void> _username() async {
    try {
      await Firestore.instance
          .collection("Users")
          .document(auth.currentUser.uid)
          .get()
          .then((value) {
        if (value.exists) {
          setState(() {
            name = value.data()["name"];
            dpurl = value.data()["location"];
          });
        }
      });
    } catch (e) {}
  }

  var formatter = new DateFormat('MMM');
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _username();
  }

  DateTime time = DateTime.now();

  static List<String> friendsList = [null];
  static List<String> titleList = [null];

  GlobalKey<FormState> _content = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);

    return Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Color(4278190106),
        body: Form(
          key: _addwidgetfromkey,
          child: SingleChildScrollView(
            reverse: true,
            child: Column(
              children: [
                Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(25),
                      ),
                      gradient: LinearGradient(
                          colors: [Color(4278857608), Color(4278256230)],
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft),
                      color: Color(4278228470),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 30, left: 10),
                      child: Text("Post A Pitch",
                          style: TextStyle(
                              fontFamily: "good",
                              fontSize: 80,
                              fontWeight: FontWeight.w500,
                              color: Colors.white)),
                    )),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15, top: 10),
                    child: Text(
                      "Description",
                      style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.w500,
                          fontFamily: "good",
                          color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Container(
                        height: 150,
                        width: 500,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Color(4279704112),
                        ),
                        child: Column(
                          children: [
                            Form(
                              key: _content,
                              child: TextFormField(
                                controller: summaryController,
                                validator: (value) => value.length > 20
                                    ? "Your summary should be more than 20"
                                    : null,
                                style: TextStyle(
                                    color: Color(4278228470),
                                    fontSize: 30,
                                    fontFamily: "good",
                                    fontWeight: FontWeight.w500),
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(9),
                                    hintText: "Content",
                                    hintStyle: TextStyle(
                                        color: Color(4278228470),
                                        fontSize: 30,
                                        fontFamily: "good"),
                                    border: InputBorder.none),
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                              ),
                            ),
                          ],
                        )),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 11),
                    child: Text(
                      'Features',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 50,
                          fontWeight: FontWeight.w100,
                          fontFamily: 'good'),
                    ),
                  ),
                  ..._getFriends(),
                  SizedBox(height: 20),
                  Hero(
                    tag: "uplaod",
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15, bottom: 20),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: GestureDetector(
                          onTap: () async {
                            if (_content.currentState.validate()) {
                              if (_addwidgetfromkey.currentState.validate()) {
                                final postsRef = Firestore.instance;
                                await postsRef
                                    .collection("Feed")
                                    .document(time.toString())
                                    .setData({
                                  "owener": name,
                                  "summury": summaryController.text,
                                  "title": pitchname.text,
                                  "uid": auth.currentUser.uid,
                                  "date": DateTime.now().toString(),
                                  "postimage": downloadUrl,
                                  "features": friendsList.toList(),
                                  "titles": titleList.toList(),
                                  "likes": 0,
                                  "location": dpurl,
                                  "wow": 0,
                                  "day": DateFormat('d')
                                      .format(time), // prints Tuesday,
                                  "month": formatter.format(time)
                                });

                                final addtouser = Firestore.instance;
                                await addtouser
                                    .collection("Users")
                                    .document(auth.currentUser.uid)
                                    .collection("posts")
                                    .document(time.toString())
                                    .set({
                                  "owener": name,
                                  "summury": summaryController.text,
                                  "title": pitchname.text,
                                  "uid": auth.currentUser.uid,
                                  "date": DateTime.now().toString(),
                                  "postimage": downloadUrl,
                                  "features": friendsList.toList(),
                                  "titles": titleList.toList(),
                                  "likes": 0,
                                  "location": dpurl,
                                  "wow": 0,
                                  "day": DateFormat('d').format(time),
                                  "month": formatter.format(time)
                                });
                                print("done");

                                print(friendsList);
                                print(titleList);
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    Future.delayed(Duration(milliseconds: 3500),
                                        () {
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        PageRouteBuilder(
                                          transitionDuration:
                                              Duration(seconds: 5),
                                          pageBuilder: (_, __, ___) =>
                                              StartEnt(),
                                        ),
                                        ModalRoute.withName('/'),
                                      );
                                    });
                                    return Fade(
                                      visible: true,
                                      duration: Duration(seconds: 10),
                                      child: Dialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(20),
                                          ),
                                        ),
                                        child: Container(
                                          height: 250,
                                          padding: const EdgeInsets.all(8.0),
                                          decoration: new BoxDecoration(
                                            gradient: LinearGradient(
                                                colors: [
                                                  Color(4278857608),
                                                  Color(4278256230)
                                                ],
                                                begin: Alignment.topRight,
                                                end: Alignment.bottomLeft),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(20),
                                            ),
                                          ),
                                          child: Column(children: [
                                            Container(
                                                height: 203,
                                                width: 350,
                                                child: Center(
                                                  child: Lottie.asset(
                                                    "assets/done.json",
                                                    repeat: false,
                                                  ),
                                                ))
                                          ]),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Container(
                              width: 160,
                              height: 40,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Color(4278228470),
                                  ),
                                  borderRadius: BorderRadius.circular(11)),
                              child: Align(
                                alignment: Alignment.center,
                                child: Material(
                                  type: MaterialType.transparency,
                                  child: Text(
                                    "Uplaod Post",
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w400,
                                        color: Color(4278228470)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ]),
              ],
            ),
          ),
        ));
  }

  List<Widget> _getFriends() {
    List<Widget> friendsTextFields = [];
    List<Widget> titleListFields = [];
    for (int i = 0; i < friendsList.length; i < titleListFields.length, i++) {
      friendsTextFields.add(Padding(
        padding:
            const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: 150,
                width: 500,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Color(4279704112),
                ),
                child: Stack(
                  children: [
                    TitleTextList(i),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 38, left: 5, right: 5),
                      child: SingleChildScrollView(child: FriendTextFields(i)),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 16,
            ),
            // we need add button at last friends row
            _addRemoveButton(i == friendsList.length - 1, i),
          ],
        ),
      ));
    }
    return friendsTextFields;
  }

  /// add / remove button
  Widget _addRemoveButton(bool add, int index) {
    return InkWell(
      onTap: () {
        if (add) {
          // add new text-fields at the top of all friends textfields
          friendsList.insert(0, null);
          titleList.insert(
            0,
            null,
          );
        } else {
          friendsList.removeAt(index);

          titleList.removeAt(index);
        }
        setState(() {});
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: (add) ? Colors.green : Colors.red,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          (add) ? Icons.add : Icons.remove,
          color: Colors.white,
        ),
      ),
    );
  }
}

class FriendTextFields extends StatefulWidget {
  final int index;
  FriendTextFields(this.index);
  @override
  _FriendTextFieldsState createState() => _FriendTextFieldsState();
}

class _FriendTextFieldsState extends State<FriendTextFields> {
  TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _nameController.text = _PostDetailsState.friendsList[widget.index] ?? '';
    });

    return Column(
      children: [
        TextFormField(
          controller: _nameController,
          validator: (v) {
            if (v.trim().isEmpty) return 'Please enter something';
            return null;
          },
          onChanged: (v) => _PostDetailsState.friendsList[widget.index] = v,
          style: TextStyle(
              color: Color(4278228470),
              fontFamily: "good",
              fontSize: 27,
              fontWeight: FontWeight.w400),
          decoration: InputDecoration(
              contentPadding: EdgeInsets.all(5),
              hintText: "Content",
              hintStyle: TextStyle(
                  color: Color(4278228470), fontSize: 30, fontFamily: "good"),
              border: InputBorder.none),
          keyboardType: TextInputType.multiline,
          maxLines: null,
        ),
      ],
    );
  }
}

class TitleTextList extends StatefulWidget {
  final int index;
  TitleTextList(this.index);
  @override
  _TitleTextListState createState() => _TitleTextListState();
}

class _TitleTextListState extends State<TitleTextList> {
  TextEditingController titleTextEditingController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    titleTextEditingController = TextEditingController();
  }

  @override
  void dispose() {
    titleTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      titleTextEditingController.text =
          _PostDetailsState.titleList[widget.index] ?? '';
    });
    return Column(
      children: [
        TextFormField(
          controller: titleTextEditingController,
          validator: (v) {
            if (v.trim().isEmpty) return '';
            return null;
          },
          onChanged: (v) => _PostDetailsState.titleList[widget.index] = v,
          style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w500,
              fontFamily: "good"),
          decoration: InputDecoration(
              contentPadding: EdgeInsets.all(10),
              hintText: "Title",
              hintStyle: TextStyle(
                fontSize: 40,
                color: Colors.white,
                fontFamily: "good",
                fontWeight: FontWeight.w500,
              ),
              border: InputBorder.none),
        ),
      ],
    );
  }
}

TextEditingController pitchname = TextEditingController();
