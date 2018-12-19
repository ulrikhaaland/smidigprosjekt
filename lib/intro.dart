import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:smidigprosjekt/auth.dart';
import 'package:smidigprosjekt/objects/user.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_page_indicator/flutter_page_indicator.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class Intro extends StatefulWidget {
  Intro({Key key, this.auth, this.onSignOut, this.user, this.onIntroFinished})
      : super(key: key);
  final BaseAuth auth;
  final VoidCallback onSignOut;
  final VoidCallback onIntroFinished;
  final User user;

  @override
  IntroState createState() => IntroState();
}

class IntroState extends State<Intro> {
  MediaQueryData queryData;

  String skole;
  String linje;
  String bio;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    queryData = MediaQuery.of(context);

    List<Widget> list = [
      userInfo(),
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

  Widget userInfo() {
    return new SingleChildScrollView(
        child:
            // new Container(
            //   height: queryData.size.height / 10,
            // ),
            new Stack(
      children: <Widget>[
        new Image.asset(
          "lib/assets/images/profile.gif",
        ),
        new Center(
          child: new Card(
            margin: EdgeInsets.only(
              top: queryData.size.height / 2.5,
            ),
            color: Colors.grey[200],
            elevation: 2,
            child: new Container(
              height: queryData.size.height / 2,
              width: queryData.size.width / 1.1,
              child: new Column(
                children: <Widget>[
                  new Padding(
                    padding: EdgeInsets.only(top: 12),
                  ),
                  new Text(
                    widget.user.userName,
                    style: new TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  new ListTile(
                    leading: new Text(
                      "Skole:",
                      style: new TextStyle(),
                    ),
                    title: new TextField(
                      textCapitalization: TextCapitalization.sentences,
                      autocorrect: false,
                      onChanged: (val) => skole = val,
                    ),
                  ),
                  new ListTile(
                    leading: new Text("Linje:"),
                    title: new TextField(
                      autocorrect: false,
                      textCapitalization: TextCapitalization.sentences,
                      onChanged: (val) => linje = val,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 36),
                  ),
                  new ListTile(
                    leading: Text("Bio:"),
                    title: new TextField(
                      textCapitalization: TextCapitalization.sentences,
                      maxLines: 5,
                      style: new TextStyle(
                        color: Colors.black,
                      ),
                      key: new Key('bio'),
                      decoration: new InputDecoration(
                          hintText: "Skriv noe om deg selv!",
                          border: OutlineInputBorder(),
                          fillColor: Colors.black,
                          labelStyle: new TextStyle(color: Colors.grey[600])),
                      onChanged: (val) => bio = val,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ));
  }

  Widget introPageOne() {
    return new SingleChildScrollView(
        child: Column(children: <Widget>[
      new Container(
        height: queryData.size.height / 10,
      ),
      new Image.asset(
        "lib/assets/images/illustrasjon1.gif",
      ),
      new Padding(
        padding: EdgeInsets.all(12),
        child: new Text(
          "FÅ MED DEG HVA SOM SKJER I STUDENTBYEN!",
          style: new TextStyle(fontSize: 24, fontFamily: 'ANTON'),
          textAlign: TextAlign.center,
        ),
      ),
      new Padding(
        padding: EdgeInsets.fromLTRB(44, 16, 44, 32),
        child: new Text(
          "Utforsk og bli med på arrangementer andre grupper har laget eller som er i regi av skolen.",
          style: new TextStyle(
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    ]));
  }

  Widget introPageTwo() {
    return new SingleChildScrollView(
        child: Column(children: <Widget>[
      new Container(
        height: queryData.size.height / 10,
      ),
      new Image.asset(
        "lib/assets/images/illustrasjon2.gif",
      ),
      new Padding(
        padding: EdgeInsets.all(16),
        child: new Text(
          "GJENNOMFØR UTFORDRINGER MED GRUPPEN",
          style: new TextStyle(fontSize: 24, fontFamily: 'Anton'),
          textAlign: TextAlign.center,
        ),
      ),
      new Padding(
        padding: EdgeInsets.fromLTRB(44, 16, 44, 32),
        child: new Text(
          "Gjennomfør utfordringer med gruppen din. Gå til gruppesiden for å se hva neste utfordring er, og følg med på \nhvor mange dere har fullført.",
          style: new TextStyle(
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    ]));
  }

  Widget introPageThree() {
    return new SingleChildScrollView(
        child: Column(children: <Widget>[
      new Container(
        height: queryData.size.height / 10,
      ),
      new Image.asset(
        "lib/assets/images/illustrasjon3.gif",
      ),
      new Padding(
        padding: EdgeInsets.all(16),
        child: new Text(
          "BLI MED I EN KOLLOKVIE-GRUPPE!",
          style: new TextStyle(fontSize: 24, fontFamily: 'Anton'),
          textAlign: TextAlign.center,
        ),
      ),
      new Padding(
        padding: EdgeInsets.fromLTRB(44, 17, 44, 32),
        child: new Text(
          "Velg egen gruppe ved å søke opp bruker-navn eller få tildelt en tilfeldig gruppe basert på studiet du går.",
          style: new TextStyle(
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      new RaisedButton(
        color: Colors.black,
        child:
            new Text("Kom i gang", style: new TextStyle(color: Colors.white)),
        onPressed: () => saveData(),
      )
    ]));
  }

  saveData() async {
    widget.user.skole = skole;
    widget.user.linje = linje;
    widget.user.bio = bio;
    widget.user.intro = false;
    await Firestore.instance
        .document("users/${widget.user.id}")
        .updateData(widget.user.toJson());
    widget.onIntroFinished();
  }
}
