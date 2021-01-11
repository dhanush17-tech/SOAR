import 'package:SOAR/screens/post/post_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:SOAR/screens/feed.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_size_getter/file_input.dart';
import 'package:image_size_getter/image_size_getter.dart';
import 'dart:io';

class PostImage extends StatefulWidget {
  @override
  _PostImageState createState() => _PostImageState();
}

class _PostImageState extends State<PostImage> with TickerProviderStateMixin {
  TabController _nestedTabController;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);

    return Scaffold(
      backgroundColor: Color(4278190106),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Color(4278190106),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15, top: 10),
                child: Text(
                  "Pitch Name",
                  style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.w500,
                      fontFamily: "good",
                      color: Colors.white),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 100, left: 15),
                child: Form(
                  key: key1,
                  child: Container(
                    width: 360,
                    child: new TextFormField(
                        validator: (e) {
                           e.length == 0 ? "" : null;
                        },
                        controller: pitchname,
                        style: GoogleFonts.poppins(
                            height: 1.02,
                            color: Color(4284376682),
                            fontSize: 27,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5),
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(4278228470)),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(4278228470)),
                          ),
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(4278228470)),
                          ),
                        )),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text(
                  "Poster",
                  style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.w500,
                      fontFamily: "good",
                      color: Colors.white),
                ),
              ),
              Opacity(
                opacity: 0.5,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(
                    "Make sure you uplaod a vetical poster",
                    style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () {
                    manupload();
                  },
                  child: Container(
                    width: 250,
                    height: 350,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(20)),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: 30,
                            ),
                            child: Opacity(
                              opacity: 0.4,
                              child: Container(
                                alignment: Alignment.center,
                                width: 250,
                                height: 350,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Color(4278228470)),
                              ),
                            ),
                          ),
                        ),
                        image == null
                            ? Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 50),
                                    child: Align(
                                        alignment: Alignment.center,
                                        child: Image.asset(
                                          "assets/uploadsign.png",
                                          height: 200,
                                          width: 200,
                                        )),
                                  ),
                                  SizedBox(
                                    height: 6,
                                  ),
                                  Opacity(
                                    opacity: 0.5,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 0),
                                      child: Text(
                                        "Make sure you uplaod a\n poster of size 960 x  1280",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Container(
                                alignment: Alignment.center,
                                width: 250,
                                height: 350,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    image: DecorationImage(
                                        image: FileImage(image),
                                        fit: BoxFit.fill)),
                              )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  manupload() async {
    var postImage = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      image = postImage;
    });
  }
}

 GlobalKey<FormState> key1 = GlobalKey<FormState>();

String downloadUrl;
File image;
