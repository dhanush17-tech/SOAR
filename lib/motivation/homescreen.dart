import 'package:SOAR/screens/feed.dart';
import 'package:SOAR/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'video_promotion.dart';
import 'package:SOAR/auth/login.dart';
import 'bookmark.dart';
import 'package:SOAR/main_constraints.dart';
import 'package:SOAR/motivation/video_motivation.dart';
import "dart:ui";
import 'package:SOAR/screens/assist.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:easy_gradient_text/easy_gradient_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:sticky_headers/sticky_headers.dart';

void _enablePlatformOverrideForDesktop() {
  if (!kIsWeb && (Platform.isMacOS || Platform.isWindows || Platform.isLinux)) {
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  }
}

void main() {
  _enablePlatformOverrideForDesktop();
  runApp(HomeScreen());
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  String name;
  fetch() {
    Firestore.instance
        .collection("Users")
        .document(auth.currentUser.uid)
        .get()
        .then((value) {
      setState(() {
        name = value.data()["name"];
      });
    });
  }

  @override
  void initState() {
    super.initState();
    fetch();
    controller = PageController();
    _controller = AnimationController(vsync: this, duration: duration);
    _scaleAnimation = Tween<double>(begin: 1, end: 0.8).animate(_controller);
    _menuScaleAnimation =
        Tween<double>(begin: 0.5, end: 1).animate(_controller);
    _slideAnimation = Tween<Offset>(begin: Offset(-1, 0), end: Offset(0, 0))
        .animate(_controller);
    trending();
    getman();
    setState(() {});
  }

  bool isCollapsed = true;

  final Duration duration = const Duration(milliseconds: 300);
  AnimationController _controller;
  Animation<double> _scaleAnimation;
  Animation<double> _menuScaleAnimation;
  Animation<Offset> _slideAnimation;

  bool isDrawerOpen = false;

  Future _signOut() async {
    _logoutUser().then((value) {
      print("done");
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Loginscreen()));
    });
  }

  SharedPreferences prefs;

  Future<Null> _logoutUser() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final FacebookLogin facebookLogIn = FacebookLogin();
    await facebookLogIn.logOut();
    await googleSignIn.signOut();

    prefs = await SharedPreferences.getInstance();
    await prefs.remove("useremail");
  }

  String dpurl;

  Future<void> _edit() async {
    try {
      await Firestore.instance
          .collection("Users")
          .document(auth.currentUser.uid)
          .get()
          .then((value) {
        setState(() {
          dpurl = value.data()["location"];
        });
      });
    } catch (e) {}
  }

  Widget menu(context) {
    return SlideTransition(
      position: _slideAnimation,
      child: ScaleTransition(
        scale: _menuScaleAnimation,
        child: Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: Padding(
            padding: EdgeInsets.only(top: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                StreamBuilder(
                  stream: Firestore.instance
                      .collection("Users")
                      .document(auth.currentUser.uid)
                      .snapshots(),
                  builder: (ctx, sn) {
                    if (!sn.hasData) return Text('');
                    return dpurl != null
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: CircleAvatar(
                                      backgroundColor: Color(4278272638),
                                      backgroundImage: NetworkImage(
                                        dpurl,
                                      ),
                                      radius: 40,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(
                                    sn.data["name"],
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                        fontSize: 20, color: Color(4278228470)),
                                  ),
                                )
                              ],
                            ),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 190),
                                child: CircleAvatar(
                                  backgroundColor: Color(4278272638),
                                  backgroundImage:
                                      AssetImage("assets/unknown.png"),
                                  radius: 40,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 196),
                                child: Text(
                                  sn.data["name"],
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                      fontSize: 20, color: Color(4278228470)),
                                ),
                              )
                            ],
                          );
                  },
                ),
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.592,
                          top: 30),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) => Assist()));
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Image.asset(
                              "assets/faq.png",
                              scale: 19,
                              color: man == false
                                  ? light_text_heading
                                  : dark_text_heading,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Support",
                              style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: man == false
                                      ? light_text_heading
                                      : dark_text_heading),
                            )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.58,
                          top: 30),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) => Assist()));
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Icon(
                              Icons.assignment_outlined,
                              color: man == false
                                  ? light_text_heading
                                  : dark_text_heading,
                            ),
                            SizedBox(
                              width: 2,
                            ),
                            Text(
                              "Privacy policy",
                              style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: man == false
                                      ? light_text_heading
                                      : dark_text_heading),
                            )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.585,
                          top: 30),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) => Assist()));
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.brightness_2_outlined,
                              color: man == false
                                  ? light_text_heading
                                  : dark_text_heading,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Container(
                              height: 25,
                              child: Switch(
                                value: man,
                                onChanged: (value) async {
                                  SharedPreferences preferences =
                                      await SharedPreferences.getInstance();

                                  print("VALUE : $value");
                                  setState(() {
                                    man = value;
                                    preferences.setBool("keys", value);
                                  });
                                },
                                activeTrackColor: Color(4278272638),
                                activeColor: Colors.blue,
                              ),
                            ),
                            SizedBox(
                              height: 12.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.535),
                      child: Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: GestureDetector(
                          onTap: () async {
                            await _signOut();
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Icon(
                                Icons.exit_to_app_outlined,
                                color: Colors.redAccent,
                                size: 25,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "Sign Out",
                                style: GoogleFonts.poppins(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.red),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  trending() async {
    await Firestore.instance
        .collection("trending")
        .getDocuments()
        .then((snapshot) {
      setState(() {
        trending_list
            .addAll(snapshot.documents.map((e) => e.data()["url"]).toList());
      });
    });
    return trending_list;
  }

  List trending_list = [];
  CarouselSlider carouselSlider;

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
  @override
  Widget build(BuildContext context) {
    setState(() {});
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: man == false ? light_background : dark_background,
      body: Stack(
        children: [
          menu(context),
          AnimatedPositioned(
            duration: duration,
            top: 0,
            bottom: isCollapsed ? 0 : 0.02 * screenHeight,
            left: isCollapsed ? 0 : -0.4 * screenWidth,
            right: isCollapsed ? 0 : 0.4 * screenWidth,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Material(
                animationDuration: duration,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  decoration: BoxDecoration(
                      gradient: man == false
                          ? LinearGradient(
                              colors: [light_background, light_background])
                          : LinearGradient(
                              colors: [dark_background, dark_background])),
                  child: CustomScrollView(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      slivers: [
                        SliverAppBar(
                          pinned: false,
                          stretch: false,
                          toolbarHeight: 90,
                          leadingWidth: 0,
                          titleSpacing: 0,
                          leading: Container(
                            width: 0,
                            height: 0,
                          ),
                          backgroundColor:
                              man == false ? light_background : dark_background,
                          title: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 0, top: 20),
                                child: SingleChildScrollView(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Material(
                                            type: MaterialType.transparency,
                                            child: Text(
                                              "Hello There",
                                              style: GoogleFonts.poppins(
                                                color: Color(4278228470),
                                                fontSize: 30,
                                                height: 1,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                100,
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    top: 16,
                                                  ),
                                                  child: name == null
                                                      ? Text("",
                                                          style: GoogleFonts
                                                              .poppins(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 25,
                                                            height: 0.5,
                                                            color: man == false
                                                                ? light_text_heading
                                                                : dark_text_heading,
                                                          ))
                                                      : Text(name,
                                                          style: GoogleFonts
                                                              .poppins(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 25,
                                                            height: 0.5,
                                                            color: man == false
                                                                ? light_text_heading
                                                                : dark_text_heading,
                                                          ))),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      isCollapsed
                                          ? Padding(
                                              padding: EdgeInsets.only(
                                                  bottom: 30, right: 0),
                                              child: IconButton(
                                                icon: Icon(
                                                  Icons.menu,
                                                  size: 30,
                                                  color: Colors.blue,
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    if (isCollapsed)
                                                      _controller.forward();
                                                    else
                                                      _controller.reverse();

                                                    isCollapsed = !isCollapsed;
                                                  });
                                                },
                                              ),
                                            )
                                          : Padding(
                                              padding: EdgeInsets.only(
                                                  bottom: 0, right: 0),
                                              child: IconButton(
                                                icon: Icon(
                                                  Icons.arrow_back_ios,
                                                  color: Colors.blue,
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    if (isCollapsed)
                                                      _controller.forward();
                                                    else
                                                      _controller.reverse();

                                                    isCollapsed = !isCollapsed;
                                                  });
                                                },
                                              ))
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SliverList(
                          delegate: SliverChildListDelegate([
                            Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child: Container(
                                    alignment: Alignment.topLeft,
                                    child: GradientText(
                                      text: "Trending",
                                      colors: [Colors.blue, Colors.blueAccent],
                                      style: GoogleFonts.poppins(
                                          fontSize: 28,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                trending_list.length == 0
                                    ? Shimmer(
                                        duration: Duration(
                                            milliseconds: 1500), //Default value
                                        interval: Duration(
                                            milliseconds:
                                                100), //Default value: Duration(seconds: 0)
                                        color: Colors.blue, //Default value
                                        enabled: true, //Default value
                                        direction: ShimmerDirection.fromLTRB(),
                                        child: Container(
                                          height: 200,
                                          width: 320,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color: Colors.blue
                                                  .withOpacity(0.25)),
                                        ),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8.0, left: 10),
                                        child: Container(
                                          height: 200,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Column(
                                            children: [
                                              carouselSlider = CarouselSlider(
                                                  options: CarouselOptions(
                                                    height: 200,
                                                    viewportFraction: 0.9,
                                                    initialPage: 0,
                                                    enlargeCenterPage: true,
                                                    autoPlay: true,
                                                    enableInfiniteScroll: true,
                                                    autoPlayAnimationDuration:
                                                        Duration(seconds: 3),
                                                    autoPlayInterval:
                                                        Duration(seconds: 3),
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                  ),
                                                  items: trending_list
                                                      .map((imgUrl) {
                                                    return trending_list
                                                                .length ==
                                                            0
                                                        ? Shimmer(
                                                            duration: Duration(
                                                                milliseconds:
                                                                    1500), //Default value
                                                            interval: Duration(
                                                                milliseconds:
                                                                    100), //Default value: Duration(seconds: 0)
                                                            color: Colors
                                                                .blue, //Default value
                                                            enabled:
                                                                true, //Default value
                                                            direction:
                                                                ShimmerDirection
                                                                    .fromLTRB(),
                                                            child: Container(
                                                              height: 200,
                                                              width: 320,
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20),
                                                                  color: Colors
                                                                      .blue
                                                                      .withOpacity(
                                                                          0.25)),
                                                            ),
                                                          )
                                                        : Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 0,
                                                                    left: 0,
                                                                    right: 20,
                                                                    bottom: 10),
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {},
                                                              child: Container(
                                                                width: 350,
                                                                decoration:
                                                                    BoxDecoration(
                                                                        border: Border.all(
                                                                            color: Colors
                                                                                .blue,
                                                                            width:
                                                                                2),
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                20),
                                                                        color: Color(
                                                                            4278190106),
                                                                        image: DecorationImage(
                                                                            image: NetworkImage(
                                                                              imgUrl,
                                                                            ),
                                                                            fit: BoxFit.fill)),
                                                              ),
                                                            ),
                                                          );
                                                  }).toList()),
                                            ],
                                          ),
                                        ),
                                      ),
                                SizedBox(
                                  height: 30,
                                ),
                                StickyHeader(
                                  header: Container(
                                    color: man == false
                                        ? light_background
                                        : dark_background,
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 15.0),
                                              child: Container(
                                                alignment: Alignment.topLeft,
                                                child: GradientText(
                                                  text: "Categories",
                                                  colors: [
                                                    Colors.blue,
                                                    Colors.blueAccent
                                                  ],
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 28,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (ctx) =>
                                                            BookMarkPage()));
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8.0, right: 10),
                                                child: Container(
                                                  width: 33,
                                                  height: 33,
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Colors.indigo),
                                                  child: Icon(
                                                    Icons
                                                        .bookmark_border_rounded,
                                                    size: 22,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Container(
                                          height: 50,
                                          child: ListView(
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              children: [
                                                GestureDetector(
                                                  onTap: () => controller
                                                      .animateToPage(0,
                                                          duration: Duration(
                                                              milliseconds:
                                                                  500),
                                                          curve: Curves.easeIn),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 15.0),
                                                    child: Container(
                                                      height: 50,
                                                      decoration: BoxDecoration(
                                                          color:
                                                              Colors.blue[300],
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15)),
                                                      child: Center(
                                                          child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(15.0),
                                                        child: Text(
                                                          "All",
                                                          style: GoogleFonts
                                                              .poppins(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                        ),
                                                      )),
                                                    ),
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () => controller
                                                      .animateToPage(1,
                                                          duration: Duration(
                                                              milliseconds:
                                                                  500),
                                                          curve: Curves.easeIn),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 15.0),
                                                    child: Container(
                                                      height: 50,
                                                      decoration: BoxDecoration(
                                                          color: Color(
                                                                  0xFF5894FA)
                                                              .withOpacity(0.9),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15)),
                                                      child: Center(
                                                          child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(15.0),
                                                        child: Text(
                                                          "Motivational",
                                                          style: GoogleFonts
                                                              .poppins(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                        ),
                                                      )),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 10),
                                                GestureDetector(
                                                  onTap: () => controller
                                                      .animateToPage(2,
                                                          duration: Duration(
                                                              milliseconds:
                                                                  500),
                                                          curve: Curves.easeIn),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 0.0),
                                                    child: Container(
                                                      height: 50,
                                                      decoration: BoxDecoration(
                                                          color:
                                                              Colors.green[300],
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15)),
                                                      child: Center(
                                                          child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(15.0),
                                                        child: Text(
                                                          "Sucess stories",
                                                          style: GoogleFonts
                                                              .poppins(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                        ),
                                                      )),
                                                    ),
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () => controller
                                                      .animateToPage(4,
                                                          duration: Duration(
                                                              milliseconds:
                                                                  500),
                                                          curve: Curves.easeIn),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 15.0),
                                                    child: Container(
                                                      height: 50,
                                                      decoration: BoxDecoration(
                                                          color: Colors
                                                              .pinkAccent[100],
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15)),
                                                      child: Center(
                                                          child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(15.0),
                                                        child: Text(
                                                          "Tips",
                                                          style: GoogleFonts
                                                              .poppins(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                        ),
                                                      )),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 15)
                                              ]),
                                        ),
                                        SizedBox(height: 15)
                                      ],
                                    ),
                                  ),
                                  content: Column(
                                    children: [
                                      FutureBuilder(
                                          future: Future.value(le),
                                          builder: (ctx, s) {
                                            return Container(
                                                height: 700,
                                                child: PageView(
                                                    controller: controller,
                                                    children: [
                                                      BuildHomeCardAll(context),
                                                      BuildHomeCardMotivational(
                                                          context),
                                                      BuildHomeCardSuccess(
                                                          context),
                                                      BuildHomeCardTips(context)
                                                    ]));
                                          }),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ]),
                        )
                      ]),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  int le;

  PageController controller;

  Widget BuildHomeCardSuccess(context) {
    return FutureBuilder(
        future: Firestore.instance
            .collection("all")
            .where("type", isEqualTo: "Success Story")
            .getDocuments(),
        builder: (context, snapshot) {
          return snapshot.data == null
              ? Container()
              : ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (ctx, i) {
                    var success = snapshot.data.documents[i];
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      // Add Your Code here.
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        // Add Your Code here.
                        setState(() {
                          le = snapshot.data.documents.length;
                        });
                      });
                    });

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (c) => MotivationHome(
                                    "Success Story", success.id)));
                      },
                      child: Padding(
                        padding: EdgeInsets.only(top: 0, left: 5, right: 5),
                        child: Container(
                          decoration: BoxDecoration(
                              gradient: man == false
                                  ? LinearGradient(colors: [
                                      Colors.green[300],
                                      Colors.green[300],
                                    ])
                                  : LinearGradient(colors: [
                                      Colors.white.withOpacity(0.25),
                                      Colors.white.withOpacity(0.25)
                                    ]),
                              borderRadius: BorderRadius.circular(20)),
                          child: Stack(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 20, top: 30),
                                    child: Text(
                                      success["Title"],
                                      style: GoogleFonts.poppins(
                                        color: man == false
                                            ? categories_light
                                            : categories_dark,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: 5, left: 20, bottom: 10),
                                    child: SingleChildScrollView(
                                      child: Container(
                                        height: 90,
                                        width:
                                            MediaQuery.of(context).size.width -
                                                220,
                                        child: Text(
                                          success["sub"],
                                          style: GoogleFonts.poppins(
                                            height: 1.2,
                                            color: man == false
                                                ? categories_light
                                                : categories_dark,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 15.0, right: 20),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: FutureBuilder(
                                        future:
                                            Future.value(success["lcation"]),
                                        builder: (context, snapshot) {
                                          return snapshot.data == null
                                              ? Shimmer(
                                                  duration: Duration(
                                                      milliseconds:
                                                          1500), //Default value
                                                  interval: Duration(
                                                      milliseconds:
                                                          100), //Default value: Duration(seconds: 0)
                                                  color: Colors
                                                      .blue, //Default value
                                                  enabled: true, //Default value
                                                  direction: ShimmerDirection
                                                      .fromLTRB(),
                                                  child: Container(
                                                    width: 130,
                                                    height: 130,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                        color: Colors.white
                                                            .withOpacity(.25)),
                                                  ),
                                                )
                                              : Container(
                                                  width: 130,
                                                  height: 130,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      image: DecorationImage(
                                                          fit: BoxFit.fill,
                                                          image: NetworkImage(
                                                              success[
                                                                  "lcation"]))),
                                                );
                                        }),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  scrollDirection: Axis.vertical,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                );
        });
  }

  Widget BuildHomeCardMotivational(context) {
    return StreamBuilder(
        stream: Firestore.instance
            .collection("all")
            .where("type", isEqualTo: "Motivational")
            .snapshots(),
        builder: (context, snapshot) {
          return snapshot.data == null
              ? Container()
              : ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (ctx, i) {
                    var success = snapshot.data.documents[i];
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      // Add Your Code here.
                      setState(() {
                        le = snapshot.data.documents.length;
                      });
                    });
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (c) => MotivationHome(
                                    "Motivational", success.id)));
                      },
                      child: Padding(
                        padding: EdgeInsets.only(top: 0, left: 5, right: 5),
                        child: Container(
                          decoration: BoxDecoration(
                              gradient: man == false
                                  ? LinearGradient(colors: [
                                      Color(0xFF5894FA).withOpacity(0.9),
                                      Color(0xFF5894FA).withOpacity(0.9),
                                    ])
                                  : LinearGradient(colors: [
                                      Colors.white.withOpacity(0.25),
                                      Colors.white.withOpacity(0.25)
                                    ]),
                              borderRadius: BorderRadius.circular(20)),
                          child: Stack(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 20, top: 30),
                                    child: Text(
                                      success["Title"],
                                      style: GoogleFonts.poppins(
                                        color: man == false
                                            ? categories_light
                                            : categories_dark,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: 5, left: 20, bottom: 10),
                                    child: SingleChildScrollView(
                                      child: Container(
                                        height: 90,
                                        width:
                                            MediaQuery.of(context).size.width -
                                                220,
                                        child: Text(
                                          success["sub"],
                                          style: GoogleFonts.poppins(
                                            height: 1.2,
                                            color: man == false
                                                ? categories_light
                                                : categories_dark,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 15.0, right: 20),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: FutureBuilder(
                                        future:
                                            Future.value(success["lcation"]),
                                        builder: (context, snapshot) {
                                          return snapshot.data == null
                                              ? Shimmer(
                                                  duration: Duration(
                                                      milliseconds:
                                                          1500), //Default value
                                                  interval: Duration(
                                                      milliseconds:
                                                          100), //Default value: Duration(seconds: 0)
                                                  color: Colors
                                                      .blue, //Default value
                                                  enabled: true, //Default value
                                                  direction: ShimmerDirection
                                                      .fromLTRB(),
                                                  child: Container(
                                                    width: 130,
                                                    height: 130,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                        color: Colors.white
                                                            .withOpacity(.25)),
                                                  ),
                                                )
                                              : Container(
                                                  width: 130,
                                                  height: 130,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      image: DecorationImage(
                                                          fit: BoxFit.fill,
                                                          image: NetworkImage(
                                                              success[
                                                                  "lcation"]))),
                                                );
                                        }),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  scrollDirection: Axis.vertical,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                );
        });
  }

  Widget BuildHomeCardTips(context) {
    return StreamBuilder(
        stream: Firestore.instance
            .collection("all")
            .where("type", isEqualTo: "Tips")
            .snapshots(),
        builder: (context, snapshot) {
          return snapshot.data == null
              ? Container()
              : ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (ctx, i) {
                    var success = snapshot.data.documents[i];
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      // Add Your Code here.
                      setState(() {
                        le = snapshot.data.documents.length;
                      });
                    });
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (c) =>
                                    MotivationHome("Tips", success.id)));
                      },
                      child: Padding(
                        padding: EdgeInsets.only(top: 0, left: 5, right: 5),
                        child: Container(
                          decoration: BoxDecoration(
                              gradient: man == false
                                  ? LinearGradient(colors: [
                                      Colors.pinkAccent[100],
                                      Colors.pinkAccent[100]
                                    ])
                                  : LinearGradient(colors: [
                                      Colors.white.withOpacity(0.25),
                                      Colors.white.withOpacity(0.25)
                                    ]),
                              borderRadius: BorderRadius.circular(20)),
                          child: Stack(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 20, top: 30),
                                    child: Text(
                                      success["Title"],
                                      style: GoogleFonts.poppins(
                                        color: man == false
                                            ? categories_light
                                            : categories_dark,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: 5, left: 20, bottom: 10),
                                    child: SingleChildScrollView(
                                      child: Container(
                                        height: 90,
                                        width:
                                            MediaQuery.of(context).size.width -
                                                220,
                                        child: Text(
                                          success["sub"],
                                          style: GoogleFonts.poppins(
                                            height: 1.2,
                                            color: man == false
                                                ? categories_light
                                                : categories_dark,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 15.0, right: 20),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: FutureBuilder(
                                        future:
                                            Future.value(success["lcation"]),
                                        builder: (context, snapshot) {
                                          return snapshot.data == null
                                              ? Shimmer(
                                                  duration: Duration(
                                                      milliseconds:
                                                          1500), //Default value
                                                  interval: Duration(
                                                      milliseconds:
                                                          100), //Default value: Duration(seconds: 0)
                                                  color: Colors
                                                      .blue, //Default value
                                                  enabled: true, //Default value
                                                  direction: ShimmerDirection
                                                      .fromLTRB(),
                                                  child: Container(
                                                    width: 130,
                                                    height: 130,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                        color: Colors.white
                                                            .withOpacity(.25)),
                                                  ),
                                                )
                                              : Container(
                                                  width: 130,
                                                  height: 130,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      image: DecorationImage(
                                                          fit: BoxFit.fill,
                                                          image: NetworkImage(
                                                              success[
                                                                  "lcation"]))),
                                                );
                                        }),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  scrollDirection: Axis.vertical,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                );
        });
  }

  Widget BuildHomeCardAll(context) {
    return StreamBuilder(
        stream: Firestore.instance.collection("all").snapshots(),
        builder: (context, snapshot) {
          return snapshot.data == null
              ? Container()
              : ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (ctx, i) {
                    var success = snapshot.data.documents[i];
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      // Add Your Code here.
                      setState(() {
                        le = snapshot.data.documents.length;
                      });
                    });
                    return GestureDetector(
                      onTap: () {
                        if (success["type"] == "Promotional") {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (c) => PromoVideo(
                                        id: success.id,
                                        url: success["video_url"],
                                      )));
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (c) => MotivationHome(
                                      success["type"], success.id)));
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.only(top: 0, left: 5, right: 5),
                        child: Container(
                          decoration: BoxDecoration(
                              gradient: man == false
                                  ? LinearGradient(colors: [
                                      Colors.blue[300],
                                      Colors.blue[300]
                                    ])
                                  : LinearGradient(colors: [
                                      Colors.white.withOpacity(0.25),
                                      Colors.white.withOpacity(0.25)
                                    ]),
                              borderRadius: BorderRadius.circular(20)),
                          child: Stack(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 20, top: 30),
                                    child: Text(
                                      success["Title"],
                                      style: GoogleFonts.poppins(
                                        color: man == false
                                            ? categories_light
                                            : categories_dark,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: 5, left: 20, bottom: 10),
                                    child: SingleChildScrollView(
                                      child: Container(
                                        height: 90,
                                        width:
                                            MediaQuery.of(context).size.width -
                                                220,
                                        child: Text(
                                          success["sub"],
                                          style: GoogleFonts.poppins(
                                            height: 1.2,
                                            color: man == false
                                                ? categories_light
                                                : categories_dark,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 15.0, right: 20),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: FutureBuilder(
                                        future:
                                            Future.value(success["lcation"]),
                                        builder: (context, snapshot) {
                                          return snapshot.data == null
                                              ? Shimmer(
                                                  duration: Duration(
                                                      milliseconds:
                                                          1500), //Default value
                                                  interval: Duration(
                                                      milliseconds:
                                                          100), //Default value: Duration(seconds: 0)
                                                  color: Colors
                                                      .blue, //Default value
                                                  enabled: true, //Default value
                                                  direction: ShimmerDirection
                                                      .fromLTRB(),
                                                  child: Container(
                                                    width: 130,
                                                    height: 130,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                        color: Colors.white
                                                            .withOpacity(.25)),
                                                  ),
                                                )
                                              : Container(
                                                  width: 130,
                                                  height: 130,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      image: DecorationImage(
                                                          fit: BoxFit.fill,
                                                          image: NetworkImage(
                                                              success[
                                                                  "lcation"]))),
                                                );
                                        }),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  scrollDirection: Axis.vertical,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                );
        });
  }
}
