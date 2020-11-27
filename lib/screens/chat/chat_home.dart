import 'package:SOAR/screens/profile.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'text_screen.dart';

void main() => runApp(ChatScreen());

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(4278190106),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30, left: 15, right: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Hero(
                      tag: "arrow",
                      child: FittedBox(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(4278228470),
                            ),
                            child: Icon(
                              Icons.arrow_back,
                              color: Color(4278190106),
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                      child: Row(
                    children: [
                      GestureDetector(
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
                          child: CircleAvatar(
                            backgroundImage: AssetImage("assets/cool.png"),
                            backgroundColor: Colors.tealAccent,
                            radius: 20,
                          ),
                        ),
                      ),
                    ],
                  ))
                ],
              ),
            ),
            SizedBox(
              height: 60,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Talk to \nyour investor',
                  style: GoogleFonts.poppins(
                      color: Colors.white,
                      height: 1.2,
                      fontSize: 42,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 60),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color(4280099132)),
                width: 350,
                height: 60,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.search,
                        size: 30,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Search',
                        style: GoogleFonts.poppins(
                            fontSize: 20,
                            color: Color(
                              4278228470,
                            ),
                            fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.separated(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (ctx, i) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            PageRouteBuilder(
                                transitionDuration: Duration(milliseconds: 500),
                                pageBuilder: (ctx, ani, i) => TextScreen()));
                      },
                      child: Row(
                        children: [
                          Material(
                            borderRadius: BorderRadius.circular(15),
                            elevation: 20,
                            child: Container(
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.grey,
                                  image: DecorationImage(
                                      image: AssetImage('assets/cool.png'),
                                      fit: BoxFit.contain)),
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Alison Peter',
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 30,
                                    color: Colors.white),
                              ),
                              Text(
                                'UI/UX Designer',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 15,
                                  color: Color(
                                    4278228470,
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, i) {
                    return SizedBox(
                      height: 20,
                    );
                  },
                  itemCount: 5),
            )
          ],
        ),
      ),
    );
  }
}
