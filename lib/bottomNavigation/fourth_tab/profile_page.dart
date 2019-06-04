import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smidigprosjekt/objects/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smidigprosjekt/utils/uidata.dart';
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
  bool newFoto = false;
  bool edit = false;

  File imgUrl;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: UIData.grey,
      appBar: new AppBar(
        actions: <Widget>[
          IconButton(
            icon: IconButton(
              onPressed: () {},
              icon: Image.asset("lib/assets/images/settings_icon.png", ),
              //color: Colors.black,
            ),
            onPressed: null,
          ),
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
    );
  }

  Widget userInfo() {
    if (edit) {
      return new SingleChildScrollView(
          child: new Stack(
        children: <Widget>[
          new Center(

            child: new Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              margin: EdgeInsets.only(
                top: ServiceProvider.instance.screenService
                        .getHeightByPercentage(context, 100) /
                    15,
              ),
              color: Colors.white,
              elevation: 0,
              child: new Container(
                height: ServiceProvider.instance.screenService
                    .getPortraitHeightByPercentage(context, 70),
                width: ServiceProvider.instance.screenService
                    .getPortraitWidthByPercentage(context, 85),
                child: new Column(
                  children: <Widget>[
                    new Align(
                      alignment: Alignment.centerRight,
                      child: new IconButton(
                        icon: Image.asset("lib/assets/images/editprofile_icon.png", color: UIData.black, scale: 11,),
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
                    new Center(
                      child:

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
            child: GestureDetector(
              onTap: () {
                openOptions();
              },
              child:
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(70), side:  BorderSide(color: UIData.pink, width: 2)),
              //decoration: BoxDecoration(borderRadius: BorderRadius.circular(60), border: index == 0 ? Border.all(width: 3, color: UIData.pink) : Border.all(color: Colors.white) ),
              child: ClipRRect(
                borderRadius: new BorderRadius.circular(70),
                child: newFoto ? Image.file(imgUrl,
                  width: 122,
                  height: 122,
                  fit: BoxFit.cover,
                )

                    : Image.asset("lib/assets/images/fortnite.jpg" ,
                  width: 122,
                  height: 122,
                  fit: BoxFit.cover,
                ),
              ),
            ), ),
          ),
        ],
      ));
    } else {
      return new SingleChildScrollView(
          child: new Stack(
        children: <Widget>[

          new Column(
            children: <Widget>[

             Center(
            child: new Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
                    new Align(
                      alignment: Alignment.centerRight,
                      child: new IconButton(
                        icon: Image.asset("lib/assets/images/editprofile_icon.png", color: UIData.black, scale: 11,),
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
                      "${widget.user.userName}",
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

                    new ListTile(
                        leading: Text(
                          "Bio:",
                          style: new TextStyle(fontWeight: FontWeight.bold),
                        ),
                        title: new Text("widget.user.bio")),

                  ],
                ),
              ),
            ),

          ),
              Padding(
                padding: EdgeInsets.all(10)
              ),
              new Text(
                "Mine eventer:",
                style: new TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

            ]

    ),

          new Align(
              alignment: Alignment.center,
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(70), side:  BorderSide(color: UIData.pink, width: 2)),
                //decoration: BoxDecoration(borderRadius: BorderRadius.circular(60), border: index == 0 ? Border.all(width: 3, color: UIData.pink) : Border.all(color: Colors.white) ),
                child: ClipRRect(
                  borderRadius: new BorderRadius.circular(70),
                  child: newFoto ? Image.file(imgUrl,
                    width: 122,
                    height: 122,
                    fit: BoxFit.cover,
                  )

                      : Image.asset("lib/assets/images/fortnite.jpg" ,
                    width: 122,
                    height: 122,
                    fit: BoxFit.cover,
                  ),
                ),
              )
          ),

        ],
      ));
    }
  }

  Future openCamera() async {
    var picture = await ImagePicker.pickImage(
        source: ImageSource.camera );
    setState((){
      imgUrl = picture;
      newFoto = true;

    });
  }

  Future openGallery() async {
    var gallery = await ImagePicker.pickImage(
        source: ImageSource.gallery);
    setState((){
      imgUrl = gallery;
      newFoto = true;

    });
  }
  Future<void> openOptions() {
    return showDialog(context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),

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
                        child: new Text('Ta et bilde', style: TextStyle(fontSize: 20) ,),
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
                        child: new Text('Velg fra kamerarull', style: TextStyle(fontSize: 20)),
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

}



//## new Align(
//                      alignment: Alignment.bottomCenter,
//                      child: new RaisedButton(
//                        color: Colors.white,
//                        child: new Container(
//                          width: 100,
//                          child: new Row(
//                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                            children: <Widget>[
//                              new Text(
//                                "INNBOKS",
//                                style:
//                                    new TextStyle(fontWeight: FontWeight.bold),
//                              ),
//                              new Icon(
//                                Icons.chat,
//                                size: 20,
//                              )
//                            ],
//                          ),
//                        ),
//                        onPressed: () => widget.onSignOut(),
//                      ),
//                    ),
