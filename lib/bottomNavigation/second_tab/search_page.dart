import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smidigprosjekt/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smidigprosjekt/service/service_provider.dart';
import 'package:smidigprosjekt/utils/uidata.dart';
import 'package:smidigprosjekt/userSearch/search.dart';
import 'package:smidigprosjekt/objects/user.dart';
import 'package:smidigprosjekt/widgets/search.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({
    Key key,
    this.user,
  }) : super(key: key);
  final User user;
  @override
  SearchPageState createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  //final Firestore firestoreInstance = Firestore.instance;
  //final BaseAuth auth = Auth();

  int screen = 0;

  @override
  initState() {
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: UIData.grey,
        resizeToAvoidBottomPadding: true,
        appBar: new AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          centerTitle: true,
          title: new Text(
            "Søk",
            style: ServiceProvider.instance.styles.title(),
          ),
        ),
        body: Search(
          fromGroup: false,
        ));
  }
}
