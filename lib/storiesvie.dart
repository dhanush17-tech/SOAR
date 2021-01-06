import 'package:better_player/better_player.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:story_view/story_view.dart';
import 'package:video_player/video_player.dart';

class MoreStories extends StatefulWidget {
  String id;
  MoreStories(this.id);

  @override
  _MoreStoriesState createState() => _MoreStoriesState();
}

class _MoreStoriesState extends State<MoreStories> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    man();
    cool();
    print(imgList);

    print(widget.id);
    setStateIfMounted();
  }

  @override
  void dispose() {
    storyController.dispose();
    super.dispose();
  }

  Future man() async {
    QuerySnapshot _query = await Firestore.instance
        .collection("stories")
        .document(widget.id)
        .get()
        .then((snapshot) {
      imgList.addAll(snapshot["storie_images"]);
      duration.addAll(snapshot["duration"]);
      print(imgList);
    });

    setStateIfMounted();
  }

  void setStateIfMounted() {
    if (mounted) setState(() {});
  }

  Future cool() async {
    await Firestore.instance
        .collection("stories")
        .document(widget.id)
        .get()
        .then((value) {
      nameList = value.data()["name"];

      dpurlList = value.data()["location"];
      print(nameList);
      print(dpurlList);
    });
    setStateIfMounted();
  }

  String nameList;
  String dpurlList;
  List imgList = [];
  List duration = [];

  StoryController storyController = StoryController();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);

    return Scaffold(
      backgroundColor: Color(4278190106),
      body: imgList.length != 0
          ? StoryView(
              storyItems: imgList.map((e) {
                    var index = imgList.indexOf(e);
                    print(duration[index].round());

                    return StoryItem.pageVideo(e,
                        duration:
                            Duration(milliseconds: duration[index].round()),
                        controller: storyController);
                  }).toList() ??
                  Container(),
              onStoryShow: (s) {
                print("Showing a story");
              },
              onComplete: () {
                Navigator.pop(context);
              },
              onVerticalSwipeComplete: (DirectionalFocusAction) {
                Navigator.pop(context);
              },
              progressPosition: ProgressPosition.top,
              repeat: false,
              controller: storyController,
            )
          : Center(
              child: CircularProgressIndicator(
              backgroundColor: Colors.blue[900],
            )),
    );
  }
}
