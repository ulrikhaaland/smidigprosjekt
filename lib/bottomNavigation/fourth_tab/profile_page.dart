import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smidigprosjekt/bottomNavigation/first_tab/feed_page.dart';
import 'package:smidigprosjekt/objects/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smidigprosjekt/utils/uidata.dart';
import '../../service/service_provider.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({
    this.user,
    this.onSignOut,
    this.endDrawer,
    this.myEvent,
  });
  final User user;
  final List<Event> myEvent;
  final VoidCallback onSignOut;

  final Widget endDrawer;
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  static final formKey = new GlobalKey<FormState>();

  String bio = "";
  String program = "";
  String school = "";
  String profileImage = "";

  bool newFoto = false;
  bool edit = false;
  bool myProfile = true;

  int tapped = -1;
  double cardWidth;
  bool tap = false;
  bool going = false;

  var dbUrl;

  File imgUrl;

  Firestore firestoreInstance = Firestore.instance;

  String beskrivelse;
  String addresse;
  String tittel;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: () {
        this._removeKeyboard(context);
      },
      child: new Scaffold(
        endDrawer: myProfile ? SizedBox(
          width: 250,
          child: Drawer(
            child: Container(
                color: Colors.white,
                child: Stack(children: <Widget>[
                  Column(
                    children: <Widget>[
                      Container(
                        color: Colors.white,
                        height: 80,
                        padding: EdgeInsets.fromLTRB(0, 43, 0, 0),
                        child: Text(
                          "Innstillinger",
                          style: ServiceProvider.instance.styles.title(),
                        ),
                      ),
                      Divider(
                        color: Colors.black45,
                        height: 1,
                      ),
                      ListTile(
                        title: Text(
                          widget.user.getName(),
                          style: TextStyle(
                              color: UIData.black,
                              fontSize: 15,
                              fontFamily: "Anton",
                              fontWeight: FontWeight.bold),
                        ),
                        onTap: () {},
                      ),
                      Divider(
                        height: 1,
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.help_outline,
                          color: UIData.blue,
                        ),
                        title: Text(
                          'Hjelp',
                          style: TextStyle(
                              color: UIData.black,
                              fontSize: 15,
                              fontFamily: "Anton",
                              fontWeight: FontWeight.normal),
                        ),
                        onTap: () {},
                        contentPadding: EdgeInsets.only(top: 0, left: 15),
                      ),
                      Divider(
                        height: 1,
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.info_outline,
                          color: UIData.blue,
                        ),
                        title: Text(
                          'Om',
                          style: TextStyle(
                              color: UIData.black,
                              fontSize: 15,
                              fontFamily: "Anton",
                              fontWeight: FontWeight.normal),
                        ),
                        onTap: () {},
                      ),
                      Divider(
                        height: 1,
                      ),
                      new Expanded(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            //alignment: FractionalOffset.bottomCenter,
                            height: 60,
                            decoration: new BoxDecoration(
                              color: UIData.pink,
                            ),

                            child: ListTile(
                              leading: Icon(
                                Icons.exit_to_app,
                                color: Colors.white,
                              ),
                              title: Text(
                                'Logg ut',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontFamily: "Anton",
                                    fontWeight: FontWeight.normal),
                              ),
                              onTap: () {
                                widget.onSignOut();
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ])),
          ),
        ) : Container(),
        backgroundColor: UIData.grey,
        appBar: new AppBar(
          actions: <Widget>[
            myProfile ?
            Builder(
              builder: (context) => IconButton(
                    /*leading: new IconButton(icon: Image.asset('lib/assets/images/settings_icon.png', scale: 10,),
                onPressed: () => Scaffold.of(context).openDrawer()),*/
                    icon: Image.asset("lib/assets/images/settings_icon.png",
                        scale: 12),
                    onPressed: () => Scaffold.of(context).openEndDrawer(),
                  ),
            ) : Container(),
          ],
          elevation: 1,
          backgroundColor: Colors.white,
          title: new Text(
            // "${widget.user.userName}",
            "Profil",
            style: ServiceProvider.instance.styles.title(),
          ),
          centerTitle: true,
        ),
        body: new Form(
          key: formKey,
          child: userInfo(),
        ),
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
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              margin: EdgeInsets.only(
                top: ServiceProvider.instance.screenService
                        .getHeightByPercentage(context, 100) /
                    15,
              ),
              color: Colors.white,
              elevation: 0,
              child: new Container(
                height: ServiceProvider.instance.screenService
                    .getPortraitHeightByPercentage(context, 60),
                width: ServiceProvider.instance.screenService
                    .getPortraitWidthByPercentage(context, 85),
                child: new Column(
                  children: <Widget>[
                    new Align(
                      alignment: Alignment.centerRight,
                      child: new IconButton(
                        icon: Image.asset(
                          "lib/assets/images/editprofile_icon.png",
                          color: UIData.black,
                          scale: 11,
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
                      "${widget.user.userName}",
                      style: new TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(7)),
                    new Text(
                      widget.user.school,
                      //style: new TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Padding(padding: EdgeInsets.all(7)),
                    new Text(
                      widget.user.program,
                      // style: new TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Padding(padding: EdgeInsets.all(7)),
                    new ListTile(
                      leading: Text(
                        "Bio:",
                        style: new TextStyle(fontWeight: FontWeight.bold),
                      ),
                      title: new TextFormField(
                        // textInputAction: TextInputAction.done,
                        maxLength: 160,
                        // initialValue: widget.user.bio,
                        textCapitalization: TextCapitalization.sentences,
                        maxLines: 5,
                        style: new TextStyle(
                          color: Colors.black,
                        ),
                        key: new Key('bio'),
                        initialValue: widget.user.bio,
                        decoration: new InputDecoration(
                            border: OutlineInputBorder(),
                            fillColor: Colors.black,
                            labelStyle: new TextStyle(color: Colors.grey[600])),
                        onSaved: (val) => widget.user.bio = val,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          new Align(
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: () {
                  openOptions();
                },
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(70),
                      side: BorderSide(color: UIData.pink, width: 2)),
                  //decoration: BoxDecoration(borderRadius: BorderRadius.circular(60), border: index == 0 ? Border.all(width: 3, color: UIData.pink) : Border.all(color: Colors.white) ),
                  child: ClipRRect(
                    borderRadius: new BorderRadius.circular(70),
                    child: widget.user.profileImage != null ?  Image.network(
                            widget.user.profileImage,
                            width: 122,
                            height: 122,
                            fit: BoxFit.cover,
                          ) :
                        Image.asset("lib/assets/images/profilbilde.png"),
                  ),
                ),
              ))
        ],
      ));
    } else {
      return new SingleChildScrollView(
          child: new Stack(
        children: <Widget>[
          new Column(children: <Widget>[
            Center(
              child: new Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                margin: EdgeInsets.only(
                  top: ServiceProvider.instance.screenService
                      .getHeightByPercentage(context, 6.25),
                ),
                color: Colors.white,
                elevation: 0,
                child: new Container(
                  height: ServiceProvider.instance.screenService
                      .getHeightByPercentage(context, 45),
                  width: ServiceProvider.instance.screenService
                      .getPortraitWidthByPercentage(context, 85),
                  child: new Column(
                    children: <Widget>[
                      myProfile ?
                      new Align(
                        alignment: Alignment.centerRight,
                        child: new IconButton(
                          icon: Image.asset(
                            "lib/assets/images/editprofile_icon.png",
                            color: UIData.black,
                            scale: 11,
                          ),
                          onPressed: () {
                            setState(() {
                              edit = !edit;
                            });
                          },
                        ),
                      ) :
                    new Align(
                    alignment: Alignment.centerRight,
                    child: new IconButton(
                    icon: Image.asset(
                    "lib/assets/images/editprofile_icon.png",
                    color: Colors.white,
                    scale: 11,
                    ),
                    onPressed: null ),),

                      new Padding(
                        padding: EdgeInsets.only(top: 46),
                      ),
                      new Text(
                        "${widget.user.userName}",
                        style: new TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(padding: EdgeInsets.all(7)),
                      new Text(
                        widget.user.school,
                        //style: new TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Padding(padding: EdgeInsets.all(7)),
                      new Text(
                        widget.user.program,
                        // style: new TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Padding(padding: EdgeInsets.all(7)),
                      new Container(
                        height: 80,
                        width: 250,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.fromBorderSide(BorderSide(
                                width: 1,
                                color: UIData.grey,
                                style: BorderStyle.solid))),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(widget.user.bio),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(padding: EdgeInsets.all(10)),
            myProfile ?
            new Text(
              "Mine events:",
              style: new TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ) : new Container(),
            new Container(
              child: new Stack(
                //child: new Stack(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                            height: ServiceProvider.instance.screenService
                                .getPortraitHeightByPercentage(context, 50),
                            width: ServiceProvider.instance.screenService
                                .getPortraitWidthByPercentage(context, 82),
                            child: StreamBuilder(
                                stream: Firestore.instance
                                    .collection("events")
                                    .orderBy('time', descending: false)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData)
                                    return Center(child: Text("Laster.."));
                                  return ListView.builder(
                                    //itemExtent: 350.0,
                                    itemCount: snapshot.data.documents.length,
                                    itemBuilder: (context, index) {
                                      DocumentSnapshot document =
                                          snapshot.data.documents[index];
                                      var now = new DateTime.now();
                                      if (document.data["id"]
                                              .contains(widget.user.userName) &&
                                          document.data["time"].isAfter(now ) && myProfile == true) {
                                        return Column(
                                          children: <Widget>[
                                            Divider(
                                              color: UIData.grey,
                                            ),
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    10, 0, 0, 0),
                                                child: Text(
                                                  _DateText(document),
                                                ),
                                              ),
                                            ),
                                            Divider(
                                              color: UIData.grey,
                                              height: 0.2,
                                            ),
                                            Column(
                                              children: <Widget>[
                                                tap == true &&
                                                        tapped != null &&
                                                        tapped == index
                                                    ? SizedBox(
                                                        height: 375,
                                                        width: ServiceProvider
                                                            .instance
                                                            .screenService
                                                            .getPortraitWidthByPercentage(
                                                                context, 82),
                                                        child: Card(
                                                          elevation: 0.0,
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8)),
                                                          child: Column(
                                                            children: <Widget>[
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .end,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .end,
                                                                //crossAxisAlignment: CrossAxisAlignment.stretch,

                                                                children: <
                                                                    Widget>[
                                                                  IconButton(
                                                                    //padding: EdgeInsets.all(0),
                                                                    icon: Icon(
                                                                        Icons
                                                                            .delete,
                                                                        color: UIData
                                                                            .black,
                                                                        size:
                                                                            22),
                                                                    onPressed: () =>
                                                                        showDialog(
                                                                            context:
                                                                                context,
                                                                            builder:
                                                                                (BuildContext context) {
                                                                              return AlertDialog(
                                                                                elevation: 2,
                                                                                //contentPadding: EdgeInsets.all(0),
                                                                                backgroundColor: UIData.blue,
                                                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                                                                                content: new GestureDetector(
                                                                                  onTap: () {
                                                                                    _delete(document, index);
                                                                                  },
                                                                                  //_delete(position),
                                                                                  child: Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                    children: <Widget>[
                                                                                      Icon(Icons.delete, color: Colors.white),
                                                                                      Text(
                                                                                        "Slett event",
                                                                                        style: TextStyle(
                                                                                          color: Colors.white,
                                                                                        ),
                                                                                        textAlign: TextAlign.center,
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              );
                                                                            }),
                                                                  ),
                                                                  IconButton(
                                                                    //padding: EdgeInsets.all(0),
                                                                    icon: Image.asset(
                                                                        "lib/assets/images/editprofile_icon.png",
                                                                        scale:
                                                                            14,
                                                                        color: UIData
                                                                            .pink),
                                                                    onPressed:
                                                                        () {
                                                                      _tapped(
                                                                          index);
                                                                    },
                                                                  ),
                                                                ],
                                                              ),
                                                              Divider(
                                                                height: 0,
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .fromLTRB(
                                                                            5,
                                                                            0,
                                                                            5,
                                                                            0),
                                                                child:
                                                                    Container(
                                                                  height: 68,
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        EdgeInsets
                                                                            .all(8),
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: <
                                                                          Widget>[
                                                                        new Container(
                                                                          height:
                                                                              50,
                                                                          child:
                                                                              new ListTile(
                                                                            leading:
                                                                                Text("Tittel:", style: TextStyle(fontWeight: FontWeight.bold)),
                                                                            title:
                                                                                TextFormField(
                                                                              textInputAction: TextInputAction.done,
                                                                              //maxLength: 30,
                                                                              // initialValue: widget.user.bio,
                                                                              textCapitalization: TextCapitalization.sentences,
                                                                              maxLines: 1,
                                                                              style: new TextStyle(color: UIData.black, fontSize: 13),
                                                                              initialValue: document.data["title"],
                                                                              onSaved: (val) => tittel = val,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .fromLTRB(
                                                                            5,
                                                                            0,
                                                                            5,
                                                                            0),
                                                                child:
                                                                    Container(
                                                                  height: 68,
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        EdgeInsets
                                                                            .all(8),
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: <
                                                                          Widget>[
                                                                        new Container(
                                                                          height:
                                                                              50,
                                                                          child:
                                                                              new ListTile(
                                                                            leading:
                                                                                Text("Addresse:", style: TextStyle(fontWeight: FontWeight.bold)),
                                                                            title:
                                                                                TextFormField(
                                                                              textInputAction: TextInputAction.done,
                                                                              //maxLength: 30,
                                                                              // initialValue: widget.user.bio,
                                                                              textCapitalization: TextCapitalization.sentences,
                                                                              maxLines: 1,
                                                                              style: new TextStyle(color: UIData.black, fontSize: 13),
                                                                              initialValue: document.data["address"],

                                                                              onSaved: (val) => addresse = val,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(5),
                                                                child:
                                                                    Container(
                                                                  height: 130,
                                                                  decoration: BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8),
                                                                      border: Border.all(
                                                                          color:
                                                                              Colors.white)),
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        EdgeInsets
                                                                            .all(8),
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: <
                                                                          Widget>[
                                                                        new Container(
                                                                          height:
                                                                              110,
                                                                          child:
                                                                              new TextFormField(
                                                                            textInputAction:
                                                                                TextInputAction.done,
                                                                            maxLength:
                                                                                160,
                                                                            // initialValue: widget.user.bio,
                                                                            textCapitalization:
                                                                                TextCapitalization.sentences,
                                                                            maxLines:
                                                                                5,
                                                                            style:
                                                                                new TextStyle(color: UIData.black, fontSize: 13),
                                                                            initialValue:
                                                                                document.data["desc"],
                                                                            decoration: new InputDecoration(
                                                                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: UIData.grey, width: 1, style: BorderStyle.solid)),
                                                                                // fillColor: UIData.black,
                                                                                labelStyle: new TextStyle(color: Colors.grey[600], fontSize: 10)),

                                                                            onSaved: (val) =>
                                                                                beskrivelse = val,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child:
                                                                    Container(
                                                                  height: 40,
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          top:
                                                                              0),
                                                                  width: ServiceProvider
                                                                      .instance
                                                                      .screenService
                                                                      .getPortraitWidthByPercentage(
                                                                          context,
                                                                          82),
                                                                  decoration:
                                                                      new BoxDecoration(
                                                                    color: UIData
                                                                        .blue,
                                                                    borderRadius: new BorderRadius
                                                                            .only(
                                                                        bottomLeft:
                                                                            const Radius.circular(
                                                                                8.0),
                                                                        bottomRight:
                                                                            const Radius.circular(8.0)),
                                                                  ),
                                                                  child:
                                                                      FlatButton(
                                                                    color: UIData
                                                                        .blue,
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(100)),
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            10),
                                                                    onPressed:
                                                                        () {
                                                                      //going = true;
                                                                      _tapped(
                                                                          index);
                                                                      final form =
                                                                          formKey
                                                                              .currentState;
                                                                      form.save();
                                                                      _update(
                                                                          document,
                                                                          beskrivelse);
                                                                      _updateAdd(
                                                                          document,
                                                                          addresse);
                                                                      _updateTit(
                                                                          document,
                                                                          tittel);
                                                                      //_starred(snapshot);
                                                                    },
                                                                    child: Text(
                                                                        "Lagre",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                            fontSize: 13)),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                    : SizedBox(
                                                        height: 130,
                                                        child: Card(
                                                          elevation: 0.0,
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8)),
                                                          child: Column(
                                                            children: <Widget>[
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                //crossAxisAlignment: CrossAxisAlignment.stretch,

                                                                children: <
                                                                    Widget>[
                                                                  ClipRRect(
                                                                    borderRadius: new BorderRadius
                                                                            .only(
                                                                        topLeft:
                                                                            Radius.circular(
                                                                                8),
                                                                        bottomLeft:
                                                                            Radius.circular(8)),
                                                                    child: Image
                                                                        .network(
                                                                      document.data[
                                                                          "imgUrl"],
                                                                      height:
                                                                          122,
                                                                      width:
                                                                          110,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            10),
                                                                    child:
                                                                        Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerRight,
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: <
                                                                            Widget>[
                                                                          Row(
                                                                            children: <Widget>[
                                                                              GestureDetector(
                                                                                onTap: () {
                                                                                  _tapped(index);
                                                                                },
                                                                                child: new Text(document.data["title"], style: ServiceProvider.instance.styles.cardTitle()),
                                                                              ),
                                                                              new Container(
                                                                                child: SizedBox(
                                                                                  height: 20,
                                                                                  child: IconButton(
                                                                                    icon: Image.asset("lib/assets/images/editprofile_icon.png", scale: 14),
                                                                                    padding: EdgeInsets.all(0),
                                                                                    onPressed: () {
                                                                                      _tapped(index);
                                                                                    },
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Divider(
                                                                              color: Colors.white),
                                                                          Row(
                                                                            children: <Widget>[
                                                                              Icon(
                                                                                Icons.location_on,
                                                                                color: UIData.blue,
                                                                                size: 20,
                                                                              ),
                                                                              Text(
                                                                                document.data["address"],
                                                                                style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Divider(
                                                                            color:
                                                                                Colors.white,
                                                                          ),
                                                                          Row(
                                                                            children: <Widget>[
                                                                              Icon(
                                                                                Icons.access_time,
                                                                                color: UIData.black,
                                                                                size: 17,
                                                                              ),
                                                                              Text(
                                                                                ' ${document.data["time"].hour.toString()}' + ':' + '${document.data["time"].minute.toString().padRight(2, '0')}',
                                                                                style: TextStyle(fontSize: 12),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                              ],
                                            ),
                                          ],
                                        );
                                      } else {
                                        return Divider(
                                            color: UIData.grey, height: 0);
                                      }
                                      ;
                                    },
                                  );
                                })),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.center,
                  ),
                ],
              ),
            ),
          ]),
          new Align(
              alignment: Alignment.center,
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(70),
                    side: BorderSide(color: UIData.pink, width: 2)),
                //decoration: BoxDecoration(borderRadius: BorderRadius.circular(60), border: index == 0 ? Border.all(width: 3, color: UIData.pink) : Border.all(color: Colors.white) ),
                child: ClipRRect(
                  borderRadius: new BorderRadius.circular(70),
                  child: newFoto
                      ? Image.file(
                          imgUrl,
                          width: 122,
                          height: 122,
                          fit: BoxFit.cover,
                        )
                      : Image.network(
                          widget.user.profileImage,
                          width: 122,
                          height: 122,
                          fit: BoxFit.cover,
                        ),
                ),
              )),
        ],
      ));
    }
  }

  void _tapped(index) {
    setState(() {
      if (tap) {
        tap = false;
        tapped = index;
      } else {
        tap = true;
        tapped = index;
      }
    });
  }

  String _DateText(document) {
    DateTime dt = document.data["time"];
    if (dt.month == 1) {
      return '${dt.day.toString()}' + '. ' + 'Januar';
    } else if (dt.month == 2) {
      return '${dt.day.toString()}' + '. ' + 'Februar';
    } else if (dt.month == 3) {
      return '${dt.day.toString()}' + '. ' + 'Mars';
    } else if (dt.month == 4) {
      return '${dt.day.toString()}' + '. ' + 'April';
    } else if (dt.month == 5) {
      return '${dt.day.toString()}' + '. ' + 'Mai';
    } else if (dt.month == 6) {
      return '${dt.day.toString()}' + '. ' + 'Juni';
    } else if (dt.month == 7) {
      return '${dt.day.toString()}' + '. ' + 'Juli';
    } else if (dt.month == 8) {
      return '${dt.day.toString()}' + '. ' + 'August';
    } else if (dt.month == 9) {
      return '${dt.day.toString()}' + '. ' + 'September';
    } else if (dt.month == 10) {
      return '${dt.day.toString()}' + '. ' + 'Oktober';
    } else if (dt.month == 11) {
      return '${dt.day.toString()}' + '. ' + 'November';
    } else if (dt.month == 12) {
      return '${dt.day.toString()}' + '. ' + 'Desember';
    }
  }

  void _delete(DocumentSnapshot document, int index) async {
    var name = document.data["id"];
    Firestore.instance.collection("events").document(name).delete();
    _tapped(index);
    Navigator.pop(context);

    final StorageReference imgRef =
        FirebaseStorage.instance.ref().child("Event_Images");
    await imgRef.child(name + ".jpg").delete();
  }

  void _update(DocumentSnapshot document, String Beskrivelse) async {
    var name = document.data["id"];
    Firestore.instance
        .collection("events")
        .document(name)
        .updateData({"desc": beskrivelse});
  }

  void _updateAdd(DocumentSnapshot document, String Addresse) async {
    var name = document.data["id"];
    Firestore.instance
        .collection("events")
        .document(name)
        .updateData({"address": addresse});
  }

  void _updateTit(DocumentSnapshot document, String Tittel) async {
    var name = document.data["id"];
    Firestore.instance
        .collection("events")
        .document(name)
        .updateData({"title": tittel});
  }

  Future openCamera() async {
    var picture = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      imgUrl = picture;
      newFoto = true;
    });
    Navigator.of(context, rootNavigator: true).pop();
    uploadImage(imgUrl);
  }

  Future openGallery() async {
    var gallery = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      imgUrl = gallery;
      newFoto = true;
    });
    Navigator.of(context, rootNavigator: true).pop();
    uploadImage(imgUrl);
  }

  Future<void> openOptions() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
            content: new SingleChildScrollView(
              child: new ListBody(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(Icons.photo_camera, color: UIData.blue),
                      Padding(
                        padding: EdgeInsets.all(7.0),
                      ),
                      GestureDetector(
                        child: new Text(
                          'Ta et bilde',
                          style: TextStyle(fontSize: 20),
                        ),
                        onTap: openCamera,
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  Divider(),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  Row(
                    children: <Widget>[
                      Icon(Icons.photo, color: UIData.blue),
                      Padding(
                        padding: EdgeInsets.all(7.0),
                      ),
                      GestureDetector(
                        child: new Text('Velg fra kamerarull',
                            style: TextStyle(fontSize: 20)),
                        onTap: openGallery,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  void _removeKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(new FocusNode());
  }

  void uploadImage(imgUrl) async {
    final StorageReference imgRef =
        FirebaseStorage.instance.ref().child("Profile_Images");
    var timeKey = new DateTime.now();
    final StorageUploadTask upTask =
        imgRef.child(timeKey.toString() + ".jpg").putFile(imgUrl);
    _onLoading();
    var url = await (await upTask.onComplete).ref.getDownloadURL();
    dbUrl = url.toString();
    print("DBURL AFTER UPLOAD:" + dbUrl);
    _sendImage(dbUrl);
    Navigator.pop(context);
  }

  _sendImage(String dbUrl) {
    var db = Firestore.instance;
    db
        .document("users/${widget.user.id}")
        .updateData({"profileImage": dbUrl}).then((val) {
      db.document("users/${widget.user.id}").updateData(widget.user.toJson());
      print("success");
    }).catchError((err) {
      print(err);
    });
    widget.user.profileImage = dbUrl;
  }

  /* Firestore.instance
                              .document("users/${widget.user.id}")
                              .updateData(widget.user.toJson()); */

  void _onLoading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      child: new Dialog(
          child: ClipRRect(
              borderRadius: new BorderRadius.circular(8.0),
              child: Container(
                padding:
                    EdgeInsets.only(top: 12, bottom: 12, left: 16, right: 16),
                child: new Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    new CircularProgressIndicator(
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(UIData.pink),
                    ),
                    new Padding(padding: EdgeInsets.only(left: 25)),
                    new Text("Vent litt..."),
                  ],
                ),
              ))),
    );
  }
}
