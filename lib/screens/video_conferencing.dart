import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jitsi_meet/feature_flag/feature_flag.dart';
import 'package:jitsi_meet/jitsi_meet.dart';
import 'package:jitsi_meet/jitsi_meeting_listener.dart';
import 'package:jitsi_meet/room_name_constraint.dart';
import 'feed.dart';
import 'package:jitsi_meet/room_name_constraint_type.dart';

void main() => runApp(VideoCon());

class VideoCon extends StatefulWidget {
  @override
  _VideoConState createState() => _VideoConState();
}

class _VideoConState extends State<VideoCon> {
  String serverText = "";

  man() {
    Firestore.instance
        .collection("Users")
        .document(auth.currentUser.uid)
        .get()
        .then((value) {
      nameText.text = value["name"];
      emailText.text = auth.currentUser.email;
    });
  }

  final roomText = TextEditingController();
  GlobalKey<FormState> _man = GlobalKey<FormState>();
  String subjectText;
  final nameText = TextEditingController(text: "Plugin Test User");
  final emailText = TextEditingController();
  var isAudioOnly = true;
  var isAudioMuted = true;
  var isVideoMuted = true;

  @override
  void initState() {
    super.initState();
    man();
    JitsiMeet.addListener(JitsiMeetingListener(
        onConferenceWillJoin: _onConferenceWillJoin,
        onConferenceJoined: _onConferenceJoined,
        onConferenceTerminated: _onConferenceTerminated,
        onPictureInPictureWillEnter: _onPictureInPictureWillEnter,
        onPictureInPictureTerminated: _onPictureInPictureTerminated,
        onError: _onError));
  }

  @override
  void dispose() {
    super.dispose();
    JitsiMeet.removeAllListeners();
  }

