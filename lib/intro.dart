import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:smidigprosjekt/auth.dart';
import 'package:smidigprosjekt/utils/uidata.dart';
import 'package:smidigprosjekt/objects/user.dart';
import 'intro2.dart';
import 'intro1.dart';
import 'intro3.dart';
import 'widgets/primary_button.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_page_indicator/flutter_page_indicator.dart';

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
      IntroPageOne(),
      IntroPageTwo(),
      IntroPageThree(),
    ];
    return Scaffold(
        backgroundColor: Colors.white,
        body: new Swiper(
          itemBuilder: (BuildContext context, int index) {
            return list[index];
          },
          indicatorLayout: PageIndicatorLayout.COLOR,
          itemCount: list.length,
          pagination: new SwiperPagination(
              builder: DotSwiperPaginationBuilder(space: 10)),
          // control: new SwiperControl(),
        ));
    // new Column(children: <Widget>[
    //   new Container(
    //     height: 300,
    //   ),
    //   new Padding(
    //     padding: EdgeInsets.all(16),
    //     child: new Text(
    //       "FÅ MED DEG HVA SOM SKJER I STUDENTBYEN!",
    //       style: new TextStyle(
    //         fontSize: 24,
    //       ),
    //       textAlign: TextAlign.center,
    //     ),
    //   ),
    //   new Padding(
    //     padding: EdgeInsets.fromLTRB(64, 32, 64, 32),
    //     child: new Text(
    //       "Utforsk og bli med på arran- gementer andre grupper har laget eller som er i regi av skolen.",
    //       style: new TextStyle(
    //         fontSize: 16,
    //       ),
    //       textAlign: TextAlign.center,
    //     ),
    //   ),
    //   new PrimaryButton(
    //     key: new Key("one"),
    //     text: "Neste",
    //     color: Colors.lightBlueAccent,
    //     padding: 84,
    //     onPressed: () => Navigator.push(
    //         context,
    //         MaterialPageRoute(
    //             builder: (BuildContext context) => IntroPageTwo(
    //                   user: widget.user,
    //                 ))),
    //   ),
    // ]));
  }
}
