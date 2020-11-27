import 'package:SOAR/screens/feed.dart';
import 'package:SOAR/screens/profile.dart';
import 'settings_page.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class FeedDetails extends StatefulWidget {
  @override
  _FeedDetailsState createState() => _FeedDetailsState();
}

class _FeedDetailsState extends State<FeedDetails> {
  final double _initFabHeight = 120.0;
  double _fabHeight;
  double _panelHeightOpen;
  double _panelHeightClosed = 95.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fabHeight = _initFabHeight;
  }

  int _seletedItem = 1;
  var _pages = [Profile(), Feed(), SettingsPage(), FeedDetails()];
  GlobalKey _bottomNavigationKey = GlobalKey();

  ScrollController sc;
  @override
  Widget build(BuildContext context) {
    _panelHeightOpen = MediaQuery.of(context).size.height * .80;

    return Scaffold(
      backgroundColor: Color(4278190106),
      body: Stack(
        children: [
          SlidingUpPanel(
            borderRadius: BorderRadius.only(topRight: Radius.circular(70)),
            maxHeight: _panelHeightOpen,
            minHeight: _panelHeightClosed,
            parallaxEnabled: true,
            parallaxOffset: .5,
            panelBuilder: (sc) {
              return ClipRRect(
                borderRadius: BorderRadius.only(topRight: Radius.circular(70)),
                child: Container(
                  decoration: BoxDecoration(
                      color: Color(4278190106),
                      borderRadius:
                          BorderRadius.only(topRight: Radius.circular(70))),
                  child: ListView(
                    controller: sc,
                    children: [
                      Container(
                          padding: EdgeInsets.only(left: 15),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    "About the \npitch ",
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 35,
                                        height: 0.9,
                                        color: Colors.white),
                                  ),
                                ),
                                (SizedBox(height: 40)),
                                Row(
                                  children: [
                                    Hero(
                                      tag: "good",
                                      child: CircleAvatar(
                                        backgroundColor: Colors.tealAccent,
                                        radius: 40,
                                        backgroundImage:
                                            AssetImage("assets/cool.png"),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Row(
                                      children: [
                                        Text("T.Kumaraguru",
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 25,
                                              color: Colors.white,
                                            )),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              PageRouteBuilder(
                                                transitionDuration:
                                                    Duration(milliseconds: 500),
                                                pageBuilder: (_, __, ___) =>
                                                    Profile(),
                                              ),
                                            );
                                          },
                                          child: UnconstrainedBox(
                                            child: Container(
                                                height: 30,
                                                width: 30,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Color(4278228470),
                                                ),
                                                child: Align(
                                                  alignment: Alignment.center,
                                                  child: Icon(
                                                      Icons.arrow_forward,
                                                      size: 30,
                                                      color: Colors.white),
                                                )),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Opacity(
                                      opacity: 0.6,
                                      child: Text(
                                        "ScanIn",
                                        style: GoogleFonts.poppins(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      )),
                                ),
                                SizedBox(
                                  height: 7,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10),
                                  child: Text(
                                      "ScanIn is a free , light-weight and open-source document scanning application that enables PDF scanning right from your mobile.AMAZING FEATURES : ScanIn facilitates amazing features like AI powered   , responsive cropping and easy file sharing.SAFE AND SECURED : The app does not demand unnecessary permissions and does not store user data anywhere - this makes us unique!",
                                      style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 13,
                                          color: Colors.white,
                                          height: 1.2)),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Opacity(
                                      opacity: 0.6,
                                      child: Text(
                                        "Features",
                                        style: GoogleFonts.poppins(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      )),
                                ),
                                SizedBox(height: 15),
                                Padding(
                                  padding: const EdgeInsets.only(right: 20),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      height: 130,
                                      width: 350,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Color(4280099132),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Opacity(
                                            opacity: 0.6,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10, left: 15),
                                              child: Text(
                                                "NO WATERMARKS ",
                                                style: GoogleFonts.poppins(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 15, top: 5),
                                            child: Text(
                                              "High quality PDFs with no watermarks.",
                                              style: GoogleFonts.poppins(
                                                  fontSize: 13,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 20),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      height: 130,
                                      width: 350,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Color(4280099132),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Opacity(
                                            opacity: 0.6,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10, left: 15),
                                              child: Text(
                                                "NO WATERMARKS ",
                                                style: GoogleFonts.poppins(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 15, top: 5),
                                            child: Text(
                                              "High quality PDFs with no watermarks.",
                                              style: GoogleFonts.poppins(
                                                  fontSize: 13,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 20),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      height: 130,
                                      width: 350,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Color(4280099132),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Opacity(
                                            opacity: 0.6,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10, left: 15),
                                              child: Text(
                                                "NO WATERMARKS ",
                                                style: GoogleFonts.poppins(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 15, top: 5),
                                            child: Text(
                                              "High quality PDFs with no watermarks.",
                                              style: GoogleFonts.poppins(
                                                  fontSize: 13,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                )
                              ]))
                    ],
                  ),
                ),
              );
            },
            body: Stack(
              children: [
                Stack(
                  children: [
                    Hero(
                      tag: "mannna",
                      child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                            image: AssetImage(
                              "assets/upload.jpg",
                            ),
                            colorFilter: ColorFilter.linearToSrgbGamma(),
                            fit: BoxFit.fill,
                          ))),
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 15, left: 8),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: FittedBox(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(4278190106),
                                  ),
                                  child: Icon(
                                    Icons.arrow_back,
                                    color: Color(4278228470),
                                    size: 30,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20, left: 12),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Documnet\nScanning \nApp",
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 40,
                                  color: Color(4278190106),
                                  height: 1.02),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              height: 69,
              width: 150,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(30)),
                  color: Color(4278228470)),
              child: Align(
                alignment: Alignment.center,
                child: Text("Cybrin Tech",
                    style: GoogleFonts.poppins(
                        fontSize: 20,
                        color: Color(4278190106),
                        fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
