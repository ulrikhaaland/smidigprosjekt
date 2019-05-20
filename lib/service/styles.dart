import 'package:flutter/material.dart';
import 'package:smidigprosjekt/utils/uidata.dart';

class Styles {
  Styles() {
    print('Styles: constructor');
  }

  TextStyle textLight({double fontSize, Color color}) {
    return TextStyle(
      color: color ?? UIData.black,
      fontSize: fontSize ?? 12,
      fontFamily: "RobotoLight",
    );
  }

  TextStyle title({Color color, double fontSize}) {
    return TextStyle(
      color: color ?? UIData.black,
      fontSize: fontSize ?? 22,
      fontFamily: "Roboto",
    );
  }
}
