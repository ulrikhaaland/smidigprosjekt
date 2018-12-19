import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:smidigprosjekt/auth.dart';
import 'package:smidigprosjekt/objects/user.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_page_indicator/flutter_page_indicator.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class Intro extends StatefulWidget {
  Intro({Key key, this.auth, this.onSignOut, this.user}) : super(key: key);
  final BaseAuth auth;
  final VoidCallback onSignOut;
  final User user;

  @override
  IntroState createState() => IntroState();
}

class IntroState extends State<Intro> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> list = [
      introPageOne(),
      introPageTwo(),
      introPageThree(),
    ];
    return Scaffold(
        backgroundColor: Colors.white,
        body: new Swiper(
          loop: false,
          itemBuilder: (BuildContext context, int index) {
            return list[index];
          },
          indicatorLayout: PageIndicatorLayout.COLOR,
          itemCount: list.length,
          pagination: new SwiperPagination(
              builder: DotSwiperPaginationBuilder(space: 10)),
          // control: new SwiperControl(),
        ));
  }
}

Widget introPageOne() {
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

Widget introPageTwo() {
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

Widget introPageThree() {
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
            style:
                new TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
      ]));
}

Widget webView() {
  return new MaterialApp(
    routes: {
      "/": (_) => new WebviewScaffold(
            url: "https://www.google.com",
            appBar: new AppBar(
              title: new Text("Widget webview"),
            ),
          ),
    },
  );
}
