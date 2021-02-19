import 'package:SOAR/screens/post/mainpaost.dart';
import 'package:SOAR/screens/post/post_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:SOAR/main_constraints.dart';

class PostImage extends StatefulWidget {
  @override
  _PostImageState createState() => _PostImageState();
}

class _PostImageState extends State<PostImage> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    getman();
  }

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

  TabController _nestedTabController;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);

    return Scaffold(
      backgroundColor: man == false ? light_background : dark_background,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: man == false ? light_background : dark_background,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
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
                      color: man == false ? post_title_light : post_title_dark),
                ),
              ),
              Form(
                key: key1,
                child: Padding(
                  padding: const EdgeInsets.only(right: 100, left: 15),
                  child: Container(
                    width: 360,
                    child: new TextFormField(
                        validator: (value) =>
                            value.isEmpty ? 'This field cannot be blank' : null,
                        controller: pitchname,
                        style: GoogleFonts.poppins(
                            height: 1.02,
                            color:
                                man == false ? post_sub_light : post_sub_dark,
                            fontSize: 27,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5),
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color:
                                  man == false ? post_sub_dark : post_sub_light,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color:
                                  man == false ? post_sub_dark : post_sub_light,
                            ),
                          ),
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color:
                                  man == false ? post_sub_dark : post_sub_light,
                            ),
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
                      color: man == false ? post_title_light : post_title_dark),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text(
                  "Make sure you uplaod a vetical poster",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(4278228470),
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
              SizedBox(height: 100),
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

final GlobalKey<FormState> key1 = GlobalKey<FormState>();
String downloadUrl;
File image;
