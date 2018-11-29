import 'package:flutter/material.dart';
import 'package:smidigprosjekt/root_page.dart';
import 'package:smidigprosjekt/auth.dart';
import 'package:smidigprosjekt/utils/uidata.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      color: UIData.darkest,
      title: 'Flutter Login',
      theme: new ThemeData(
        scaffoldBackgroundColor: UIData.dark,
        buttonColor: Colors.yellow[700],
      ),
      home: new RootPage(auth: new Auth()),
    );
  }
}
