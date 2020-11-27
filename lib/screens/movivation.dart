import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:better_player/better_player.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Movivation extends StatefulWidget {
  @override
  _MovivationState createState() => _MovivationState();
}

class _MovivationState extends State<Movivation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(4278190106),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: "motivational",
                child: Material(
                  type: MaterialType.transparency,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 30, left: 20),
                    child: Text(
                      'Quick Tips',
                      style: GoogleFonts.poppins(
                          color: Color(4278228470),
                          fontSize: 40,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                  child: StreamBuilder(
                      stream:
                          Firestore.instance.collection("videos").snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) return Text('Loading... data');
                        return ListView.separated(
                            separatorBuilder: (ctx, i) => SizedBox(height: 20),
                            shrinkWrap: true,
                            itemCount: snapshot.data.documents.length,
                            itemBuilder: (ctx, i) {
                              DocumentSnapshot course =
                                  snapshot.data.documents[i];

                              return Align(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 8, right: 8),
                                  child: Container(
                                    height: 186.5,
                                    width: 331.5,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Color(4278190106),
                                    ),
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          child: AspectRatio(
                                            aspectRatio: 16 / 9,
                                            child: BetterPlayer.network(
                                              "https://commondatastorage.googleapis.com/gtv-videos-bucket/CastVideos/mp4/BigBuckBunny.mp4",
                                              betterPlayerConfiguration:
                                                  BetterPlayerConfiguration(
                                                aspectRatio: 16 / 10,
                                                fit: BoxFit.contain,
                                                controlsConfiguration:
                                                    BetterPlayerControlsConfiguration(
                                                        enableSkips: false,
                                                        enableFullscreen: false,
                                                        enableMute: false,
                                                        enableOverflowMenu:
                                                            false,
                                                        enablePlayPause: false,
                                                        enableProgressBar:
                                                            false,
                                                        showControlsOnInitialize:
                                                            false),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Container(
                                            height: 55,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  topRight:
                                                      Radius.circular(10)),
                                              color: Color(4278190106)
                                                  .withOpacity(0.8),
                                            ),
                                            child: Align(
                                              alignment: Alignment.bottomLeft,
                                              child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 2, left: 10),
                                                  child: Text(
                                                    course["title"],
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 20,
                                                      height: 1.0,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.white,
                                                    ),
                                                  )),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            });
                      }))
            ],
          ),
        ],
      ),
    );
  }
}
