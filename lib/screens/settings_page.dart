import 'package:SOAR/auth/signinmeatods.dart';
import 'package:SOAR/screens/feed.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:SOAR/auth/login.dart';
import 'package:firebase_storage/firebase_storage.dart';

void _enablePlatformOverrideForDesktop() {
  if (!kIsWeb && (Platform.isMacOS || Platform.isWindows || Platform.isLinux)) {
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  }
}

void main() {
  _enablePlatformOverrideForDesktop();
  runApp(SettingsPage());
}

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  TextEditingController nameChange = TextEditingController();
  TextEditingController websiteUrlChnage = TextEditingController();
  TextEditingController taglineChange = TextEditingController();

  Future<void> _fetchUserinfoForSettingsPage() async {
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
            location = value.data()["dpurl"];
          });
        }
      });
    } catch (e) {}
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchUserinfoForSettingsPage();
  }

  FirebaseStorage _storage = FirebaseStorage.instance;
  String location;

  Future uploadPic() async {
    try {
      print(auth.currentUser.uid);
      //Get the file from the image picker and store it
      File image = await ImagePicker.pickImage(source: ImageSource.camera);

      //Create a reference to the location you want to upload to in firebase
      Reference reference = _storage.ref().child("${auth.currentUser.uid}");

      //Upload the file to firebase
      UploadTask uploadTask = reference.putFile(image);

      // Waits till the file is uploaded then stores the download url
      location = await reference.getDownloadURL();
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(auth.currentUser.uid)
          .update({"dpurl": location}).then((value) {
        print("done");
      }).then((value) => _fetchUserinfoForSettingsPage());
      print(location);
      setState(() {});
      //returns the download url
      print(location);
      return location;
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: Color(4278190106),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 30,
              ),
              Text(" Edit Profile",
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 35,
                      color: Colors.white)),
              SizedBox(
                height: 20,
              ),
              location == null
                  ? GestureDetector(
                      onTap: () async {
                        await uploadPic();
                      },
                      child: Center(
                        child: Container(
                          width: 200,
                          height: 200,
                          child: Stack(
                            children: [
                              AvatarGlow(
                                glowColor: Color(4278228470),
                                endRadius: 200.0,
                                duration: Duration(milliseconds: 3000),
                                repeat: true,
                                showTwoGlows: true,
                                child: Material(
                                  elevation: 8.0,
                                  shape: CircleBorder(),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.grey,
                                    backgroundImage: AssetImage(
                                      "assets/unknown.png",
                                    ),
                                    radius: 70.0,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 20,
                                left: 130,
                                child: FittedBox(
                                  child: Container(
                                    width: 45,
                                    height: 45,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.blue,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.5),
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
                    )
                  : GestureDetector(
                      onTap: () async {
                        await uploadPic();
                      },
                      child: Center(
                        child: Container(
                          width: 200,
                          height: 200,
                          child: Stack(
                            children: [
                              AvatarGlow(
                                glowColor: Color(4278228470),
                                endRadius: 200.0,
                                duration: Duration(milliseconds: 3000),
                                repeat: true,
                                showTwoGlows: true,
                                child: Material(
                                  elevation: 8.0,
                                  shape: CircleBorder(),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.grey,
                                    backgroundImage: NetworkImage(location),
                                    radius: 70.0,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 20,
                                left: 130,
                                child: FittedBox(
                                  child: Container(
                                    width: 45,
                                    height: 45,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.blue,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.5),
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
                    ),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text('Full Name',
                    style: GoogleFonts.poppins(
                      color: Colors.grey,
                      fontWeight: FontWeight.w400,
                      fontSize: 17,
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Center(
                  child: Container(
                    width: 360,
                    child: new TextFormField(
                        autofocus: false,
                        controller: nameChange,
                        style: GoogleFonts.poppins(
                            height: 1.02, color: Colors.white, fontSize: 20),
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
              SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text('Website URL',
                    style: GoogleFonts.poppins(
                      color: Colors.grey,
                      fontWeight: FontWeight.w400,
                      fontSize: 17,
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: TextFormField(
                    controller: websiteUrlChnage,
                    style: GoogleFonts.poppins(
                        height: 1.02, color: Colors.white, fontSize: 20),
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
              SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text('Profession',
                    style: GoogleFonts.poppins(
                      color: Colors.grey,
                      fontWeight: FontWeight.w400,
                      fontSize: 17,
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Center(
                  child: Container(
                    width: 360,
                    child: new TextFormField(
                        controller: taglineChange,
                        style: GoogleFonts.poppins(
                            height: 1.02, color: Colors.white, fontSize: 20),
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
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: GestureDetector(
                    onTap: () async {
                      print(auth.currentUser.uid);
                      await FirebaseFirestore.instance
                          .collection('Users')
                          .document(auth.currentUser.uid)
                          .setData({
                        "name": nameChange.text,
                        "tagline": taglineChange.text,
                        "websiteurl": websiteUrlChnage.text,
                        "location": location
                      }).then((value) => print("done"));
                      if (usertype == "investor") {
                        FirebaseFirestore.instance
                            .collection('Investor')
                            .document(auth.currentUser.uid)
                            .setData({
                          "name": nameChange.text,
                          "tagline": taglineChange.text,
                          "websiteurl": websiteUrlChnage.text,
                          "location": location,
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
                          "location": location,
                        });
                      }
                    },
                    child: Container(
                      width: 160,
                      height: 40,
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Color(4278228470),
                          ),
                          borderRadius: BorderRadius.circular(14)),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Save",
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                              color: Color(4278228470)),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.only(bottom: 10, left: 10),
                child: GestureDetector(
                  onTap: () {
                    _signOut();
                  },
                  child: Container(
                    child: Row(
                      children: [
                        Icon(
                          Icons.exit_to_app_outlined,
                          color: Colors.redAccent,
                          size: 35,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          "Sign Out",
                          style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.red),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }

  SharedPreferences prefs;

  Future<Null> _logoutUser() async {
    prefs = await SharedPreferences.getInstance();
    prefs.clear();
    prefs.commit();
  }

  Future _signOut() async {
    await FirebaseAuth.instance.signOut();
    _logoutUser();
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Loginscreen()));
  }
}
