import 'package:flutter/material.dart';
import 'package:smidigprosjekt/objects/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../service/service_provider.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({this.user, this.onSignOut});
  final User user;
  final VoidCallback onSignOut;
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  static final formKey = new GlobalKey<FormState>();

  String bio = "";
  String linje = "";
  String skole = "";
  bool edit = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Colors.black,
            ),
            onPressed: null,
          ),
        ],
        elevation: 0,
        backgroundColor: Colors.white,
        title: new Text(
          "StudBud",
          style: new TextStyle(
              fontFamily: 'Anton', fontSize: 24, color: Colors.black),
        ),
      ),
      body: new Form(
        key: formKey,
        child: userInfo(),
      ),
    );
  }

  Widget userInfo() {
    if (edit) {
      return new SingleChildScrollView(
          child: new Stack(
        children: <Widget>[
          new Center(
            child: new Card(
              margin: EdgeInsets.only(
                top: ServiceProvider.instance.screenService
                        .getHeightByPercentage(context, 100) /
                    15,
              ),
              color: Colors.grey[200],
              elevation: 2,
              child: new Container(
                height: ServiceProvider.instance.screenService
                    .getPortraitHeightByPercentage(context, 66),
                width: ServiceProvider.instance.screenService
                    .getPortraitWidthByPercentage(context, 90),
                child: new Column(
                  children: <Widget>[
                    new Align(
                      alignment: Alignment.centerRight,
                      child: new IconButton(
                        icon: Icon(
                          Icons.edit,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          final form = formKey.currentState;
                          form.save();
                          setState(() {
                            edit = !edit;
                          });
                          Firestore.instance
                              .document("users/${widget.user.id}")
                              .updateData(widget.user.toJson());
                        },
                      ),
                    ),
                    new Padding(
                      padding: EdgeInsets.only(top: 46),
                    ),
                    new Text(
                      "widget.user.userName",
                      style: new TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    new ListTile(
                      leading: new Text(
                        "Skole:",
                        style: new TextStyle(fontWeight: FontWeight.bold),
                      ),
                      title: new TextFormField(
                        initialValue: "widget.user.skole",
                        textCapitalization: TextCapitalization.sentences,
                        autocorrect: false,
                        // onSaved: (val) => "widget.user.skole "= val,
                      ),
                    ),
                    new ListTile(
                      leading: new Text(
                        "Linje:",
                        style: new TextStyle(fontWeight: FontWeight.bold),
                      ),
                      title: new TextFormField(
                        // initialValue: widget.user.linje,
                        autocorrect: false,
                        textCapitalization: TextCapitalization.sentences,
                        // onSaved: (val) => widget.user.linje = val,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 36),
                    ),
                    new ListTile(
                      leading: Text(
                        "Bio:",
                        style: new TextStyle(fontWeight: FontWeight.bold),
                      ),
                      title: new TextFormField(
                        maxLength: 160,
                        // initialValue: widget.user.bio,
                        textCapitalization: TextCapitalization.sentences,
                        maxLines: 5,
                        style: new TextStyle(
                          color: Colors.black,
                        ),
                        key: new Key('bio'),
                        decoration: new InputDecoration(
                            border: OutlineInputBorder(),
                            fillColor: Colors.black,
                            labelStyle: new TextStyle(color: Colors.grey[600])),
                        // onSaved: (val) => widget.user.bio = val,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          new Align(
            alignment: Alignment.center,
            child: new CircleAvatar(
              radius: 70,
              backgroundColor: Colors.white,
              child: new Image.asset(
                "lib/assets/images/profile.gif",
              ),
            ),
          ),
        ],
      ));
    } else {
      return new SingleChildScrollView(
          child: new Stack(
        children: <Widget>[
          new Center(
            child: new Card(
              margin: EdgeInsets.only(
                top: ServiceProvider.instance.screenService
                    .getHeightByPercentage(context, 6.25),
              ),
              color: Colors.grey[200],
              elevation: 2,
              child: new Container(
                height: ServiceProvider.instance.screenService
                    .getHeightByPercentage(context, 66),
                width: ServiceProvider.instance.screenService
                    .getPortraitWidthByPercentage(context, 90),
                child: new Column(
                  children: <Widget>[
                    new Align(
                      alignment: Alignment.centerRight,
                      child: new IconButton(
                        icon: Icon(
                          Icons.edit,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          setState(() {
                            edit = !edit;
                          });
                        },
                      ),
                    ),
                    new Padding(
                      padding: EdgeInsets.only(top: 46),
                    ),
                    new Text(
                      " widget.user.userName,",
                      style: new TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    new ListTile(
                        leading: new Text(
                          "Skole:",
                          style: new TextStyle(fontWeight: FontWeight.bold),
                        ),
                        title: new Text("widget.user.skole")),
                    new ListTile(
                        leading: new Text(
                          "Linje:",
                          style: new TextStyle(fontWeight: FontWeight.bold),
                        ),
                        title: new Text("widget.user.linje")),
                    Padding(
                      padding: EdgeInsets.only(top: 36),
                    ),
                    new ListTile(
                        leading: Text(
                          "Bio:",
                          style: new TextStyle(fontWeight: FontWeight.bold),
                        ),
                        title: new Text("widget.user.bio")),
                    new Align(
                      alignment: Alignment.bottomCenter,
                      child: new RaisedButton(
                        color: Colors.white,
                        child: new Container(
                          width: 100,
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              new Text(
                                "INNBOKS",
                                style:
                                    new TextStyle(fontWeight: FontWeight.bold),
                              ),
                              new Icon(
                                Icons.chat,
                                size: 20,
                              )
                            ],
                          ),
                        ),
                        onPressed: () => widget.onSignOut(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          new Align(
            alignment: Alignment.center,
            child: new CircleAvatar(
              radius: 70,
              backgroundColor: Colors.white,
              child: new Image.asset(
                "lib/assets/images/profile.gif",
              ),
            ),
          ),
        ],
      ));
    }
  }
}
