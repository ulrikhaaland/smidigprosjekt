import 'package:flutter/material.dart';
import 'package:smidigprosjekt/utils/uidata.dart';

class Styles {
  Styles() {
    print('Styles: constructor');
  }

  TextStyle textLight(double fontSize) {
    return TextStyle(
      color: UIData.grey,
      fontSize: fontSize,
      fontFamily: "RobotoLight",
    );
  }

  TextStyle title() {
    return TextStyle(
      color: UIData.grey,
      fontSize: 18,
      fontFamily: "Roboto",
    );
  }
}
