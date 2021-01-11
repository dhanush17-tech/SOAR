import 'package:SOAR/screens/assist.dart';
import 'package:fade/fade.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:showcaseview/showcase.dart';
import 'package:showcaseview/showcase_widget.dart';




class Manna extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      title: 'Flutter ShowCase',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: ShowCaseWidget(
          onStart: (index, key) {
          },
          onComplete: (index, key) {
          },
          builder: Builder(builder: (context) => ShowcaseScreen()),
          autoPlay: true,
          autoPlayDelay: Duration(seconds: 3),
          autoPlayLockEnable: true,
        ),
      ),
    );
  }
}

class ShowcaseScreen extends StatefulWidget {
  ShowcaseScreen({Key key}) : super(key: key);

  @override
  _ShowcaseScreenState createState() => _ShowcaseScreenState();
}

class _ShowcaseScreenState extends State<ShowcaseScreen>
    with SingleTickerProviderStateMixin {
  List<TextEditingController> _controllers = new List();
  List<GlobalKey<FormState>> _key = new List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(vsync: this, duration: duration);
    _scaleAnimation = Tween<double>(begin: 1, end: 0.8).animate(_controller);
    _menuScaleAnimation =
        Tween<double>(begin: 0.5, end: 1).animate(_controller);
    _slideAnimation = Tween<Offset>(begin: Offset(-1, 0), end: Offset(0, 0))
        .animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey _one = GlobalKey();
    GlobalKey _two = GlobalKey();
    GlobalKey _three = GlobalKey();
    GlobalKey _four = GlobalKey();
    GlobalKey _five = GlobalKey();

    

    WidgetsBinding.instance.addPostFrameCallback((_) =>
        ShowCaseWidget.of(context)
            .startShowCase([_one, _two,   ]));

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    bool isCollapsed = true;
    bool isLiked = false;
    bool iswow = false;
    return Scaffold(
      backgroundColor: Color(4278716491),
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
                  elevation: 8,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: isCollapsed
                          ? BorderRadius.circular(0)
                          : BorderRadius.circular(20),
                      color: Color(4278190106),
                    ),
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10, top: 40),
                              child: SingleChildScrollView(
                                child: Expanded(
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
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.8,
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    top: 16,
                                                  ),
                                                  child: Text("Alison Danis",
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 25,
                                                        height: 0.5,
                                                        color: Colors.white,
                                                      ))),
                                            ),
                                          ),
                                        ],
                                      ),
                                      isCollapsed
                                          ? Padding(
                                              padding: EdgeInsets.only(
                                                  bottom: 50, right: 0),
                                              child: IconButton(
                                                icon: Icon(
                                                  Icons.menu,
                                                  size: 30,
                                                  color: Colors.white,
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
                                          : Padding(
                                              padding: EdgeInsets.only(
                                                  bottom: 50, right: 0),
                                              child: IconButton(
                                                icon: Icon(
                                                  Icons.arrow_back_ios,
                                                  color: Colors.white,
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
                                              )),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: ListView.separated(
                                  separatorBuilder: (ctx, i) =>
                                      SizedBox(height: 20),
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: 4,
                                  itemBuilder: (ctx, i) {
                                    _controllers
                                        .add(new TextEditingController());
                                    _key.add(new GlobalKey<FormState>());

                                    return Align(
                                      alignment: Alignment.center,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15, right: 15, top: 0),
                                        child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white
                                                  .withOpacity(0.27),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Stack(children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 1, left: 10),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Showcase(
                                                            key: _one,
                                                            description: "This is the best ",
                                                            child: Container(
                                                                child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                GestureDetector(
                                                                  onTap: () {},
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Container(
                                                                        width:
                                                                            45,
                                                                        height:
                                                                            45,
                                                                        decoration: BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(10),
                                                                            image: DecorationImage(image: AssetImage("assets/cool.png"), fit: BoxFit.fill)),
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            10,
                                                                      ),
                                                                      Padding(
                                                                        padding:
                                                                            const EdgeInsets.only(bottom: 10),
                                                                        child:
                                                                            Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          children: [
                                                                            Container(
                                                                              width: MediaQuery.of(context).size.width * 0.50,
                                                                              child: SingleChildScrollView(
                                                                                scrollDirection: Axis.horizontal,
                                                                                child: Padding(
                                                                                    padding: const EdgeInsets.only(
                                                                                      top: 16,
                                                                                    ),
                                                                                    child: Text(
                                                                                      "Johnson",
                                                                                      style: GoogleFonts.poppins(
                                                                                        fontSize: 17,
                                                                                        fontWeight: FontWeight.w600,
                                                                                        color: Colors.white,
                                                                                      ),
                                                                                    )),
                                                                              ),
                                                                            ),
                                                                            Text(
                                                                              "UI/UX Designer",
                                                                              style: GoogleFonts.poppins(fontSize: 13, color: Colors.white.withOpacity(0.6)),
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            )),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 11.0,
                                                                    right: 8),
                                                            child: Showcase(
                                                              description: "This is cool",
                                                              key: _two,
                                                              child: Container(
                                                                width: 50,
                                                                height: 50,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                  color: Colors
                                                                      .white
                                                                      .withOpacity(
                                                                          0.9),
                                                                ),
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      top: 5),
                                                                  child: Column(
                                                                    children: [
                                                                      Padding(
                                                                        padding:
                                                                            const EdgeInsets.only(top: 5),
                                                                        child:
                                                                            Text(
                                                                          "7",
                                                                          style: GoogleFonts.poppins(
                                                                              fontSize: 15,
                                                                              height: 1,
                                                                              fontWeight: FontWeight.w600,
                                                                              color: Color(4278228470)),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            3,
                                                                      ),
                                                                      Text(
                                                                        "Dec",
                                                                        style: GoogleFonts.poppins(
                                                                            height:
                                                                                1,
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                            color: Color(4278190106)),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10,
                                                              right: 10),
                                                      child: Stack(
                                                        children: [
                                                          Hero(
                                                            tag: "dssd+$i",
                                                            child: Container(
                                                                height: 170,
                                                                decoration:
                                                                    BoxDecoration(
                                                                        boxShadow: <
                                                                            BoxShadow>[
                                                                      BoxShadow(
                                                                          color: Colors
                                                                              .black54,
                                                                          blurRadius:
                                                                              15.0,
                                                                          offset: Offset(
                                                                              0.0,
                                                                              0.75))
                                                                    ],
                                                                        borderRadius:
                                                                            BorderRadius
                                                                                .only(
                                                                          topLeft:
                                                                              Radius.circular(5),
                                                                          bottomRight:
                                                                              Radius.circular(5),
                                                                          topRight:
                                                                              Radius.circular(20),
                                                                          bottomLeft:
                                                                              Radius.circular(20),
                                                                        ),
                                                                        image: DecorationImage(
                                                                            image:
                                                                                NetworkImage("https://i.pinimg.com/originals/3e/47/41/3e474151bee70e682b19dac7ce5bb57e.jpg"),
                                                                            fit: BoxFit.fill)),
                                                                child: Container(
                                                                  child: Fade(
                                                                    visible:
                                                                        isLiked,
                                                                    duration: Duration(
                                                                        milliseconds:
                                                                            500),
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          203,
                                                                      width:
                                                                          350,
                                                                      child:
                                                                          Center(
                                                                        child: SizedBox(
                                                                            width: 100,
                                                                            height: 100,
                                                                            child: Lottie.asset(
                                                                              "assets/like.json",
                                                                              repeat: false,
                                                                            )),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                )),
                                                          ),
                                                          Container(
                                                              child: Container(
                                                            child: Fade(
                                                              visible: iswow,
                                                              duration: Duration(
                                                                  milliseconds:
                                                                      500),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top:
                                                                            30),
                                                                child:
                                                                    Container(
                                                                  width: 350,
                                                                  child: Center(
                                                                      child: SizedBox(
                                                                          width: 100,
                                                                          height: 100,
                                                                          child: Lottie.asset(
                                                                            "assets/wow.json",
                                                                            repeat:
                                                                                true,
                                                                          ))),
                                                                ),
                                                              ),
                                                            ),
                                                          ))
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 3,
                                                              right: 3),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              GestureDetector(
                                                                  onTap:
                                                                      () async {
                                                                    setState(
                                                                        () {
                                                                      isLiked =
                                                                          true;
                                                                    });
                                                                  },
                                                                  child: Image
                                                                      .asset(
                                                                    "assets/heart.png",
                                                                    color: Color(
                                                                        4290118716),
                                                                    scale: 10,
                                                                  )),
                                                              Text(
                                                                "${20}",
                                                                style: GoogleFonts.poppins(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .white
                                                                        .withOpacity(
                                                                            1)),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    right: 0),
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {
                                                                setState(() {
                                                                  iswow = true;
                                                                });
                                                              },
                                                              child: Row(
                                                                children: [
                                                                  Image.asset(
                                                                    "assets/wow.png",
                                                                    width: 20,
                                                                  ),
                                                                  SizedBox(
                                                                    width: 5,
                                                                  ),
                                                                  Text(
                                                                    "${15}",
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Colors
                                                                            .white
                                                                            .withOpacity(1)),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 4,
                                                          ),
                                                          IconButton(
                                                              icon: Icon(
                                                                Icons
                                                                    .message_outlined,
                                                                color: Color(
                                                                        4278228470)
                                                                    .withOpacity(
                                                                        0.8),
                                                              ),
                                                              onPressed: () {}),
                                                          SizedBox(
                                                            width: 50,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 0),
                                                            child:
                                                                GestureDetector(
                                                                    onTap:
                                                                        () {},
                                                                    child:
                                                                        Container(
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      width:
                                                                          100,
                                                                      height:
                                                                          30,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(8),
                                                                        color: Colors
                                                                            .white
                                                                            .withOpacity(0.8),
                                                                      ),
                                                                      child:
                                                                          Text(
                                                                        "Learn More",
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              22,
                                                                          fontFamily:
                                                                              "good",
                                                                          fontWeight:
                                                                              FontWeight.w300,
                                                                          color:
                                                                              Colors.blue,
                                                                        ),
                                                                      ),
                                                                    )),
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              )
                                            ])),
                                      ),
                                    );
                                  })),
                          SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ))
        ],
      ),
    );
  }

  final Duration duration = const Duration(milliseconds: 300);
  AnimationController _controller;
  Animation<double> _scaleAnimation;
  Animation<double> _menuScaleAnimation;
  Animation<Offset> _slideAnimation;

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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 190),
                        child: CircleAvatar(
                          backgroundColor: Color(4278272638),
                          backgroundImage: AssetImage(
                            "assets/cool.png",
                          ),
                          radius: 40,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 190),
                      child: Text(
                        "Alison Danis1",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                            fontSize: 20, color: Color(4278228470)),
                      ),
                    )
                  ],
                ),
                Column(
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.55),
                      child: Padding(
                        padding: EdgeInsets.only(left: 0),
                        child: GestureDetector(
                          onTap: () {},
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
                                    fontWeight: FontWeight.w500,
                                    color: Colors.red),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.569,
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
                              scale: 15,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Text(
                              "Support",
                              style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            )
                          ],
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
}
