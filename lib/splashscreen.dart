import 'package:SOAR/auth/login.dart';
import 'package:SOAR/screens/start_entrepreneur.dart';
import 'package:SOAR/start.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:SOAR/screens/feed.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';

class Man extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Root(),
    );
  }
}

class Root extends StatefulWidget {
  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  SharedPreferences prefs;
  bool isAuth = false;

  String usertype;

  Future<void> _usertype() async {
    try {
      await Firestore.instance
          .collection("Users")
          .document(auth.currentUser.uid)
          .get()
          .then((value) {
        if (value.exists) {
          setState(() {
            usertype = value.data()["usertype"];
          });
        }
      });
    } catch (e) {}
  }

  @override
  void initState() {
    // TODO: implement initState
    this._function();
    super.initState();
    getTimerWid();
    _usertype();
  }

  gotostart() {
    if (usertype == "investor") {
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (_) => Start()), (route) => false);
    }

    if (usertype == "entrepreneur") {
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (_) => StartEnt()), (route) => false);
    }

    if (usertype == null) {
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (_) => Loginscreen()), (route) => false);
    }
  }

  Timer getTimerWid() {
    return Timer(Duration(seconds: 4), () {
      (isAuth)
          ? gotostart()
          : Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => Loginscreen(),
              ),
            );
      
    });
  }

  @override
  Widget build(BuildContext context) { SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Color(4278857608), Color(4278256230)],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft),
        ),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 120,
              ),
              Text(
                'Soar Throw',
                style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 35),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                  height: 260,
                  child: Image(image: AssetImage('assets/soar.png'))),
              SizedBox(
                height: 15,
              ),
              Text('Igniting your startups',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  )),
              Text('to soar high!',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  )),
              SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: LinearPercentIndicator(
                    alignment: MainAxisAlignment.center,
                    width: 240.0,
                    lineHeight: 4.0,
                    animation: true,
                    percent: 1.0,
                    animationDuration: 3250,
                    backgroundColor: Colors.grey,
                    progressColor: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Null> _function() async {
    prefs = await SharedPreferences.getInstance();
    this.setState(() {
      if (prefs.getString("useremail") != null) {
        isAuth = true;
      } else {
        isAuth = false;
      }
    });
  }
}
