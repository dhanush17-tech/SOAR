import 'package:flutter/material.dart';
import 'package:SOAR/screens/feed.dart';

class PostDetails extends StatefulWidget {
  @override
  _PostDetailsState createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> {
  List<Widget> list = new List();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Color(4278190106),
      body: SingleChildScrollView(
        reverse: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(25),
                  ),
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
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: const EdgeInsets.only(left: 15, top: 10),
                child: Text(
                  "Description",
                  style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.w500,
                      fontFamily: "good",
                      color: Colors.white),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Container(
                    height: 150,
                    width: 500,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Color(4279704112),
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: TextFormField(
                            style: TextStyle(
                                color: Color(4278228470),
                                fontSize: 30,
                                fontFamily: "good",
                                fontWeight: FontWeight.w500),
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(9),
                                hintText: "Content",
                                hintStyle: TextStyle(
                                    color: Color(4278228470),
                                    fontSize: 30,
                                    fontFamily: "good"),
                                border: InputBorder.none),
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                          ),
                        ),
                      ],
                    )),
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 11),
                child: Text(
                  'Features',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 50,
                      fontWeight: FontWeight.w100,
                      fontFamily: 'good'),
                ),
              ),
              new ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                separatorBuilder: (ctx, i) => SizedBox(
                  height: 15,
                ),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  Widget widget = list.elementAt(index);
                  return widget;
                },
                itemCount: list.length,
              ),
              SizedBox(
                height: 20,
              )
            ]),
            SizedBox(height: 20),
            Hero(
              tag: "uplaod",
              child: Padding(
                padding: const EdgeInsets.only(left: 15, bottom: 20),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        PageRouteBuilder(
                          transitionDuration: Duration(milliseconds: 500),
                          pageBuilder: (_, __, ___) => Feed(),
                        ),
                        ModalRoute.withName('/'),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.only(top: 180),
                      child: Container(
                        width: 160,
                        height: 40,
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Color(4278228470),
                            ),
                            borderRadius: BorderRadius.circular(11)),
                        child: Align(
                          alignment: Alignment.center,
                          child: Material(
                            type: MaterialType.transparency,
                            child: Text(
                              "Uplaod Post",
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w400,
                                  color: Color(4278228470)),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        heroTag: "next",
        onPressed: () {
          list.add(
            new Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Expanded(
                child: Container(
                    height: 150,
                    width: 500,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Color(4279704112),
                    ),
                    child: Column(
                      children: [
                        TextFormField(
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.w500,
                              fontFamily: "good"),
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(10),
                              hintText: "Title",
                              hintStyle: TextStyle(
                                fontSize: 40,
                                color: Colors.white,
                                fontFamily: "good",
                                fontWeight: FontWeight.w500,
                              ),
                              border: InputBorder.none),
                        ),
                        Expanded(
                          child: TextFormField(
                            style: TextStyle(
                                color: Color(4278228470),
                                fontFamily: "good",
                                fontSize: 27,
                                fontWeight: FontWeight.bold),
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(5),
                                hintText: "Content",
                                hintStyle: TextStyle(
                                    color: Color(4278228470),
                                    fontSize: 30,
                                    fontFamily: "good"),
                                border: InputBorder.none),
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                          ),
                        ),
                      ],
                    )),
              ),
            ),
          );
          setState(() {});
        },
        child: new Icon(Icons.add),
      ),
    );
  }
}
