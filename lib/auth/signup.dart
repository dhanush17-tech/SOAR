import 'package:SOAR/auth/record.dart';
import 'package:SOAR/screens/feed.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:SOAR/start.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  int _radioValue1;

  @override
  void initState() {
    super.initState();
    _radioValue1 = 0;
  }

  String usertype;

  final TextEditingController _taglineforgooglesignin = TextEditingController();
  final TextEditingController _websiteforgooglesignin = TextEditingController();
  final GlobalKey<FormState> _googlesigninKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      body: SingleChildScrollView(
        reverse: true,
        child: Padding(
          padding: EdgeInsets.only(bottom: bottom * 0.25),
          child: Container(
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(4278857608), Color(4278256230)],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter),
            ),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Image.asset(
                    "assets/1.png",
                    height: 350,
                  ),
                ),
                Center(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.2,
                      ),
                      Row(
                        children: <Widget>[
                          SizedBox(
                            width: 40,
                          ),
                          Text(
                            'Sign Up',
                            style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 35),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 40,
                          ),
                          Text(
                            "Ignite your startups to SOAR high ",
                            style: GoogleFonts.poppins(
                                color: Colors.white, fontSize: 16),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Form(
                        key: _formkey,
                        child: Column(
                          children: [
                            Padding(
                                padding:
                                    const EdgeInsets.only(left: 25, right: 25),
                                child: TextFormField(
                                  controller: _emailController,
                                  validator: (email) {
                                    if (!(email.contains('@') &&
                                        email.contains('.'))) {
                                      return 'Enter a valid email';
                                    }
                                  },
                                  obscureText: false,
                                  cursorColor: Colors.white,
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                      disabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.transparent),
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      hintText: "Username",
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
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.transparent),
                                        borderRadius: BorderRadius.circular(20),
                                      )),
                                )),
                            SizedBox(
                              height: 15,
                            ),
                            Padding(
                                padding:
                                    const EdgeInsets.only(left: 25, right: 25),
                                child: TextFormField(
                                  validator: (value) => value.length < 6
                                      ? "Password strength should be more than 6 characters"
                                      : null,
                                  controller: _passwordController,
                                  obscureText: true,
                                  cursorColor: Colors.white,
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                      disabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.transparent),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      hintText: "Password",
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
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.transparent),
                                        borderRadius: BorderRadius.circular(20),
                                      )),
                                )),
                            SizedBox(
                              height: 15,
                            ),
                            Padding(
                                padding:
                                    const EdgeInsets.only(left: 25, right: 25),
                                child: TextFormField(
                                  validator: (value) => value.length == 0
                                      ? "Please Enter A Valid Text"
                                      : null,
                                  controller: _nameController,
                                  obscureText: false,
                                  cursorColor: Colors.white,
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                      disabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.transparent),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      hintText: "Name",
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
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.transparent),
                                        borderRadius: BorderRadius.circular(20),
                                      )),
                                )),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.08,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 25, right: 25),
                        child: ButtonTheme(
                            buttonColor: Colors.white,
                            minWidth: MediaQuery.of(context).size.width,
                            height: 55,
                            child: RaisedButton(
                              onPressed: () async {
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
                                        title: Text(
                                            'Tell us a bit about yourself',
                                            style:
                                                TextStyle(color: Colors.white)),
                                        content: StatefulBuilder(builder:
                                            (ctx, StateSetter setState) {
                                          return SingleChildScrollView(
                                            child: Container(
                                              height: 250,
                                              child: Column(
                                                children: [
                                                  Expanded(
                                                    child: Form(
                                                      key: _googlesigninKey,
                                                      child: Column(
                                                        children: [
                                                          new Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                SizedBox(
                                                                  width: 20,
                                                                ),
                                                                Theme(
                                                                  data: ThemeData
                                                                      .dark(),
                                                                  child:
                                                                      new Radio<
                                                                          int>(
                                                                    value: 1,
                                                                    groupValue:
                                                                        _radioValue1,
                                                                    onChanged:
                                                                        (val) {
                                                                      print(
                                                                          val);
                                                                      usertype =
                                                                          "entrepreneur";
                                                                      setState(
                                                                          () {
                                                                        _radioValue1 =
                                                                            val;
                                                                      });
                                                                    },
                                                                  ),
                                                                ),
                                                                Text(
                                                                    'Entrepreneur',
                                                                    style: GoogleFonts.poppins(
                                                                        color: Color(
                                                                            4278228470),
                                                                        fontSize:
                                                                            20,
                                                                        fontWeight:
                                                                            FontWeight.w600)),
                                                              ]),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              SizedBox(
                                                                width: 20,
                                                              ),
                                                              Theme(
                                                                data: ThemeData
                                                                    .dark(),
                                                                child:
                                                                    new Radio<
                                                                        int>(
                                                                  value: 2,
                                                                  groupValue:
                                                                      _radioValue1,
                                                                  onChanged:
                                                                      (val) {
                                                                    print(val);
                                                                    usertype =
                                                                        "investor";
                                                                    setState(
                                                                        () {
                                                                      _radioValue1 =
                                                                          val;
                                                                    });
                                                                  },
                                                                ),
                                                              ),
                                                              Text('Investor',
                                                                  style: GoogleFonts.poppins(
                                                                      color: Color(
                                                                          4278228470),
                                                                      fontSize:
                                                                          20,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600)),
                                                            ],
                                                          ),
                                                          Container(
                                                            height: 50,
                                                            width:
                                                                double.infinity,
                                                            child:
                                                                TextFormField(
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                              decoration:
                                                                  InputDecoration(
                                                                hintText:
                                                                    "Link to your website ",
                                                                hintStyle: TextStyle(
                                                                    color: Color(
                                                                        4278228470)),
                                                                enabledBorder:
                                                                    UnderlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(
                                                                    color: Color(
                                                                        4278228470),
                                                                  ),
                                                                ),
                                                                focusedBorder:
                                                                    UnderlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(
                                                                          color:
                                                                              Colors.white),
                                                                ),
                                                                border:
                                                                    UnderlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(
                                                                          color:
                                                                              Colors.white),
                                                                ),
                                                              ),
                                                              validator: (val) =>
                                                                  val.length ==
                                                                          0
                                                                      ? "Please Enter A Valid Text"
                                                                      : null,
                                                              controller:
                                                                  _websiteforgooglesignin,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 30,
                                                          ),
                                                          Container(
                                                              height: 50,
                                                              width: double
                                                                  .infinity,
                                                              child:
                                                                  TextFormField(
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                                decoration:
                                                                    InputDecoration(
                                                                  hintText:
                                                                      "Your Profession",
                                                                  hintStyle:
                                                                      TextStyle(
                                                                          color:
                                                                              Color(4278228470)),
                                                                  enabledBorder:
                                                                      UnderlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                            color:
                                                                                Color(4278228470)),
                                                                  ),
                                                                  focusedBorder:
                                                                      UnderlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                            color:
                                                                                Color(4278228470)),
                                                                  ),
                                                                  border:
                                                                      UnderlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                            color:
                                                                                Color(4278228470)),
                                                                  ),
                                                                ),
                                                                validator: (val) =>
                                                                    val.length ==
                                                                            0
                                                                        ? "Please Enter A Valid Text"
                                                                        : null,
                                                                controller:
                                                                    _taglineforgooglesignin,
                                                                textCapitalization:
                                                                    TextCapitalization
                                                                        .words,
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
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: Text('Cancel'),
                                          ),
                                          FlatButton(
                                            onPressed: () async {
                                              if (_formkey.currentState
                                                  .validate()) {
                                                if (_googlesigninKey
                                                    .currentState
                                                    .validate()) {
                                                  createUser(
                                                      _emailController.text,
                                                      _passwordController.text);
                                                }
                                              }
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              'SignUp',
                                            ),
                                          ),
                                        ],
                                      );
                                    });
                              },
                              child: Text(
                                'Create',
                                style: GoogleFonts.poppins(
                                    color: Color(4278857608),
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold),
                              ),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25)),
                            )),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SharedPreferences prefs;

  Future<Null> _ensureLoggedIn(String value) async {
    prefs = await SharedPreferences.getInstance();
    prefs.setString("useremail", value);
  }

  void createUser(String email, String password) async {
    UserCredential result;
    await _auth
        .createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim())
        .then((reslt) {
      DbService(uid: _auth.currentUser.uid)
          .updateuserdata(
              _nameController.text,
              _taglineforgooglesignin.text,
              _websiteforgooglesignin.text,
              _auth.currentUser.uid,
              usertype,
              null)
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
            "name": _nameController.text,
            "tagline": _taglineforgooglesignin.text,
            "websiteurl": _websiteforgooglesignin.text,
            "usertype": usertype,
          });
        }
        _ensureLoggedIn(_auth.currentUser.email);

        Navigator.pop(context);
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) {
          return Start();
        }));
      });
    }).catchError((err) {});

    //print(result);
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  FirebaseAuth _auth = FirebaseAuth.instance;

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
}
