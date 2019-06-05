import 'package:flutter/material.dart';
import 'package:smidigprosjekt/root_page.dart';
import 'package:smidigprosjekt/auth.dart';
import 'package:smidigprosjekt/service/screen_service.dart';
import 'package:smidigprosjekt/service/service_provider.dart';
import 'package:smidigprosjekt/service/styles.dart';
import 'package:smidigprosjekt/utils/uidata.dart';
import 'bottomNavigation/second_tab/search_page.dart';

void main() {
  ServiceProvider.instance.screenService = ScreenService();
  ServiceProvider.instance.styles = Styles();

  runApp(MyApp( ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      color: Colors.black,
      title: 'Flutter Login',
      theme: new ThemeData(
        fontFamily: 'Roboto',
        primaryColor: UIData.blue,
        accentColor: UIData.pink,
        //highlightColor: UIData.pink,
        scaffoldBackgroundColor: Colors.black,
        buttonColor: Colors.yellow[700],
      ),
      home: new RootPage(auth: new Auth()),
    );
  }
}
