import 'package:SOAR/screens/chat/chat_home.dart';
import 'package:flutter/material.dart';
import 'package:SOAR/screens/profile.dart';
import 'package:google_fonts/google_fonts.dart';

class TextScreen extends StatefulWidget {
  @override
  _TextScreenState createState() => _TextScreenState();
}

class _TextScreenState extends State<TextScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(4278190106),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 30, left: 10, right: 10),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                PageRouteBuilder(
                                    transitionDuration:
                                        Duration(milliseconds: 500),
                                    pageBuilder: (ctx, ani, i) => Profile()));
                          },
                          child: Hero(
                              tag: "good",
                              child: Container(
                                height: 70,
                                width: 70,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage("assets/cool.png"),
                                    ),
                                    borderRadius: BorderRadius.circular(20)),
                              )),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Text(
                          "Alison Danis",
                          style: GoogleFonts.poppins(
                              fontSize: 25,
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 0.83 * size.height,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(35),
                        topRight: Radius.circular(35)),
                    color: Color(4280099132)),
                child: Padding(
                  padding: EdgeInsets.only(bottom: 100),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Padding(
                        padding:
                            const EdgeInsets.only(top: 20, left: 10, right: 10),
                        child: Align(
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Container(
                                  width: 200,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20),
                                          bottomRight: Radius.circular(20)),
                                      color: Color(4278190106)),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: Container(
                                  width: 200,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20),
                                          bottomLeft: Radius.circular(20)),
                                      color: Color(4278190106)),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Container(
                                  width: 200,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20),
                                          bottomRight: Radius.circular(20)),
                                      color: Color(4278190106)),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: Container(
                                  width: 200,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20),
                                          bottomLeft: Radius.circular(20)),
                                      color: Color(4278190106)),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Container(
                                  width: 200,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20),
                                          bottomRight: Radius.circular(20)),
                                      color: Color(4278190106)),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: Container(
                                  width: 200,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20),
                                          bottomLeft: Radius.circular(20)),
                                      color: Color(4278190106)),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Container(
                                  width: 200,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20),
                                          bottomRight: Radius.circular(20)),
                                      color: Color(4278190106)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 80,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                  color: Colors.white),
              child: Align(
                alignment: Alignment.center,
                child: Form(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(
                          suffix: Padding(
                            padding: const EdgeInsets.only(right: 10, top: 40),
                            child: FittedBox(
                              child: GestureDetector(
                                onTap: () {},
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(4278190106),
                                  ),
                                  child: Icon(
                                    Icons.send,
                                    color: Color(4278228470),
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          border: InputBorder.none,
                          hintText: "Type your message here",
                          hintStyle: GoogleFonts.poppins(
                              fontSize: 17, fontWeight: FontWeight.w500)),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
