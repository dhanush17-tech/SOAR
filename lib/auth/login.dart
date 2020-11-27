import 'dart:ui';
import 'package:SOAR/auth/forgetpassword.dart';
import 'package:SOAR/screens/feed.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'signinmeatods.dart';
import 'record.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:SOAR/auth/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Loginscreen extends StatefulWidget {
  @override
  _LoginscreenState createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  int _radioValue1;
  String usertype;
  @override
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Future<FirebaseUser> _googleSignIn() async {
    try {
      GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
      GoogleSignInAuthentication gSA = await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: gSA.accessToken,
        idToken: gSA.idToken,
      );
      UserCredential authResult = await _auth.signInWithCredential(credential);
      if (authResult.additionalUserInfo.isNewUser) {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return AlertDialog(
                backgroundColor: Color(4278190106),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                title: Text('Tell us a bit about yourself',
                    style: TextStyle(color: Colors.white)),
                content: StatefulBuilder(
                    builder: (BuildContext ctx, StateSetter setState) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Container(
                      height: 250,
                      child: Column(
                        children: [
                          Expanded(
                            child: Form(
                              key: _googlesigninKey,
                              child: Column(
                                children: [
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Theme(
                                          data: ThemeData.dark(),
                                          child: new Radio<int>(
                                            value: 1,
                                            groupValue: _radioValue1,
                                            onChanged: (val) {
                                              print(val);
                                              usertype = "entrepreneur";
                                              setState(() {
                                                _radioValue1 = val;
                                              });
                                            },
                                          ),
                                        ),
                                        Text('Entrepreneur',
                                            style: GoogleFonts.poppins(
                                                color: Color(4278228470),
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600)),
                                      ]),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Theme(
                                        data: ThemeData.dark(),
                                        child: new Radio<int>(
                                          hoverColor: Colors.pink,
                                          value: 2,
                                          groupValue: _radioValue1,
                                          onChanged: (val) {
                                            print(val);
                                            usertype = "investor";
                                            setState(() {
                                              _radioValue1 = val;
                                            });
                                          },
                                        ),
                                      ),
                                      Text('Investor',
                                          style: GoogleFonts.poppins(
                                              color: Color(4278228470),
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600)),
                                    ],
                                  ),
                                  Container(
                                    height: 50,
                                    width: double.infinity,
                                    child: TextFormField(
                                      style: TextStyle(color: Colors.white),
                                      decoration: InputDecoration(
                                        hintText: "Link to your website ",
                                        hintStyle:
                                            TextStyle(color: Color(4278228470)),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(4278228470)),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(4278228470)),
                                        ),
                                        border: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(4278228470)),
                                        ),
                                      ),
                                      validator: (val) => val.length == 0
                                          ? "Please Enter A Valid Text"
                                          : null,
                                      controller: _websiteforgooglesignin,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Container(
                                      height: 50,
                                      width: double.infinity,
                                      child: TextFormField(
                                        style: TextStyle(color: Colors.white),
                                        decoration: InputDecoration(
                                          hintText: "Your Profession",
                                          hintStyle: TextStyle(
                                              color: Color(4278228470)),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color(4278228470)),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color(4278228470)),
                                          ),
                                          border: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color(4278228470)),
                                          ),
                                        ),
                                        validator: (val) => val.length == 0
                                            ? "Please Enter A Valid Text"
                                            : null,
                                        controller: _taglineforgooglesignin,
                                        textCapitalization:
                                            TextCapitalization.words,
                                      )),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
                actions: <Widget>[
                  FlatButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      await _auth.currentUser
                          .delete()
                          .then((value) => print("deleted"));
                    },
                    child: Text('Cancel'),
                  ),
                  FlatButton(
                    onPressed: () async {
                      if (_googlesigninKey.currentState.validate()) {
                        await _googleSignIn().then((value) {
                          DbService(uid: _auth.currentUser.uid)
                              .updateuserdata(
                            _auth.currentUser.displayName,
                            _taglineforgooglesignin.text,
                            usertype,
                            _websiteforgooglesignin.text,
                            _auth.currentUser.uid,
                          )
                              .then((value) async {
                            if (usertype == "investor") {
                              FirebaseFirestore.instance
                                  .collection('Investor')
                                  .document(auth.currentUser.uid)
                                  .setData({
                                "name": _auth.currentUser.displayName,
                                "tagline": _taglineforgooglesignin.text,
                                "websiteurl": _websiteforgooglesignin.text,
                                "usertype": usertype,
                              });
                            }
                            if (usertype == "entrepreneur") {
                              FirebaseFirestore.instance
                                  .collection('Entrepreneur')
                                  .document(auth.currentUser.uid)
                                  .setData({
                                "name": _auth.currentUser.displayName,
                                "tagline": _taglineforgooglesignin.text,
                                "websiteurl": _websiteforgooglesignin.text,
                                "usertype": usertype,
                              });
                            }
                          });

                          Navigator.pop(context);
                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(builder: (_) {
                            return Feed();
                          }));
                        });
                        _ensureLoggedIn(_auth.currentUser.email);
                      }
                    },
                    child: Text(
                      'Login',
                    ),
                  ),
                ],
              );
            });
      } else {
        _ensureLoggedIn(_auth.currentUser.email);

        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) {
          return Feed();
        }));
      }
    } catch (e) {
      print(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        reverse: true,
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: EdgeInsets.only(bottom: bottom * 0.25),
          child: Center(
            child: Container(
              alignment: Alignment.center,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/1.png'), fit: BoxFit.cover),
                gradient: LinearGradient(
                    colors: [Color(4278857608), Color(4278256230)],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft),
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.25),
                    child: Column(children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            width: 35,
                          ),
                          Text(
                            'Hey there!',
                            style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 35),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 40),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: <Widget>[
                              Text(
                                'Sign in with your account or ',
                                style: GoogleFonts.poppins(
                                    color: Colors.white, fontSize: 14),
                              ),
                              GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SignUpScreen()));
                                  },
                                  child: Text(
                                    'Create one',
                                    style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 14,
                                        decoration: TextDecoration.underline),
                                  ))
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width * 0.04,
                      ),
                      Center(
                        child: Form(
                          key: _formkey,
                          child: Column(
                            children: [
                              Padding(
                                  padding: const EdgeInsets.only(
                                      left: 25, right: 25),
                                  child: TextFormField(
                                    controller: _emailController,
                                    validator: (val) => val.length == 0
                                        ? "Please Enter A Valid Text"
                                        : null,
                                    obscureText: false,
                                    cursorColor: Colors.white,
                                    style: TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                        disabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.transparent),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        hintText: "Username",
                                        prefixIcon: Icon(
                                          Icons.person,
                                          size: 30,
                                        ),
                                        errorText: loginfail
                                            ? "Username or Password dosen't Match"
                                            : null,
                                        hintStyle: TextStyle(
                                            fontSize: 18,
                                            letterSpacing: 1.5,
                                            color: Colors.white70,
                                            fontWeight: FontWeight.w900),
                                        filled: true,
                                        hoverColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        fillColor: Colors.white.withOpacity(.3),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.transparent),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.transparent),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        )),
                                  )),
                              SizedBox(height: 20),
                              Padding(
                                  padding: const EdgeInsets.only(
                                      left: 25, right: 25),
                                  child: TextFormField(
                                    controller: _passwordController,
                                    validator: (val) => val.length == 0
                                        ? "Please Enter A Valid Text"
                                        : null,
                                    obscureText: false,
                                    cursorColor: Colors.white,
                                    style: TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                        disabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.transparent),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        hintText: "Password",
                                        errorText: loginfail
                                            ? "Username or Password dosen't Match"
                                            : null,
                                        prefixIcon: Icon(
                                          Icons.vpn_key_rounded,
                                          size: 30,
                                        ),
                                        hintStyle: TextStyle(
                                            fontSize: 18,
                                            letterSpacing: 1.5,
                                            color: Colors.white70,
                                            fontWeight: FontWeight.w900),
                                        filled: true,
                                        hoverColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        fillColor: Colors.white.withOpacity(.3),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.transparent),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.transparent),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        )),
                                  ))
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.019,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ForgetPassword()));
                            },
                            child: Container(
                              child: Text(
                                'Forgot Password?',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 40,
                          )
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.052,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 25, right: 25),
                        child: ButtonTheme(
                            buttonColor: Colors.white,
                            minWidth: MediaQuery.of(context).size.width,
                            height: 55,
                            child: RaisedButton(
                              onPressed: () {
                                if (_formkey.currentState.validate()) {
                                  _signInUser();
                                }
                              },
                              child: Text("Login",
                                  style: GoogleFonts.poppins(
                                      fontSize: 30,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.blue),
                                  textAlign: TextAlign.center),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25)),
                            )),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.02),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.018,
                                ),
                                Center(
                                  child: Text(
                                    'OR',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.015,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 0),
                                  child: Container(
                                    height: 60,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        GestureDetector(
                                            onTap: () {
                                              print('hello');
                                            },
                                            child: Image(
                                                image: AssetImage(
                                                    'assets/linkedin.png'))),
                                        GestureDetector(
                                            onTap: () async {
                                              _googleSignIn();
                                              SharedPreferences preferences =
                                                  await SharedPreferences
                                                      .getInstance();
                                              preferences.setString("email",
                                                  _auth.currentUser.email);
                                            },
                                            child: Image(
                                                image: AssetImage(
                                                    'assets/google.png')))
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ]),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool loginfail = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _taglineforgooglesignin = TextEditingController();
  final TextEditingController _websiteforgooglesignin = TextEditingController();
  final GlobalKey<FormState> _googlesigninKey = GlobalKey<FormState>();

  FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  SharedPreferences prefs;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  Future<Null> _ensureLoggedIn(String value) async {
    prefs = await SharedPreferences.getInstance();
    prefs.setString("useremail", value);
  }

  void _signInUser() async {
    try {
      await _auth
          .signInWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text)
          .then((res) {
        _displaySnackBar(context, 'success');

        _ensureLoggedIn(_emailController.text);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Feed()));
      }).catchError((err) {
        _displaySnackBar(context, err.code);
        setState(() {
          loginfail = true;
        });
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        // Do something :D
      }
    }
  }

  _displaySnackBar(BuildContext context, String res) {
    final snackBar = SnackBar(
      content: Text(
        res,
        style: TextStyle(color: Colors.white),
      ),
      duration: Duration(seconds: 1),
      backgroundColor: Colors.black,
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
