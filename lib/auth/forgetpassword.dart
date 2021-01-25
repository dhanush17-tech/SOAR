import 'package:SOAR/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgetPassword extends StatefulWidget {
  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  TextEditingController _forgetpassword = TextEditingController();

  final GlobalKey<FormState> _frmkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
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
              Image.asset(
                "assets/1.png",
                height: 400,
              ),
              Center(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 220,
                    ),
                    Row(
                      children: <Widget>[
                        SizedBox(
                          width: 40,
                          height: 5,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hey there!',
                              style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 35),
                            ),
                            Text(
                              'A link will be sent to your mail ',
                              style: GoogleFonts.poppins(
                                  color: Colors.white, fontSize: 17),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Form(
                        key: _frmkey,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 25, right: 25),
                          child: TextFormField(
                            controller: _forgetpassword,
                            validator: (val) => val.length == 0
                                ? "Please Enter A Valid Text"
                                : null,
                            obscureText: false,
                            cursorColor: Colors.white,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                disabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                hintText: "Email",
                                prefixIcon: Icon(
                                  Icons.person,
                                  size: 30,
                                ),
                                hintStyle: TextStyle(
                                    fontSize: 18,
                                    letterSpacing: 1.5,
                                    color: Colors.white70,
                                    fontWeight: FontWeight.w900),
                                filled: true,
                                hoverColor: Colors.white,
                                focusColor: Colors.white,
                                fillColor: Colors.white.withOpacity(.3),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(20),
                                )),
                          ),
                        )),
                    SizedBox(
                      height: 50,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 25, right: 25),
                      child: ButtonTheme(
                          buttonColor: Colors.white,
                          minWidth: MediaQuery.of(context).size.width,
                          height: 55,
                          child: RaisedButton(
                            onPressed: () async {
                              if (_frmkey.currentState.validate()) {
                                await FirebaseAuth.instance
                                    .sendPasswordResetEmail(
                                        email: _forgetpassword.text)
                                    .then((value) {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => Loginscreen()),
                                      (route) => false);
                                  print("doneee!!");
                                });
                              }
                            },
                            child: Text(
                              "Send Link",
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
    );
  }
}
