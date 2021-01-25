import 'package:SOAR/screens/post/post_details.dart';
import 'package:SOAR/screens/post/post_image.dart';
import 'package:SOAR/screens/questionnaire/screen1.dart';
import 'package:SOAR/screens/questionnaire/screen2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fade/fade.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_size_getter/file_input.dart';
import 'package:image_size_getter/image_size_getter.dart';
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart';
import '../feed.dart';
import '../start_entrepreneur.dart';
import 'package:get/get.dart';
import 'package:SOAR/screens/post/mainpaost.dart';

class Page3 extends StatefulWidget  {
  @override
  _Page3State createState() => _Page3State();
}

class _Page3State extends State<Page3> {
  DateTime time = DateTime.now();
  Size size;
  Future uploadImage() async {
    DateTime _time = DateTime.now();

    final Reference storageRef = FirebaseStorage.instance.ref();

    UploadTask uploadTask = await storageRef
        .child("post_${auth.currentUser.uid + _time.toString()}.jpg")
        .putFile(image)
        .then((val) {
      val.ref.getDownloadURL().then((val) {
        setState(() {
          downloadUrl = val;
        });
        print(downloadUrl);
      });
      size = ImageSizeGetter.getSize(FileInput(image));
      print(size);
    });
  }

  String id;

