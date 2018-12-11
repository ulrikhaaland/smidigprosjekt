import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:smidigprosjekt/auth.dart';
import 'package:smidigprosjekt/utils/uidata.dart';
import 'package:smidigprosjekt/objects/user.dart';

class IntroPageThree extends StatefulWidget {
  IntroPageThree({Key key, this.auth, this.onSignOut, this.user}) : super(key: key);
  final BaseAuth auth;
  final VoidCallback onSignOut;
  final User user;

  @override
  IntroPageThreeState createState() => IntroPageThreeState();
}

class IntroPageThreeState extends State<IntroPageThree> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: new Column(children: <Widget>[
          new GestureDetector(
            onTap: null,
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 64, 16, 16),
              child: new Container(
                height: 100,
                color: Colors.lightBlueAccent,
                child: Align(
                  alignment: Alignment.center,
                  child: new Padding(
                    padding: EdgeInsets.all(32),
                    child: new Text(
                      "Jeg ønsker å få tildelt en kollokviegruppe basert på hvilket studie jeg går.",
                      style: new TextStyle(fontSize: 14, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          ),
          new GestureDetector(
            onTap: null,
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 64, 16, 16),
              child: new Container(
                height: 100,
                color: Colors.pinkAccent,
                child: Align(
                  alignment: Alignment.center,
                  child: new Padding(
                    padding: EdgeInsets.all(32),
                    child: new Text(
                      "Jeg ønsker å sette sammen en gruppe selv, ved å søke opp brukere.",
                      style: new TextStyle(fontSize: 14, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          ),
          new GestureDetector(
            onTap: null,
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 64, 16, 16),
              child: new Container(
                height: 100,
                color: Colors.purple,
                child: Align(
                  alignment: Alignment.center,
                  child: new Padding(
                    padding: EdgeInsets.all(32),
                    child: new Text(
                      "Jeg ønsker ikke å bli med i en kollokviegruppe og vil bare se på/delta på offentlige arrangementer.",
                      style: new TextStyle(fontSize: 14, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16, 32, 16, 16),
            child: new Text(
              "Du kan når som helst endre valget ditt.",
              style: new TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
        ]));
  }
}
