import 'package:SOAR/screens/chat/chat_home.dart';
import 'package:SOAR/screens/post/post_details.dart';
import 'package:SOAR/screens/post/post_image.dart';
import 'package:SOAR/screens/questionnaire/screen1.dart';
import 'package:SOAR/screens/questionnaire/screen2.dart';
import 'package:SOAR/screens/questionnaire/screen3.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:progress_timeline/progress_timeline.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../feed.dart';
import '../profile.dart';
import '../../motivation_scrren/motivation_home.dart';

class MainPost extends StatefulWidget {
  @override
  _MainPostState createState() => _MainPostState();
}

class _MainPostState extends State<MainPost> {
  ProgressTimeline screenProgress;

  List<SingleState> allStages = [
    SingleState(stateTitle: "Stage 1"),
    SingleState(stateTitle: "Stage 2"),
    SingleState(stateTitle: "Stage 3"),
    SingleState(stateTitle: "Stage 4"),
  ];
  PreloadPageController _controller;
  int current = 0;
  bool isOnPageTurning = false;

  void scrollListener() {
    if (isOnPageTurning &&
        _controller.page == _controller.page.roundToDouble()) {
      setState(() {
        current = _controller.page.toInt();
        isOnPageTurning = false;
      });
    } else if (!isOnPageTurning && current.toDouble() != _controller.page) {
      if ((current.toDouble() - _controller.page).abs() > 0.1) {
        setState(() {
          isOnPageTurning = true;
        });
      }
    }
  }

  @override
  void initState() {
    screenProgress = new ProgressTimeline(
      states: allStages,
      iconSize: 35,
      textStyle: TextStyle(fontSize: 0),
    );
    _controller = PreloadPageController(initialPage: 1);
    _controller.addListener(scrollListener);
    pitchname = TextEditingController();
    companyController = TextEditingController();
    summaryController = TextEditingController();
    pitchController = TextEditingController();
    lowPrice = TextEditingController();
    
    super.initState();
  }

  List man = [PostImage(), PostDetails(), Questionnaire(), Page2(), Page3()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Color(4278190106),
      body: Column(
        children: [
          Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(25),
                ),
                gradient: LinearGradient(
                    colors: [Color(4278857608), Color(4278256230)],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft),
                color: Color(4278228470),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 30, left: 10),
                child: Text("Post A Pitch",
                    style: TextStyle(
                        fontFamily: "good",
                        fontSize: 80,
                        fontWeight: FontWeight.w500,
                        color: Colors.white)),
              )),
          SizedBox(
            height: 20,
          ),
          Container(
            padding: EdgeInsets.only(left: 5),
            height: 50,
            child: screenProgress,
          ),
          Container(
              height: MediaQuery.of(context).size.height * 0.70,
              child: PreloadPageView.builder(
                  itemBuilder: (BuildContext context, int position) {
                    return man[position];
                  },
                  itemCount: 5,
                  controller: PreloadPageController(initialPage: 0),
                  onPageChanged: (int position) {
                    setState(() {
                      screenProgress.state.currentStageIndex = position;
                      screenProgress.state.setState(() {});
                    });
                  }))
        ],
      ),
    );
  }
}