  @override
  Widget build(BuildContext context) { SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);

    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Color(4278857608), Color(4278256230)],
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft),
                ),
              ),
              Hero(
                tag: "hf",
                child: Padding(
                  padding: EdgeInsets.only(top: 100),
                  child: Opacity(
                      opacity: 0.4, child: Image.asset('assets/soar.png')),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 35, left: 10),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                      padding: EdgeInsets.all(3),
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(4278228470),
                      ),
                      child: Icon(Icons.arrow_back_rounded,
                          color: Color(4278190106))),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 100),
                child: Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Start or  \n join a call',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 35,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    SizedBox(height: 40),
                    Opacity(
                      opacity: 0.7,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          height: 55,
                          width: 350,
                          child: Material(
                            elevation: 20,
                            child: Form(
                              key: _man,
                              child: TextFormField(
                                style: TextStyle(
                                    fontFamily: "good",
                                    fontSize: 30,
                                    letterSpacing: 0.6,
                                    color: Color(4278228470)),
                                controller: roomText,
                                validator: (cal) => cal.length < 3
                                    ? "The meeting code should be more that 3 letters"
                                    : null,
                                textAlign: TextAlign.left,
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  hintText: "Enter your invite code",
                                  hintStyle: GoogleFonts.poppins(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500),
                                  filled: true,
                                  contentPadding: EdgeInsets.all(10),
                                  border: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 50),
                    GestureDetector(
                      onTap: () {
                        if (_man.currentState.validate()) {
                          setState(() {
                            _joinMeeting();
                          });
                        }
                      },
                      child: Material(
                        elevation: 10,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color(4278260287),
                          ),
                          height: 55,
                          width: 350,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 0),
                            child: Text(
                              'Join Meeting',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: "good",
                                  color: Color(4278228470),
                                  fontSize: 50,
                                  fontWeight: FontWeight.w300),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 60,
                    ),
                    CheckboxListTile(
                      title: Text(
                        "Audio Only",
                        style: TextStyle(
                            color: Color(4278228470),
                            fontFamily: "good",
                            fontSize: 30),
                      ),
                      value: isAudioOnly,
                      onChanged: _onAudioOnlyChanged,
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    CheckboxListTile(
                      title: Text(
                        "Audio Muted",
                        style: TextStyle(
                            color: Color(4278228470),
                            fontFamily: "good",
                            fontSize: 30),
                      ),
                      value: isAudioMuted,
                      onChanged: _onAudioMutedChanged,
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    CheckboxListTile(
                      title: Text(
                        "Video Muted",
                        style: TextStyle(
                            color: Color(4278228470),
                            fontFamily: "good",
                            fontSize: 30),
                      ),
                      value: isVideoMuted,
                      onChanged: _onVideoMutedChanged,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _onAudioOnlyChanged(bool value) {
    setState(() {
      isAudioOnly = value;
    });
  }

  _onAudioMutedChanged(bool value) {
    setState(() {
      isAudioMuted = value;
    });
  }

  _onVideoMutedChanged(bool value) {
    setState(() {
      isVideoMuted = value;
    });
  }

  _joinMeeting() async {
    String serverUrl = serverText?.trim()?.isEmpty ?? "" ? null : serverText;

    try {
      // Enable or disable any feature flag here
      // If feature flag are not provided, default values will be used
      // Full list of feature flags (and defaults) available in the README
      FeatureFlag featureFlag = FeatureFlag();
      featureFlag.welcomePageEnabled = false;
      // Here is an example, disabling features for each platform
      if (Platform.isAndroid) {
        // Disable ConnectionService usage on Android to avoid issues (see README)
        featureFlag.callIntegrationEnabled = false;
      } else if (Platform.isIOS) {
        // Disable PIP on iOS as it looks weird
        featureFlag.pipEnabled = false;
      }

      //uncomment to modify video resolution
      //featureFlag.resolution = FeatureFlagVideoResolution.MD_RESOLUTION;

      // Define meetings options here
      var options = JitsiMeetingOptions()
        ..room = roomText.text
        ..serverURL = serverUrl
        ..subject = subjectText
        ..userDisplayName = nameText.text
        ..userEmail = emailText.text
        ..audioOnly = isAudioOnly
        ..audioMuted = isAudioMuted
        ..videoMuted = isVideoMuted
        ..featureFlag = featureFlag;

      debugPrint("JitsiMeetingOptions: $options");
      await JitsiMeet.joinMeeting(
        options,
        listener: JitsiMeetingListener(onConferenceWillJoin: ({message}) {
          debugPrint("${options.room} will join with message: $message");
        }, onConferenceJoined: ({message}) {
          debugPrint("${options.room} joined with message: $message");
        }, onConferenceTerminated: ({message}) {
          debugPrint("${options.room} terminated with message: $message");
        }, onPictureInPictureWillEnter: ({message}) {
          debugPrint("${options.room} entered PIP mode with message: $message");
        }, onPictureInPictureTerminated: ({message}) {
          debugPrint("${options.room} exited PIP mode with message: $message");
        }),
        // by default, plugin default constraints are used
        //roomNameConstraints: new Map(), // to disable all constraints
        //roomNameConstraints: customContraints, // to use your own constraint(s)
      );
    } catch (error) {
      debugPrint("error: $error");
    }
  }

  static final Map<RoomNameConstraintType, RoomNameConstraint>
      customContraints = {
    RoomNameConstraintType.MAX_LENGTH: new RoomNameConstraint((value) {
      return value.trim().length <= 50;
    }, "Maximum room name length should be 30."),
    RoomNameConstraintType.FORBIDDEN_CHARS: new RoomNameConstraint((value) {
      return RegExp(r"[$€£]+", caseSensitive: false, multiLine: false)
              .hasMatch(value) ==
          false;
    }, "Currencies characters aren't allowed in room names."),
  };

  void _onConferenceWillJoin({message}) {
    debugPrint("_onConferenceWillJoin broadcasted with message: $message");
  }

  void _onConferenceJoined({message}) {
    debugPrint("_onConferenceJoined broadcasted with message: $message");
  }

  void _onConferenceTerminated({message}) {
    debugPrint("_onConferenceTerminated broadcasted with message: $message");
  }

  void _onPictureInPictureWillEnter({message}) {
    debugPrint(
        "_onPictureInPictureWillEnter broadcasted with message: $message");
  }

  void _onPictureInPictureTerminated({message}) {
    debugPrint(
        "_onPictureInPictureTerminated broadcasted with message: $message");
  }

  _onError(error) {
    debugPrint("_onError broadcasted: $error");
  }
}
