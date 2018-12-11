import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:smidigprosjekt/auth.dart';
import 'package:smidigprosjekt/utils/uidata.dart';
import 'package:smidigprosjekt/objects/user.dart';
import 'widgets/primary_button.dart';
import 'intro3.dart';

class IntroPageTwo extends StatefulWidget {
  IntroPageTwo({Key key, this.auth, this.onSignOut, this.user})
      : super(key: key);
  final BaseAuth auth;
  final VoidCallback onSignOut;
  final User user;

  @override
  IntroPageTwoState createState() => IntroPageTwoState();
}

class IntroPageTwoState extends State<IntroPageTwo> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: new Column(children: <Widget>[
          new Container(
            height: 300,
          ),
          new Padding(
            padding: EdgeInsets.all(16),
            child: new Text(
              "GJØR UTFORDRINGER MED GRUPPEN!",
              style: new TextStyle(
                fontSize: 24,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          new Padding(
            padding: EdgeInsets.fromLTRB(64, 32, 64, 32),
            child: new Text(
              "Gjennomfør utfordringene som blir gitt og få premier. Gå Til gruppesi- den for å følge med på hvor mange dere har fullført.",
              style: new TextStyle(
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          
        ]));
  }
}
