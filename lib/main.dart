import 'package:flutter/material.dart';
import 'package:smidigprosjekt/root_page.dart';
import 'package:smidigprosjekt/auth.dart';
import 'package:smidigprosjekt/service/screen_service.dart';
import 'package:smidigprosjekt/service/service_provider.dart';
import 'package:smidigprosjekt/utils/uidata.dart';

void main() {
  ServiceProvider.instance.screenService = ScreenService();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      color: Colors.black,
      title: 'Flutter Login',
      theme: new ThemeData(
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: Colors.black,
        buttonColor: Colors.yellow[700],
      ),
      home: new RootPage(auth: new Auth()),
    );
  }
}
