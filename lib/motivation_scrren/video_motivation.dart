import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';
import 'motivation_home.dart';
import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';

class MotivationHome extends StatefulWidget {
  String url;

  MotivationHome(this.url);
  @override
  _MotivationHomeState createState() => _MotivationHomeState();
}

class _MotivationHomeState extends State<MotivationHome> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        _controller.play();
        setState(() {});
      });
    _controller.addListener(() {
      checkVideo();
    });
  }

  
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool isvideoended = false;

  void checkVideo() {
    // Implement your calls inside these conditions' bodies :
    if (_controller.value.position ==
        Duration(seconds: 0, minutes: 0, hours: 0)) {
      setState(() {
        isvideoended = false;
      });
    }

    if (_controller.value.position == _controller.value.duration) {
      print('video Ended');
        setState(() {
          isvideoended = true;
        });
      
    }
  }

  VideoPlayerController _controller;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: 1,
          itemBuilder: (BuildContext context, int index) {
            return Stack(
              alignment: Alignment.bottomLeft,
              children: [
                if (isvideoended == false)
                  Hero(
                    tag: "dd+$index",
                    child: Container(
                      alignment: Alignment.center,
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(),
                      child: FittedBox(
                        fit: BoxFit.fill,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          child: VideoPlayer(_controller),
                        ),
                      ),
                    ),
                  ),
                Material(
                  type: MaterialType.transparency,
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0, bottom: 50),
                      child: Text(
                        "How to find the perfect investor",
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 30,
                            color: Colors.blue),
                      ),
                    ),
                  ),
                ),
                if (isvideoended == true)
                  TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 500),
                    tween: Tween(end: 1, begin: 0),
                    builder:
                        (BuildContext context, dynamic value, Widget child) {
                      return Opacity(
                        opacity: value,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          color: Colors.black.withOpacity(0.8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Share your experience with us",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 50,
                                    color: Colors.blue,
                                    fontFamily: "good"),
                              ),
                              SizedBox(
                                height: 60,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 30.0),
                                    child: Transform.rotate(
                                      angle: 180 * math.pi / 180,
                                      child: Image.asset(
                                        "assets/thumbs_up.png",
                                        scale: 4,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 40,
                                  ),
                                  Image.asset(
                                    "assets/thumbs_up.png",
                                    scale: 4,
                                    color: Colors.blue,
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
