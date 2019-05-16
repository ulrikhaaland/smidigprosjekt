import 'dart:async';

import 'package:flutter/material.dart';
import 'uidata.dart';

class Essentials extends StatefulWidget {
  Essentials({
    this.circularLoad,
    this.imageLoad,
  });
  final bool imageLoad;
  final bool circularLoad;
  @override
  EssentialsState createState() => new EssentialsState();
}

bool _visibleWelcome = true;

class EssentialsState extends State<Essentials> {
  @override
  void initState() {
    super.initState();
    if (widget.imageLoad) {
      _showWelcome();
    }
  }

  void _showWelcome() {
    Timer(
        Duration(seconds: 1),
        () => setState(() {
              _visibleWelcome = !_visibleWelcome;
            }));
  }

  Widget loading(bool isLoading) {
    if (isLoading == true) {
      return new Center(
        child: new CircularProgressIndicator(),
      );
    } else {
      return new Container();
    }
  }

  Widget setScreen(Widget widget, bool loading) {
    if (loading == true) {
      return Essentials();
    } else {
      return widget;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.circularLoad == true)
      return Scaffold(
        backgroundColor: Colors.white,
        body: loading(true),
      );
    if (widget.imageLoad == true)
      return Container(
        color: Colors.white,
        child: AnimatedOpacity(
          // If the Widget should be visible, animate to 1.0 (fully visible).
          // If the Widget should be hidden, animate to 0.0 (invisible).
          opacity: _visibleWelcome ? 1.0 : 0.0,
          duration: Duration(milliseconds: 500),
          // The green box needs to be the child of the AnimatedOpacity
          child: Center(
            child: Image.asset("lib/assets/images/welcome.png"),
          ),
        ),
      );
  }
}
