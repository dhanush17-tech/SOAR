import 'package:SOAR/screens/post/post_details.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class PostImage extends StatefulWidget {
  @override
  _PostImageState createState() => _PostImageState();
}

class _PostImageState extends State<PostImage> {
  File image;
  Future uploadImage() async {
    var postImage = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      image = postImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(4278190106),
      body: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(25),
                    ),
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
                child: Center(
                  child: Container(
                    width: 360,
                    child: new TextFormField(
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
              GestureDetector(
                onTap: () {
                  uploadImage();
                },
                child: Align(
                  alignment: Alignment.center,
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
                                            "assets/uploadsign.png")),
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
                                        image: FileImage(
                                          image,
                                        ),
                                        fit: BoxFit.fill)),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
              Hero(
                tag: "next",
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: Duration(milliseconds: 500),
                        pageBuilder: (_, __, ___) => PostDetails(),
                      ),
                    );
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.only(right: 10, bottom: 10, top: 20),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Color(4278228470)),
                              ),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.arrow_forward_ios,
                                color: Color(4278190106),
                              ),
                            ),
                          ],
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
