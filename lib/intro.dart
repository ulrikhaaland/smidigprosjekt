import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:smidigprosjekt/auth.dart';
import 'package:smidigprosjekt/objects/user.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_page_indicator/flutter_page_indicator.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smidigprosjekt/widgets/primary_button.dart';
import './service/service_provider.dart';
import './utils/uidata.dart';

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
  String skole;
  String linje;
  String bio;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> list = [
      introPage(
          "FÅ MED DEG HVA SOM SKJER I STUDENTBYEN!",
          "lib/assets/images/illustrasjon1.png",
          "Utforsk og bli med på arrangementer andre grupper har laget eller som er i regi av skolen.",
          1),
      introPage(
          "GJENNOMFØR UTFORDRINGER MED GRUPPEN",
          "lib/assets/images/illustrasjon2.png",
          "Gjennomfør utfordringer med gruppen din. Gå til gruppesiden for å se hva neste utfordring er, og følg med på \nhvor mange dere har fullført.",
          2),
      introPage(
          "BLI MED I EN KOLLOKVIE-GRUPPE!",
          "lib/assets/images/illustrasjon3.gif",
          "Velg egen gruppe ved å søke opp bruker-navn eller få tildelt en tilfeldig gruppe basert på studiet du går.",
          3),
      // userInfo(),
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
        padding: EdgeInsets.only(top: 68),
        child: new Stack(
          children: <Widget>[
            new Center(
              child: new Card(
                margin: EdgeInsets.only(
                  top: ServiceProvider.instance.screenService
                      .getPortraitHeightByPercentage(context, 10),
                ),
                color: Colors.grey[200],
                elevation: 2,
                child: new Container(
                  height: ServiceProvider.instance.screenService
                      .getPortraitHeightByPercentage(context, 66.6),
                  width: ServiceProvider.instance.screenService
                      .getPortraitWidthByPercentage(context, 91),
                  child: new Column(
                    children: <Widget>[
                      new Padding(
                        padding: EdgeInsets.only(top: 82),
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
                              labelStyle:
                                  new TextStyle(color: Colors.grey[600])),
                          onChanged: (val) => bio = val,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            new Align(
              alignment: Alignment.center,
              child: new CircleAvatar(
                radius: 70,
                backgroundColor: Colors.white,
                child: new Image.asset(
                  "lib/assets/images/profile.gif",
                ),
              ),
            ),
          ],
        ));
  }

  Widget introPage(String title, String imageLink, String textDesc, int pos) {
    Color one = UIData.grey;
    Color two = UIData.grey;
    Color three = UIData.grey;

    switch (pos) {
      case 1:
        one = UIData.pink;

        break;
      case 2:
        two = UIData.pink;
        break;
      case 3:
        three = UIData.pink;
    }
    return SingleChildScrollView(
        child: Column(children: <Widget>[
      Container(
        height: ServiceProvider.instance.screenService
            .getPortraitHeightByPercentage(context, 10),
      ),
      Container(
        height: ServiceProvider.instance.screenService
            .getPortraitHeightByPercentage(context, 30),
        child: Image.asset(
          imageLink,
        ),
      ),
      Padding(
        padding: EdgeInsets.only(left: 12, right: 12),
        child: Container(
          height: ServiceProvider.instance.screenService
              .getPortraitHeightByPercentage(context, 10),
          child: Text(
            title,
            style: TextStyle(fontSize: 24, fontFamily: 'ANTON'),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.only(
          left: 44,
          right: 44,
        ),
        child: Container(
          height: ServiceProvider.instance.screenService
              .getPortraitHeightByPercentage(context, 10),
          child: Text(
            textDesc,
            style: TextStyle(
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      Container(
          height: ServiceProvider.instance.screenService
              .getPortraitHeightByPercentage(context, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 8, right: 8),
                child: CircleAvatar(
                  radius: ServiceProvider.instance.screenService
                      .getPortraitHeightByPercentage(context, 2),
                  child: Text(
                    "1",
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: one,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 8, right: 8),
                child: CircleAvatar(
                  radius: ServiceProvider.instance.screenService
                      .getPortraitHeightByPercentage(context, 2),
                  child: Text(
                    "2",
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: two,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 8, right: 8),
                child: CircleAvatar(
                  radius: ServiceProvider.instance.screenService
                      .getPortraitHeightByPercentage(context, 2),
                  child: Text(
                    "3",
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: three,
                ),
              ),
            ],
          )),
      Container(
        height: ServiceProvider.instance.screenService
            .getPortraitHeightByPercentage(context, 1),
      ),
      PrimaryButton(
        text: "Kom i gang",
        padding: 52,
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
