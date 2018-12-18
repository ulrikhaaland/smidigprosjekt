import 'package:flutter/material.dart';
import 'uidata.dart';

class Essentials extends StatelessWidget {
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: loading(true),
    );
  }
}
