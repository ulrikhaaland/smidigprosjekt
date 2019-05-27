import 'package:flutter/material.dart';

import '../service/service_provider.dart';
import '../style/app_style.dart';

class InstanceStyleService {
  AppStyle _appStyle = AppStyle();

  AppStyle _defaultAppStyle = AppStyle(
    themeColor: MaterialColor(0xFF25814E, <int, Color>{
      50: const Color(0xFF25814E),
      100: const Color(0xFF25814E),
      200: const Color(0xFF25814E),
      300: const Color(0xFF25814E),
      400: const Color(0xFF25814E),
      500: const Color(0xFF25814E),
      600: const Color(0xFF25814E),
      700: const Color(0xFF25814E),
      800: const Color(0xFF25814E),
      900: const Color(0xFF25814E),
    }),
    backgroundColor: Color.fromARGB(255, 240, 240, 240),
  );

  InstanceStyleService() {
    print('InstanceStyleService: constructor');
  }

  /// The global style for this application.
  /// The style can be instance specific such
  /// as the theme color may be the color of the
  /// company who uses the instance
  AppStyle get appStyle => (_appStyle ?? _defaultAppStyle);

  bool _standardStyleSet = false;

  void setStandardStyle(double screenHeight) {
    print('InstanceStyleService: setStandardStyle');

    _appStyle.backgroundColor = new Color.fromARGB(255, 240, 240, 240);

    _appStyle.black = Color.fromRGBO(30, 30, 30, 1);
    _appStyle.grey = Color.fromRGBO(242, 242, 242, 1);
    _appStyle.pink = Color.fromRGBO(231, 59, 112, 1.0);
    _appStyle.lightPink = Color.fromRGBO(231, 59, 112, 0.63);
    _appStyle.blue = Color.fromRGBO(109, 133, 194, 1.0);
    _appStyle.lightBlue = Color.fromRGBO(203, 216, 238, 1.0);
    _appStyle.darkblue = Color.fromRGBO(61, 50, 136, 1.0);

    _appStyle.title = new TextStyle(
      fontSize: screenHeight * 0.032,
      fontFamily: 'Roboto',
      fontWeight: FontWeight.bold,
      fontStyle: FontStyle.normal,
      color: _appStyle.black,
    );

    _appStyle.secondaryTitle = new TextStyle(
      fontSize: screenHeight * 0.032,
      fontFamily: 'Roboto',
      fontWeight: FontWeight.bold,
      fontStyle: FontStyle.normal,
      color: _appStyle.black,
    );

    _appStyle.titleGrey = new TextStyle(
        fontSize: screenHeight * 0.040,
        fontFamily: 'Roboto',
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.normal,
        color: _appStyle.black);

    _appStyle.body1 = new TextStyle(
      fontFamily: "Roboto",
      fontSize: screenHeight * 0.020,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.normal,
      color: _appStyle.black,
    );

    _appStyle.body1Bold = new TextStyle(
      fontSize: screenHeight * 0.020,
      fontWeight: FontWeight.bold,
      fontStyle: FontStyle.normal,
      color: _appStyle.black,
    );

    _appStyle.body1Light = new TextStyle(
        fontFamily: "RobotoLight",
        fontSize: screenHeight * 0.024,
        fontWeight: FontWeight.normal,
        fontStyle: FontStyle.normal,
        color: Colors.white);

    _appStyle.body1Grey = new TextStyle(
        fontFamily: "RobotoLight",
        fontSize: screenHeight * 0.024,
        fontWeight: FontWeight.normal,
        fontStyle: FontStyle.normal,
        color: _appStyle.grey);

    _appStyle.body2 = new TextStyle(
      fontSize: screenHeight * 0.024,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.italic,
      color: _appStyle.black,
    );

    _appStyle.numberHead1 = new TextStyle(
      fontSize: screenHeight * 0.018,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.normal,
      color: _appStyle.black,
    );

    _appStyle.numberHead2 = new TextStyle(
      fontSize: screenHeight * 0.018,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.italic,
      color: _appStyle.black,
    );

    _appStyle.textFieldLabel = new TextStyle(
      fontSize: screenHeight * 0.025,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.italic,
      color: _appStyle.black,
    );

    _appStyle.buttonText = new TextStyle(
      fontFamily: "Roboto",
      fontSize: screenHeight * 0.025,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.italic,
      color: _appStyle.black,
    );

    _appStyle.iconSize = screenHeight * 0.041;

    _appStyle.activeIconColor = _appStyle.black;

    _appStyle.inactiveIconColor = _appStyle.black;

    _defaultAppStyle = _appStyle;

    _standardStyleSet = true;
  }
}