  var formatter = new DateFormat('MMM');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    id = new DateTime.now().millisecondsSinceEpoch.toString();
    print(summaryController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(4278197050).withOpacity(0.1),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(right: 0),
                    child: Text(
                      'What\'s your revenue model?',
                      style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.w400,
                          fontFamily: "good",
                          color: Colors.black),
                    ),
                  ),
                  Theme(
                    data: ThemeData.dark(),
                    child: Row(
                      children: [
                        Radio<String>(
                            activeColor: Colors.blue[700],
                            value: "Transactional",
                            groupValue: value_radiobutton,
                            onChanged: (valone) {
                              setState(() {
                                value_radiobutton = valone;
                              });
                            }),
                        Text(
                          'Transactional',
                          style: GoogleFonts.poppins(
                              color: Color(4278228470), fontSize: 15),
                        )
                      ],
                    ),
                  ),
                  Theme(
                    data: ThemeData.dark(),
                    child: Row(
                      children: [
                        Radio<String>(
                            activeColor: Colors.blue[700],
                            value: "Subsricption",
                            groupValue: value_radiobutton,
                            onChanged: (valtwo) {
                              setState(() {
                                value_radiobutton = valtwo;
                              });
                            }),
                        Text(
                          'Subsricption',
                          style: GoogleFonts.poppins(
                              color: Color(4278228470), fontSize: 15),
                        )
                      ],
                    ),
                  ),
                  Theme(
                    data: ThemeData.dark(),
                    child: Row(
                      children: [
                        Radio<String>(
                            activeColor: Colors.blue[700],
                            value: "Advertising",
                            groupValue: value_radiobutton,
                            onChanged: (valthree) {
                              setState(() {
                                value_radiobutton = valthree;
                              });
                            }),
                        Text(
                          'Advertising',
                          style: GoogleFonts.poppins(
                              color: Color(4278228470), fontSize: 15),
                        )
                      ],
                    ),
                  ),
                  Theme(
                    data: ThemeData.dark(),
                    child: Row(
                      children: [
                        Radio<String>(
                            activeColor: Colors.blue[700],
                            value: "Freemium",
                            groupValue: value_radiobutton,
                            onChanged: (valfour) {
                              setState(() {
                                value_radiobutton = valfour;
                              });
                            }),
                        Text(
                          'Freemium',
                          style: GoogleFonts.poppins(
                              color: Color(4278228470), fontSize: 15),
                        )
                      ],
                    ),
                  ),
                  Theme(
                    data: ThemeData.dark(),
                    child: Row(
                      children: [
                        Radio<String>(
                            activeColor: Colors.blue[700],
                            value: "Sales Team",
                            groupValue: value_radiobutton,
                            onChanged: (valfive) {
                              setState(() {
                                value_radiobutton = valfive;
                              });
                            }),
                        Text(
                          'Sales Team',
                          style: GoogleFonts.poppins(
                              color: Color(4278228470), fontSize: 15),
                        )
                      ],
                    ),
                  ),
                  Theme(
                    data: ThemeData.dark(),
                    child: Row(
                      children: [
                        Radio<String>(
                            activeColor: Colors.blue[700],
                            value: "Other",
                            groupValue: value_radiobutton,
                            onChanged: (valsix) {
                              setState(() {
                                value_radiobutton = valsix;
                              });
                            }),
                        Text(
                          'Other',
                          style: GoogleFonts.poppins(
                              color: Color(4278228470), fontSize: 15),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 15, bottom: 20, top: 30, right: 15),
                    child: GestureDetector(
                      onTap: issubmitted == true
                          ? null
                          : () async {
                              if (image != null) {
                                if (video != null) {
                                  await submit();
                                }
                              }
                            },
                      child: Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(11)),
                        child: Text(
                          "Uplaod Post",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                              fontSize: 25,
                              fontWeight: FontWeight.w600,
                              color: Color(4278228470)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
              alignment: Alignment.center,
              child: Fade(
                visible: man,
                duration: Duration(milliseconds: 200),
                child: Padding(
                  padding: const EdgeInsets.only(top: 0, left: 0),
                  child: Align(
                      alignment: Alignment.center,
                      child: Dialog(
                        insetAnimationCurve: Curves.easeIn,
                        insetAnimationDuration: Duration(seconds: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: new BoxDecoration(
                            gradient: LinearGradient(
                                colors: [Color(4278857608), Color(4278256230)],
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft),
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                          child: Container(
                              height: 150,
                              child: show == true
                                  ? Lottie.asset(
                                      "assets/done.json",
                                      repeat: false,
                                    )
                                  : Image.asset("assets/last.gif")),
                        ),
                      )),
                ),
              )),
        ],
      ),
    );
  }

  Future submit() async {
    setState(() {
      issubmitted = true;
      man = true;
    });
    String url;
    await uploadImage();
    final Reference storageRef = FirebaseStorage.instance
        .ref()
        .child("${DateTime.now().toString() + auth.currentUser.uid}");

    UploadTask uploadTask = await storageRef.putFile(video).then((val) async {
      String imageUrl = await storageRef.getDownloadURL();
      setState(() {
        url = imageUrl;
      });
      print(url);
    });
    print(downloadUrl);
    final postsRef = Firestore.instance;
    await postsRef.collection("Feed").document(id).setData({
      "owener": name,
      "summury": summaryController.text,
      "title": pitchname.text,
      "uid": auth.currentUser.uid,
      "date": id,
      "postimage": downloadUrl,
      "features": friendsList.toList(),
      "titles": titleList.toList(),
      "likes": 0,
      "location": dpurl,
      "wow": 0,
      "timeago": DateTime.now().toString(),
      "day": DateFormat('d').format(time), // prints Tuesday,
      "month": formatter.format(time),
      "value_propotion": "${lowPrice.text}",
      "currency": "$currencycode",
      "how_it_helps": pitchController.text,
      "target_audience": companyController.text,
      "company_progress": value_First,
      "revenue_model": value_radiobutton,
      "video_url": url
    });

    final addtouser = Firestore.instance;
    await addtouser
        .collection("Users")
        .document(auth.currentUser.uid)
        .collection("posts")
        .document(id)
        .set({
      "owener": name,
      "summury": summaryController.text,
      "title": pitchname.text,
      "uid": auth.currentUser.uid,
      "date": id,
      "postimage": downloadUrl,
      "features": friendsList.toList(),
      "titles": titleList.toList(),
      "likes": 0,
      "location": dpurl,
      "timeago": DateTime.now().toString(),
      "currency": "$currencycode",
      "wow": 0,
      "day": DateFormat('d').format(time),
      "month": formatter.format(time),
      "value_propotion": "${lowPrice.text}" + "$currencycode",
      "how_it_helps": pitchController.text,
      "target_audience": companyController.text,
      "company_progress": value_First,
      "revenue_model": value_radiobutton,
      "video_url": url
    });
    print("done");

    print(friendsList);
    print(titleList);
    setState(() {
      show = true;
    });
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        show = false;
      });
      setState(() {
        man = false;
        issubmitted = false;
      });
    }).then((value) {
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (_) => HomeEnt()), (route) => false);

      print("hurrayyyyy");
    });
    print(currencycode);
  }

  bool show;
  bool man = false;
  bool issubmitted = false;
}

String value_radiobutton;
