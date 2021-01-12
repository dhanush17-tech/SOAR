import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class View extends StatefulWidget {
  String urlforweb;
  View(this.urlforweb);
  @override
  _ViewState createState() => _ViewState();
}

class _ViewState extends State<View> {
  InAppWebViewController webView;
  String url = "";
  double progress = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(children: <Widget>[
          Container(
            height: 60,
            color: Colors.blue[900],
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.close_rounded,
                      color: Colors.grey,
                      size: 30,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 40.0, right: 0, top: 25),
                  child: Text(
                    "${(url.length > 50) ? url.substring(0, 50) + "..." : url}",
                    style: GoogleFonts.robotoCondensed(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 0.0, right: 0, top: 56),
                  child: LinearPercentIndicator(
                    padding: EdgeInsets.all(0),
                    linearStrokeCap: LinearStrokeCap.butt,
                    alignment: MainAxisAlignment.center,
                    width: MediaQuery.of(context).size.width,
                    lineHeight: 4.0,
                    animation: true,
                    percent: progress,
                    animationDuration: 3250,
                    backgroundColor: Colors.grey,
                    progressColor: Colors.blue,
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Container(
              child: InAppWebView(
                initialUrl: widget.urlforweb,
                initialHeaders: {},
                initialOptions: InAppWebViewGroupOptions(
                    crossPlatform: InAppWebViewOptions(
                  debuggingEnabled: false,
                )),
                onWebViewCreated: (InAppWebViewController controller) {
                  webView = controller;
                },
                onLoadStart: (InAppWebViewController controller, String url) {
                  setState(() {
                    this.url = url;
                  });
                },
                onLoadStop:
                    (InAppWebViewController controller, String url) async {
                  setState(() {
                    this.url = url;
                  });
                },
                onProgressChanged:
                    (InAppWebViewController controller, int progress) {
                  setState(() {
                    this.progress = progress / 100;
                  });
                },
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
