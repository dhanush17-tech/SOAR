import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';

import 'package:SOAR/screens/stories.dart';
import 'package:fade/fade.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'feed.dart';
import 'package:video_compress/video_compress.dart';
import 'dart:io';
import 'package:flutter_video_info/flutter_video_info.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class StoriesAdd extends StatefulWidget {
  @override
  _StoriesAddState createState() => _StoriesAddState();
}

class _StoriesAddState extends State<StoriesAdd> {
  List<File> imageList = [];
  List<String> imgeurls = [];
  List thumbnail = [];
  List duration = [];
  bool show;
  bool man = false;
  imagepic() async {
    File image;
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (ctx) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Container(
              height: 170,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: LinearGradient(
                    colors: [Color(4278857608), Color(4278256230)],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () async {
                      image = await ImagePicker.pickVideo(
                        source: ImageSource.camera,
                      );
                      Navigator.of(context, rootNavigator: true).pop();
                      if (image.path.isEmpty != null) {
                        setState(() {
                          issubmitted = true;
                          man = true;
                        });
                      }
                      final info = await VideoCompress.compressVideo(
                        image.path,
                        quality: VideoQuality.LowQuality,

                        deleteOrigin: false,
                        includeAudio: true, // It's false by default
                      );
                      setState(() {
                        image = info.file;
                      });

                      if (image != null) {
                        imageList.add(image);
                        final uint8list = await VideoThumbnail.thumbnailFile(
                          video: image.path,
                          imageFormat: ImageFormat.PNG,
                          maxWidth:
                              128, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
                          quality: 25,
                        );
                        thumbnail.add(uint8list);
                        print(thumbnail);
                      }
                      show = true;
                      Future.delayed(Duration(seconds: 3), () {
                        setState(() {
                          man = false;
                        });
                        setState(() {
                          show = false;
                          issubmitted = false;
                        });
                      });
                      if (info.duration != null) duration.add(info.duration);
                      print("ddfdff");
                      print(info.duration);
                      print(man);
                      print(show);
                      setStateIfMounted();
                    },
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Color(4278190106)),
                      child: Icon(
                        Icons.camera,
                        color: Color(4278228470),
                        size: 30,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      image = await ImagePicker.pickVideo(
                        source: ImageSource.gallery,
                      );
                      Navigator.of(context, rootNavigator: true).pop();
                      if (image.path.isEmpty != null) {
                        setState(() {
                          issubmitted = true;
                          man = true;
                        });
                      }
                      final info = await VideoCompress.compressVideo(
                        image.path,
                        quality: VideoQuality.LowQuality,

                        deleteOrigin: false,
                        includeAudio: true, // It's false by default
                      );
                      setState(() {
                        image = info.file;
                      });

                      if (image != null) {
                        imageList.add(image);
                        final uint8list = await VideoThumbnail.thumbnailFile(
                          video: image.path,
                          imageFormat: ImageFormat.PNG,
                          maxWidth:
                              128, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
                          quality: 25,
                        );
                        thumbnail.add(uint8list);
                        print(thumbnail);
                      }
                      show = true;
                      Future.delayed(Duration(seconds: 3), () {
                        setState(() {
                          man = false;
                        });
                        setState(() {
                          show = false;
                          issubmitted = false;
                        });
                      });
                      if (info.duration != null) duration.add(info.duration);
                      print("ddfdff");
                      print(info.duration);
                      print(man);
                      print(show);
                      setStateIfMounted();
                    },
                    child: Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Color(4278190106)),
                        child: Image.asset(
                          "assets/gall.png",
                          color: Color(4278228470),
                        )),
                  )
                ],
              ),
            ),
          );
        });
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
            usertype = value.data()["usertype"];
            tagline = value.data()["tagline"];
            name = value.data()["name"];
            location = value.data()["location"];
          });
        }
      });
    } catch (e) {}
  }

  String location;
  String usertype;
  String name;
  String tagline;

  int index;

  Future uploadProfilePicture() async {
    for (int i = 0; i < imageList.length; i++) {
      final Reference storageRef = FirebaseStorage.instance
          .ref()
          .child("${DateTime.now().toString()}$i");

      UploadTask uploadTask =
          await storageRef.putFile(imageList[i]).then((val) async {
        String imageUrl = await storageRef.getDownloadURL();
        imgeurls.add(imageUrl);
        print(imgeurls);
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    imagepic();
    _nowuserdetails();
  }

  void setStateIfMounted() {
    if (mounted) setState(() {});
  }

  bool issubmitted = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);

    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Color(4278190106),
        child: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20, top: 10),
                        child: Text(
                          "Upload Your Story",
                          style: TextStyle(
                              fontFamily: "good",
                              fontSize: 50,
                              color: Color(4278228470)),
                        ),
                      ),
                    ),
                    thumbnail.length == 0
                        ? Container()
                        : Padding(
                            padding: const EdgeInsets.only(bottom: 150),
                            child: Container(
                              height: MediaQuery.of(context).size.height*0.78,
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: ((thumbnail.length) / 2).round(),
                                  itemBuilder: (ctx, i) {
                                    return Padding(
                                      padding: EdgeInsets.only(top: 30),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Column(children: [
                                            TweenAnimationBuilder(
                                                tween: Tween<double>(
                                                    begin: 0, end: 1),
                                                duration: Duration(seconds: 1),
                                                builder: (ctx, value, _) {
                                                  return Opacity(
                                                    opacity: value,
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          decoration:
                                                              BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                  border:
                                                                      Border.all(
                                                                    color: Color(
                                                                        4278228470),
                                                                  )),
                                                          height: 200,
                                                          width: 150,
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(10),
                                                            child: Image.file(
                                                                File(thumbnail[
                                                                    i * 2]),
                                                                fit: BoxFit.fill),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 20,
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                })
                                          ]),
                                          if (i * 2 + 1 < thumbnail.length)
                                            TweenAnimationBuilder(
                                                tween: Tween<double>(
                                                    begin: 0, end: 1),
                                                duration: Duration(seconds: 1),
                                                builder: (ctx, value, _) {
                                                  return Opacity(
                                                    opacity: value,
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          border: Border.all(
                                                            color:
                                                                Color(4278228470),
                                                          )),
                                                      height: 200,
                                                      width: 150,
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                10),
                                                        child: Image.file(
                                                            File(thumbnail[
                                                                i * 2 + 1]),
                                                            fit: BoxFit.fill),
                                                      ),
                                                    ),
                                                  );
                                                })
                                        ],
                                      ),
                                    );
                                  }),
                            ),
                          ),
                  ],
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
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 100, right: 10),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: FloatingActionButton(
                    backgroundColor: Color(4278228470),
                    onPressed: issubmitted == true
                        ? null
                        : () async {
                            await imagepic();
                          },
                    child: Icon(
                      Icons.add,
                      color: Color(4278190106),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding:
                      const EdgeInsets.only(bottom: 10, left: 10, right: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Material(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white.withOpacity(0.23),
                      elevation: 50,
                      child: RaisedButton(
                        onPressed: issubmitted == false
                            ? () async {
                                setState(() {
                                  issubmitted = true;
                                  man = true;
                                });
                                await uploadProfilePicture()
                                    .then((value) async {
                                  await Firestore.instance
                                      .collection("stories")
                                      .add({
                                    "storie_images": imgeurls,
                                    "usertype": usertype,
                                    "name": name,
                                    "location": location,
                                    "uid": auth.currentUser.uid,
                                    "duration": duration
                                  }).then((value) {
                                    print("done");

                                    setState(() {
                                      show = true;
                                    });
                                    Future.delayed(Duration(seconds: 3), () {
                                      setState(() {
                                        show = false;
                                      });
                                      setState(() {
                                        man = false;
                                      });
                                    }).then((value) {
                                      Navigator.pop(context);
                                    });
                                  });
                                });
                              }
                            : null,
                        color: Colors.white.withOpacity(0.23),
                        textColor: Color(4278228470),
                        child: Container(
                          alignment: Alignment.center,
                          height: 55,
                          child: Text(
                            "Proceed",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
