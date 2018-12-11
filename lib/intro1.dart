import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:smidigprosjekt/auth.dart';
import 'package:smidigprosjekt/utils/uidata.dart';
import 'package:smidigprosjekt/objects/user.dart';
import 'intro2.dart';
import 'intro3.dart';
import 'widgets/primary_button.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_page_indicator/flutter_page_indicator.dart';

class IntroPageOne extends StatefulWidget {
  IntroPageOne({Key key, this.auth, this.onSignOut, this.user})
      : super(key: key);
  final BaseAuth auth;
  final VoidCallback onSignOut;
  final User user;

  @override
  IntroPageOneState createState() => IntroPageOneState();
}

class IntroPageOneState extends State<IntroPageOne> {
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
              "FÅ MED DEG HVA SOM SKJER I STUDENTBYEN!",
              style: new TextStyle(
                fontSize: 24,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          new Padding(
            padding: EdgeInsets.fromLTRB(64, 32, 64, 32),
            child: new Text(
              "Utforsk og bli med på arran- gementer andre grupper har laget eller som er i regi av skolen.",
              style: new TextStyle(
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ]));
  }
}
