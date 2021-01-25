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
import 'package:get/get.dart';
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
  int current = 0;

  @override
  void initState() {
    screenProgress = new ProgressTimeline(
      states: allStages,
      iconSize: 35,
      textStyle: TextStyle(fontSize: 0),
    );
    controller = PreloadPageController(initialPage: 0);

    super.initState();
  }

  List man = [PostImage(), PostDetails(), Questionnaire(), Page2(), Page3()];

  GlobalKey<FormState> cool = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    rebuildAllChildren(context);
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Color(0xFFE6EDFA),
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
                    colors: [Colors.indigo, Colors.blue],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight),
                color: Color(0xFFE6EDFA),
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
            height: MediaQuery.of(context).size.height * 0.7099,
            child: Stack(
              children: [
                PreloadPageView.builder(
                    itemBuilder: (BuildContext context, int position) {
                      return Stack(
                        children: [
                          man[position],
                        ],
                      );
                    },
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: 5,
                    controller: controller,
                    onPageChanged: (int position) {
                      setState(() {
                        screenProgress.state.currentStageIndex = position;
                        screenProgress.state.setState(() {});
                      });
                    }),
                button()
              ],
            ),
          ),
        ],
      ),
    );
  }

  void rebuildAllChildren(BuildContext context) {
    void rebuild(Element el) {
      el.markNeedsBuild();
      el.visitChildren(rebuild);
    }

    (context as Element).visitChildren(rebuild);
  }

  Widget button() {
    return FutureBuilder(
        future: Future.value(true),
        builder: (context, snapshot) {
          return Padding(
            padding: const EdgeInsets.only(left: 10.0, bottom: 70, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
          Align(
                        alignment: Alignment.bottomLeft,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              controller.previousPage(
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.easeIn);
                            });
                          },
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.redAccent,
                            ),
                            child: Icon(
                              Icons.arrow_back_rounded,
                              size: 30,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      )
,                pagee == 4
                    ? Container()
                    : FutureBuilder(
                        future: Future.value(true),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          return Align(
                            alignment: Alignment.bottomRight,
                            child: GestureDetector(
                                onTap: () {
                                  if (controller.page == 0) {
                                    key1.currentState.validate()
                                        ? controller.nextPage(
                                            duration:
                                                Duration(milliseconds: 500),
                                            curve: Curves.easeIn)
                                        : null;
                                  }
                                  if (controller.page == 1) {
                                    addwidgetfromkey.currentState.validate()
                                        ? controller.nextPage(
                                            duration:
                                                Duration(milliseconds: 500),
                                            curve: Curves.easeIn)
                                        : null;
                                  }
                                  if (controller.page == 2) {
                                    controller.nextPage(
                                        duration: Duration(milliseconds: 500),
                                        curve: Curves.easeIn);
                                  }
                                  if (controller.page == 3) {
                                    if (value_First != null) {
                                      setState(() {
                                        controller.nextPage(
                                            duration:
                                                Duration(milliseconds: 500),
                                            curve: Curves.easeIn);
                                        pagee = 4;
                                      });
                                    }
                                  }

                                  setState(() {});
                                },
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(4283488874),
                                  ),
                                  child: Icon(
                                    Icons.arrow_forward_rounded,
                                    size: 30,
                                    color: Colors.black,
                                  ),
                                )),
                          );
                        },
                      ),
              ],
            ),
          );
        });
  }

  int pagee;
}

PreloadPageController controller;
