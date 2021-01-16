import 'package:SOAR/screens/post/post_image.dart';
import 'package:SOAR/screens/questionnaire/screen1.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:SOAR/screens/feed.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:SOAR/screens/start_entrepreneur.dart';
import 'package:fade/fade.dart';
import 'package:intl/intl.dart';

class PostDetails extends StatefulWidget {
  @override
  _PostDetailsState createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> {
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

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);

    return Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Color(4278190106),
        body: Form(
          key: addwidgetfromkey,
          child: SingleChildScrollView(
            reverse: true,
            child: Column(
              children: [
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
                              key: content,
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
                                    hintStyle: GoogleFonts.poppins(
                                        color: Color(4278228470),
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500),
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
                      'Value Proposition',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 50,
                          fontWeight: FontWeight.w100,
                          fontFamily: 'good'),
                    ),
                  ),
                  ..._getFriends(),
                  SizedBox(height: 20),
                ]),
                SizedBox(
                  height: MediaQuery.of(context).viewInsets.bottom,
                ),
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
      _nameController.text = friendsList[widget.index] ?? '';
    });

    return Column(
      children: [
        TextFormField(
          controller: _nameController,
          validator: (v) {
            if (v.trim().isEmpty) return 'Please enter something';
            return null;
          },
          onChanged: (v) => friendsList[widget.index] = v,
          style: TextStyle(
              color: Color(4278228470),
              fontFamily: "good",
              fontSize: 27,
              fontWeight: FontWeight.w400),
          decoration: InputDecoration(
              contentPadding: EdgeInsets.all(5),
              hintText: "Content",
              hintStyle: GoogleFonts.poppins(
                  color: Color(4278228470),
                  fontSize: 20,
                  fontWeight: FontWeight.w500),
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
      titleTextEditingController.text = titleList[widget.index] ?? '';
    });
    return Column(
      children: [
        TextFormField(
          controller: titleTextEditingController,
          validator: (v) {
            if (v.trim().isEmpty) return '';
            return null;
          },
          onChanged: (v) => titleList[widget.index] = v,
          style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w500,
              fontFamily: "good"),
          decoration: InputDecoration(
              contentPadding: EdgeInsets.all(10),
              hintText: "Title",
              hintStyle: GoogleFonts.poppins(
                fontSize: 25,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
              border: InputBorder.none),
        ),
      ],
    );
  }
}

TextEditingController pitchname = TextEditingController();
List<String> friendsList = [null];
List<String> titleList = [null];
String name;
String dpurl;
TextEditingController summaryController = TextEditingController();
GlobalKey<FormState> content = GlobalKey<FormState>();
GlobalKey<FormState> addwidgetfromkey = GlobalKey<FormState>();
