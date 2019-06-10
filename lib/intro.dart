import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:smidigprosjekt/auth.dart';
import 'package:smidigprosjekt/objects/group.dart';
import 'package:smidigprosjekt/objects/user.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_page_indicator/flutter_page_indicator.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smidigprosjekt/widgets/primary_button.dart';
import './service/service_provider.dart';
import './utils/uidata.dart';
import 'service/styles.dart';

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
  var _formKey = GlobalKey<FormState>();

  String skole;
  String linje;
  String bio;

  bool swipes = true;
  bool userinfo = false;

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
    Widget content;

    if (userinfo) {
      content = Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Container(
              height: ServiceProvider.instance.screenService
                  .getHeightByPercentage(context, 15),
            ),
            Stack(
              alignment: Alignment.topCenter,
              children: <Widget>[
                Card(
                  margin: EdgeInsets.only(
                    top: ServiceProvider.instance.screenService
                        .getHeightByPercentage(context, 6.25),
                  ),
                  color: Colors.white,
                  elevation: 2,
                  child: Container(
                    height: ServiceProvider.instance.screenService
                        .getHeightByPercentage(context, 66),
                    width: ServiceProvider.instance.screenService
                        .getWidthByPercentage(context, 90),
                    child: Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            icon: Icon(
                              Icons.edit,
                              color: Colors.transparent,
                            ),
                            onPressed: null,
                          ),
                        ),
                        Container(
                          height: ServiceProvider.instance.screenService
                              .getHeightByPercentage(context, 7.5),
                        ),
                        Text(
                          widget.user.userName,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ListTile(
                            title: TextFormField(
                          textCapitalization: TextCapitalization.words,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              labelText: "Skole",
                              labelStyle: Styles().textLight()),
                          onSaved: (val) => widget.user.school = val.trim(),
                          validator: (val) =>
                              val.isEmpty ? "Feltet må fylles ut" : null,
                        )),
                        ListTile(
                            title: TextFormField(
                          textCapitalization: TextCapitalization.words,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              labelText: "Linje",
                              labelStyle: Styles().textLight()),
                          onSaved: (val) => widget.user.program = val.trim(),
                          validator: (val) =>
                              val.isEmpty ? "Feltet må fylles ut" : null,
                        )),
                        ListTile(
                            title: TextFormField(
                          textCapitalization: TextCapitalization.sentences,
                          keyboardType: TextInputType.text,
                          maxLines: 3,
                          decoration: InputDecoration(
                              labelText: "Bio",
                              labelStyle: Styles().textLight()),
                          onSaved: (val) => val != null
                              ? widget.user.bio = val.trim()
                              : widget.user.bio == "",
                        )),
                        Container(
                          height: ServiceProvider.instance.screenService
                              .getHeightByPercentage(context, 5),
                          child: Center(
                            child: Text(
                              "Vennligst fyll ut feltene så vi lettere kan finne en gruppe til deg.",
                              style: Styles().textLight(),
                            ),
                          ),
                        ),
                        PrimaryButton(
                          text: "Gå videre",
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              saveData(true);

                              setState(() {
                                userinfo = !userinfo;
                              });
                            }
                          },
                        )
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: GestureDetector(
                    onTap: null,
                    child: CircleAvatar(
                      radius: ServiceProvider.instance.screenService
                          .getHeightByPercentage(context, 8.5),
                      backgroundColor: UIData.pink,
                      child: CircleAvatar(
                        radius: ServiceProvider.instance.screenService
                            .getHeightByPercentage(context, 8.25),
                        backgroundColor: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.add_a_photo,
                              size: 40,
                              color: UIData.black,
                            ),
                            Container(
                              height: ServiceProvider.instance.screenService
                                  .getHeightByPercentage(context, 1),
                            ),
                            Text(
                              "Legg til et bilde",
                              style: Styles().textLight(),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      swipes == true
          ? content = Swiper(
              loop: false,
              itemBuilder: (BuildContext context, int index) {
                return list[index];
              },
              indicatorLayout: PageIndicatorLayout.COLOR,
              itemCount: list.length,
              pagination: SwiperPagination(
                  builder: DotSwiperPaginationBuilder(space: 10)),
              // control: new SwiperControl(),
            )
          : content = Column(
              children: <Widget>[
                Container(
                  height: ServiceProvider.instance.screenService
                      .getHeightByPercentage(context, 15),
                ),
                Container(
                  height: ServiceProvider.instance.screenService
                      .getHeightByPercentage(context, 7.5),
                  child: Text(
                    "Du har 3 valgmuligheter:",
                    style: Styles().title(),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 24),
                  child: GestureDetector(
                    onTap: () => _groupDecision(1),
                    child: Card(
                      color: UIData.pink,
                      child: Container(
                        width: ServiceProvider.instance.screenService
                            .getWidthByPercentage(context, 85),
                        height: ServiceProvider.instance.screenService
                            .getHeightByPercentage(context, 15),
                        child: Center(
                          child: Text("Bli tildelt en gruppe automatisk",
                              style: Styles().textLight()),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 24),
                  child: GestureDetector(
                    onTap: () => _groupDecision(2),
                    child: Card(
                      color: UIData.blue,
                      child: Container(
                        width: ServiceProvider.instance.screenService
                            .getWidthByPercentage(context, 85),
                        height: ServiceProvider.instance.screenService
                            .getHeightByPercentage(context, 15),
                        child: Center(
                          child: Text("Søk etter en gruppe",
                              style: Styles().textLight()),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 24),
                  child: GestureDetector(
                    onTap: () => _groupDecision(3),
                    child: Card(
                      color: UIData.darkblue,
                      child: Container(
                        width: ServiceProvider.instance.screenService
                            .getWidthByPercentage(context, 85),
                        height: ServiceProvider.instance.screenService
                            .getHeightByPercentage(context, 15),
                        child: Center(
                          child: Text("Opprett din egen gruppe",
                              style: Styles().textLight()),
                        ),
                      ),
                    ),
                  ),
                ),
                Text(
                  "Du kan når som helst endre valget ditt",
                  style: Styles().textLight(),
                ),
              ],
            );
    }

    return Scaffold(
        backgroundColor: userinfo ? UIData.grey : Colors.white, body: content);
  }

  void _groupDecision(int decision) {
    switch (decision) {
      case 1:
        _assignToGroup();
        break;
      case 2:
        widget.onIntroFinished();
        break;
      case 3:
        _createGroup();
        break;

      default:
    }
  }

  void _createGroup() async {
    DocumentReference ref = await Firestore.instance.collection("groups").add({
      "name": "Min gruppe",
      "memberamount": 1,
      "school": widget.user.school.toLowerCase(),
      "program": widget.user.program.toLowerCase()
    });
    widget.user.groupId = ref.documentID;
    await ref.collection("members").add(widget.user.toJson());
    saveData(false);
    widget.onIntroFinished();
  }

  void _assignToGroup() async {
    DocumentReference grpIdRef;
    QuerySnapshot qSnapLinje = await Firestore.instance
        .collection("groups")
        .where("program", isEqualTo: widget.user.program.toLowerCase())
        .getDocuments();
    if (qSnapLinje.documents.isEmpty) {
      QuerySnapshot qSnapSkole = await Firestore.instance
          .collection("groups")
          .where("school", isEqualTo: widget.user.school.toLowerCase())
          .getDocuments();
      if (qSnapSkole.documents.isEmpty) {
        QuerySnapshot qSnap = await Firestore.instance
            .collection("groups")
            .where("members", isLessThan: 2)
            .getDocuments();
        if (qSnap.documents.isEmpty) {
          _createGroup();
        } else {
          String docId = "";
          int size;
          qSnap.documents.forEach((doc) {
            if (size == null) {
              size = doc.data["memberamount"];
              docId = doc.documentID;
            } else if (doc.data["memberamount"] < size) {
              docId = doc.documentID;
            }
          });
          grpIdRef = await Firestore.instance
              .collection("groups/$docId/members")
              .add(widget.user.toJson());

          widget.user.groupId = docId;

          saveData(false);

          widget.onIntroFinished();
        }
      } else {
        String docId = "";
        int size;
        qSnapSkole.documents.forEach((doc) {
          if (size == null) {
            size = doc.data["memberamount"];
            docId = doc.documentID;
          } else if (doc.data["memberamount"] < size) {
            docId = doc.documentID;
          }
        });

        grpIdRef = await Firestore.instance
            .collection("groups/$docId/members")
            .add(widget.user.toJson());

        widget.user.groupId = docId;

        saveData(false);

        widget.onIntroFinished();
      }
    } else {
      String docId = "";
      int size;
      qSnapLinje.documents.forEach((doc) {
        if (size == null) {
          size = doc.data["memberamount"];
          docId = doc.documentID;
        } else if (doc.data["memberamount"] < size) {
          docId = doc.documentID;
        }
      });
      if (size < 5) {
        grpIdRef = await Firestore.instance
            .collection("groups/$docId/members")
            .add(widget.user.toJson());

        widget.user.groupId = docId;

        saveData(false);

        widget.onIntroFinished();
      } else {
        _createGroup();
      }
    }
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
            .getHeightByPercentage(context, 15),
      ),
      Container(
        height: ServiceProvider.instance.screenService
            .getHeightByPercentage(context, 35),
        child: Image.asset(
          imageLink,
        ),
      ),
      Padding(
        padding: EdgeInsets.only(left: 12, right: 12),
        child: Container(
          height: ServiceProvider.instance.screenService
              .getHeightByPercentage(context, 10),
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
              .getHeightByPercentage(context, 10),
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
              .getHeightByPercentage(context, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 8, right: 8),
                child: CircleAvatar(
                  radius: ServiceProvider.instance.screenService
                      .getHeightByPercentage(context, 2),
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
                      .getHeightByPercentage(context, 2),
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
                      .getHeightByPercentage(context, 2),
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
            .getHeightByPercentage(context, 1),
      ),
      PrimaryButton(
        text: "Kom i gang",
        padding: 52,
        onPressed: () {
          setState(() {
            userinfo = true;
            swipes = false;
          });
        },
      )
    ]));
  }

  saveData(bool fromForm) async {
    if (fromForm) {
      // widget.user.intro = false;

      _formKey.currentState.save();
    }

    Firestore.instance
        .document("users/${widget.user.id}")
        .updateData(widget.user.toJson());
  }
}
