import 'package:SOAR/screens/feed.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(AssistMain());

class AssistMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Assist(),
    );
  }
}

class Assist extends StatefulWidget {
  Assist({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _Assist createState() => new _Assist();
}

class _Assist extends State<Assist> {
  final List<ChatMessage> _messages = <ChatMessage>[];
  final TextEditingController _textController = new TextEditingController();

  Widget _buildTextComposer() {
    return new IconTheme(
        data: new IconThemeData(color: Theme.of(context).accentColor),
        child: new Align(
          alignment: Alignment.bottomLeft,
          child: Container(
            height: 80,
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
                color: Colors.white),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Form(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Container(
                        width: 280,
                        child: TextFormField(
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          controller: _textController,
                          validator: (val) => val.length == 0 ? "" : null,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Type your message here",
                              hintStyle: GoogleFonts.poppins(
                                  fontSize: 17, fontWeight: FontWeight.w500)),
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  child: Padding(
                    padding: const EdgeInsets.all(
                      10,
                    ),
                    child: FittedBox(
                      child: GestureDetector(
                        onTap: () => _handleSubmitted(_textController.text),
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
                ),
              ],
            ),
          ),
        ));
  }

  void Response(query) async {
    _textController.clear();
    AuthGoogle authGoogle =
        await AuthGoogle(fileJson: "assets/credentials.json").build();
    Dialogflow dialogflow =
        Dialogflow(authGoogle: authGoogle, language: Language.english);
    AIResponse response = await dialogflow.detectIntent(query);
    Widget message = new ChatMessage(
      text: response.getMessage() ??
          new CardDialogflow(response.getListMessage()[0]).title,
      name: "Bot",
      byme: false,
    );
    setState(() {
      _messages.insert(0, message);
    });
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    ChatMessage message = new ChatMessage(
      text: text,
      name: "You",
      byme: true,
    );
    setState(() {
      _messages.insert(0, message);
    });
    Response(text);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Color(4278190106),
        centerTitle: true,
        title: new Text("Customer Support"),
        actions: [
          IconButton(
              icon: Icon(
                Icons.help_outline,
                color: Colors.white,
              ),
              onPressed: () => {
                    showDialog(
                        context: context,
                        builder: (_) => NetworkGiffyDialog(
                              image: Image.asset(
                                'assets/tenor.gif',
                                fit: BoxFit.cover,
                              ),
                              title: Text(
                                "Hi, I'm a Bot!",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              description: Text(
                                "All the replies you get here are automated by an AI. Please contact us at contact@soarthrow.com for further assistance",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(),
                              ),
                            ))
                  })
        ],
      ),
      body: Container(
                color: Color(4278190106),

        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Align(
          alignment: Alignment.bottomRight,
          child: Stack(
            children: [
              SingleChildScrollView(
                reverse: true,
                scrollDirection: Axis.vertical,
                child: new Column(children: <Widget>[
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.blue[800]),
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Bot",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            Text(
                              "Hi, how may I help you ? ",
                              style: TextStyle(color: Color(4278228470)),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  new ListView.separated(
                    separatorBuilder: (ctx,i)=>SizedBox(height: 0,),
                    physics: NeverScrollableScrollPhysics(),
                    padding: new EdgeInsets.all(8.0),
                    reverse: true,
                    shrinkWrap: true,
                    itemBuilder: (_, int index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 50),
                        child: Column(
                          children: [_messages[index], ],
                        ),
                      );
                    },
                    itemCount: _messages.length,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ]),
              ),
              new Divider(height: 1.0),
              Align(
                alignment: Alignment.bottomCenter,
                child: new Container(
                  height: 80,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                      color: Colors.white),
                  child: _buildTextComposer(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  ChatMessage({this.text, this.name, this.byme});

  final String text;
  final String name;
  final bool byme;

  List<Widget> otherMessage(context) {
    return <Widget>[
      new Container(
        margin: const EdgeInsets.only(right: 16.0),
        child: new CircleAvatar(child: Icon(Icons.person)),
      ),
      new Expanded(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Text(this.name,
                style: new TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.white)),
            new Container(
              margin: const EdgeInsets.only(top: 5.0),
              child: new Text(
                text,
                style: GoogleFonts.poppins(color: Color(4278228470)),
              ),
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> myMessage(context) {
    return <Widget>[
      new Expanded(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            SizedBox(
              height: 8,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue,
                  ),
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
constraints: BoxConstraints(maxWidth: 150),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(this.name, style: TextStyle(color: Colors.white)),
                      Text(
                        text,
                        style: GoogleFonts.poppins(color: Color(4278228470)),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      new Container(
        margin: const EdgeInsets.only(left: 16.0),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: this.byme ? myMessage(context) : otherMessage(context),
      ),
    );
  }
}
