import 'dart:io';
import 'package:lottie/lottie.dart';
import 'package:fade/fade.dart';
import 'package:flutter/material.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'screen3.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class Page2 extends StatefulWidget {
  @override
  _Page2State createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                    padding: const EdgeInsets.only(top: 40, left: 0),
                    child: Text(
                      'Select your current progress of your product',
                      style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.w400,
                          fontFamily: "good",
                          color: Colors.white),
                    ),
                  ),
                  Theme(
                    data: ThemeData.dark(),
                    child: Row(
                      children: [
                        Radio<String>(
                            activeColor: Colors.blue[700],
                            value: "Ideation",
                            groupValue: value_First,
                            onChanged: (val) {
                              setState(() {
                                value_First = val;
                              });
                            }),
                        Text(
                          'Ideation',
                          style: GoogleFonts.poppins(
                            color: Color(4278228470),
                            fontSize: 15,
                          ),
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
                            value: "Minimal PoC",
                            groupValue: value_First,
                            onChanged: (_) {
                              setState(() {
                                value_First = _;
                              });
                            }),
                        Text(
                          'Minimal PoC',
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
                            value: "Working PoC",
                            groupValue: value_First,
                            onChanged: (_third) {
                              setState(() {
                                value_First = _third;
                              });
                            }),
                        Text(
                          'Working PoC',
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
                            value: "MVP",
                            groupValue: value_First,
                            onChanged: (_fourth) {
                              setState(() {
                                value_First = _fourth;
                              });
                            }),
                        Text(
                          'MVP',
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
                            value: "Fully functional product",
                            groupValue: value_First,
                            onChanged: (_fifth) {
                              setState(() {
                                value_First = _fifth;
                              });
                            }),
                        Text(
                          'Fully functional product',
                          style: GoogleFonts.poppins(
                              color: Color(4278228470), fontSize: 15),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40, left: 0),
                    child: Text(
                      'Uplaod a demo video of your project',
                      style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.w400,
                          fontFamily: "good",
                          color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      imagepic();
                    },
                    child: thumbnail == null
                        ? Center(
                            child: Container(
                                padding: EdgeInsets.all(20),
                                width: 350,
                                height: 250,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.blue.withOpacity(0.5),
                                ),
                                child: Center(
                                  child: Image.asset(
                                    "assets/uploadsign.png",
                                  ),
                                )),
                          )
                        : Center(
                            child: Container(
                                alignment: Alignment.center,
                                width: 250,
                                height: 350,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    image: DecorationImage(
                                        image: FileImage(File(thumbnail)),
                                        fit: BoxFit.cover)),
                            ),
                          )
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
            ),
          ),
        ],
      ),
    );
  }

  bool show;
  bool man = false;
  String thumbnail;
  imagepic() async {
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
                      video = await ImagePicker.pickVideo(
                        source: ImageSource.camera,
                      );
                      Navigator.of(context, rootNavigator: true).pop();
                      if (video.path.isEmpty != null) {
                        setState(() {
                          issubmitted = true;
                          man = true;
                        });
                      }
                      final info = await VideoCompress.compressVideo(
                        video.path,
                        quality: VideoQuality.LowQuality,

                        deleteOrigin: false,
                        includeAudio: true, // It's false by default
                      );
                      setState(() {
                        video = info.file;
                      });

                      if (video != null) {
                        final uint8list = await VideoThumbnail.thumbnailFile(
                          video: video.path,
                          imageFormat: ImageFormat.PNG,
                          maxWidth:
                              128, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
                          quality: 25,
                        );
                        setState(() {
                          thumbnail = uint8list;
                        });
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
                      if (info.duration != null) print("ddfdff");
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
                      video = await ImagePicker.pickVideo(
                        source: ImageSource.gallery,
                      );
                      Navigator.of(context, rootNavigator: true).pop();
                      if (video.path.isEmpty != null) {
                        setState(() {
                          issubmitted = true;
                          man = true;
                        });
                      }
                      final info = await VideoCompress.compressVideo(
                        video.path,
                        quality: VideoQuality.LowQuality,

                        deleteOrigin: false,
                        includeAudio: true, // It's false by default
                      );
                      setState(() {
                        video = info.file;
                      });

                      if (video != null) {
                        final uint8list = await VideoThumbnail.thumbnailFile(
                          video: video.path,
                          imageFormat: ImageFormat.PNG,
                          maxWidth:
                              128, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
                          quality: 25,
                        );
                        setState(() {
                          thumbnail = uint8list;
                        });
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
                      if (info.duration != null) print("ddfdff");
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

  void setStateIfMounted() {
    if (mounted) setState(() {});
  }

  bool issubmitted = false;
}

File video;

String value_First;
