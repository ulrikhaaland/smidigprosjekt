import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smidigprosjekt/bottomNavigation/first_tab/feed_page.dart';
import 'package:smidigprosjekt/objects/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smidigprosjekt/utils/uidata.dart';
import '../../service/service_provider.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({this.user, this.onSignOut, this.endDrawer, this.myEvent});
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
  String linje = "";
  String skole = "";
  bool newFoto = false;
  bool edit = false;


  int tapped = -1;
  double cardWidth;
  bool tap = false;

  bool going = false;

  File imgUrl;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      
      endDrawer: Drawer(
        
        child: ListView(
          
          children: <Widget>[

            ListTile(
              title: Text(
                "Innstillinger",
                style: new TextStyle(fontSize: 18, fontWeight: FontWeight.bold), 
              ),
              
            ),

            Divider(
              color: Colors.black45,
            ),
            
            ListTile(
              
              leading: CircleAvatar(
                
                backgroundImage: AssetImage("lib/assets/images/fortnite.jpg"),
              
              ),

              title: Text(
                'Profil'
                
              ),
              onTap: (){
                Navigator.pushNamed(
                  context,
                  'lib/assets/images/logout.png'
                );
                
              },
            ),
            
            ListTile(
              leading: Icon(Icons.help_outline),
              title: Text('Hjelp'),
              onTap: (){
                Navigator.pushNamed(context, '/transactionsList');
              },
              contentPadding: EdgeInsets.only(top: 10, left: 15),
            ),

            ListTile(
              leading: Icon(Icons.info_outline),
              title: Text('Om'),
              onTap: (){
                Navigator.pushNamed(context, '/transactionsList');
              },
              
            ),
              
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Logg ut',
              
              ),
              onTap: (){
                Navigator.pushNamed(context, '/');
                widget.onSignOut();
              },
              contentPadding: EdgeInsets.only(top: 440, left: 15),
            ),
          ]
        )
      ),
      

      backgroundColor: UIData.grey,
      appBar: new AppBar(
        actions: <Widget>[
          Builder(
            builder: (context) => IconButton(
                /*leading: new IconButton(icon: Image.asset('lib/assets/images/settings_icon.png', scale: 10,),
                onPressed: () => Scaffold.of(context).openDrawer()),*/
              icon: Image.asset("lib/assets/images/settings_icon.png", scale: 10),


              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
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
                "Mine events:",
                style: new TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              new Container(



                child: new


                Stack(

                  //child: new Stack(
                  children: <Widget>[


                    Column(
                      children: <Widget>[


                        Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            height: ((widget.myEvent.length)*190.0),
                            width: ServiceProvider.instance.screenService
                                .getPortraitWidthByPercentage(context, 82),
                            child: ListView.builder(
                              // scrollDirection: Axis.vertical,
                              //shrinkWrap: true,
                              itemBuilder: (context, position){
                                return Column(
                                  children: <Widget>[

                                    Divider(
                                      color: UIData.grey,
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(_DateText(position),


                                      ),
                                    ),
                                    Divider(
                                      color: UIData.grey,
                                      height: 0.2,


                                    ),

                                    GestureDetector(
                                      onTap: () { _tapped(position);},


                                      child: Column(
                                        children: <Widget>[
                                          tap == true && tapped != null && tapped == position ?
                                          SizedBox (
                                            height: 310,
                                            child: Card(
                                              elevation: 0.0,
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),

                                              child: Column(
                                                children: <Widget>[
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    //crossAxisAlignment: CrossAxisAlignment.stretch,

                                                    children: <Widget>[
                                                      ClipRRect(
                                                        borderRadius: new BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                                                        child: Image.network(widget.myEvent[position].imgUrl,

                                                          height: 122,
                                                          width: 287,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),

                                                    ],

                                                  ),
                                                  Divider(
                                                    height: 1,
                                                  ),



                                                  Padding(
                                                    padding: EdgeInsets.all(5),
                                                    child: Container(
                                                      height: 130,
                                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.white)),
                                                      child: Padding(
                                                        padding: EdgeInsets.all(8),
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: <Widget>[
                                                            Text("Beskrivelse:", style: TextStyle(fontWeight: FontWeight.bold)),
                                                            Divider(
                                                              height: 10,
                                                              color: Colors.white,
                                                            ),
                                                            Text( '${widget.myEvent[position].desc}', style: TextStyle(fontSize: 13)

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
                                                      margin: EdgeInsets.only(top: 0),
                                                      width: ServiceProvider.instance.screenService
                                                          .getPortraitWidthByPercentage(context, 82),

                                                      decoration: new BoxDecoration(
                                                        color: Colors.pink,
                                                        borderRadius: new BorderRadius.only(
                                                            bottomLeft:  const  Radius.circular(8.0),
                                                            bottomRight: const  Radius.circular(8.0)),
                                                      ),
                                                      child:
                                                      FlatButton(
                                                        color: UIData.pink,
                                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                                                        padding: EdgeInsets.all(10),
                                                        onPressed: () {
                                                          //going = true;
                                                          _tapped(position);



                                                        },
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: <Widget>[

                                                            Icon(Icons.star_border, color: Colors.white, size: 20,),
                                                            Padding(
                                                                padding: EdgeInsets.all(3)
                                                            ),
                                                            Text("Interessert", style: TextStyle(color: Colors.white, fontSize: 13)),

                                                          ],
                                                        ),


                                                      ),),),




                                                ],
                                              ),








                                            ),


                                          ) : SizedBox(
                                            height: 130,
                                            child: Card(
                                              elevation: 0.0,
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),

                                              child: Column(
                                                children: <Widget>[
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    //crossAxisAlignment: CrossAxisAlignment.stretch,

                                                    children: <Widget>[
                                                      ClipRRect(
                                                        borderRadius: new BorderRadius.only(topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)),
                                                        child: Image.network(widget.myEvent[position].imgUrl,
                                                          height: 122,
                                                          width: 110,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: EdgeInsets.all(10),
                                                        child: Align(
                                                          alignment: Alignment.centerRight,
                                                          child:

                                                          Column(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: <Widget>[

                                                              Row(

                                                                children: <Widget>[
                                                                  new Text(widget.myEvent[position].title, style: ServiceProvider.instance.styles.cardTitle()),
                                                                  Icon(Icons.star, color: Colors.white, size: 20,),
                                                                ],
                                                              ),


                                                              Divider(
                                                                  color: Colors.white
                                                              ),
                                                              Row(
                                                                children: <Widget>[
                                                                  Icon(Icons.location_on, color: UIData.blue, size: 20,),
                                                                  Text(widget.myEvent[position].address, style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
                                                                  ),
                                                                ],
                                                              ),
                                                              Divider(
                                                                color: Colors.white,
                                                              ),
                                                              Row(
                                                                children: <Widget>[
                                                                  Icon(Icons.access_time, color: UIData.black, size: 17,),
                                                                  Text(' ${widget.myEvent[position].time.hour.toString()}' + ':' + '${widget.myEvent[position].time.minute.toString().padRight(2, '0')}', style: TextStyle( fontSize: 12),
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



                                    )


                                  ],
                                );

                              },
                              itemCount: widget.myEvent.length,
                            ),


                          ),
                        ),

                      ],
                    ),


                    Align(

                      alignment: Alignment.center,






                    ),
                  ],
                ),


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

  void _tapped(position) {
    setState((){
      if(tap) {
        tap = false;
        tapped = position;
      } else {
        tap = true;
        tapped = position;
      }

    });

  }

  String _DateText(int position) {
    if (widget.myEvent[position].time.month == 1){
      return '${widget.myEvent[position].time.day.toString()}' + '. ' + 'Januar';
    }
    else if (widget.myEvent[position].time.month == 2){
      return '${widget.myEvent[position].time.day.toString()}' + '. ' + 'Februar';
    }
    else if (widget.myEvent[position].time.month == 3){
      return '${widget.myEvent[position].time.day.toString()}' + '. ' + 'Mars';
    }
    else if (widget.myEvent[position].time.month == 4){
      return '${widget.myEvent[position].time.day.toString()}' + '. ' + 'April';
    }
    else if (widget.myEvent[position].time.month == 5){
      return '${widget.myEvent[position].time.day.toString()}' + '. ' + 'Mai';
    }
    else if (widget.myEvent[position].time.month == 6){
      return '${widget.myEvent[position].time.day.toString()}' + '. ' + 'Juni';
    }
    else if (widget.myEvent[position].time.month == 7){
      return '${widget.myEvent[position].time.day.toString()}' + '. ' + 'Juli';
    }
    else if (widget.myEvent[position].time.month == 8){
      return '${widget.myEvent[position].time.day.toString()}' + '. ' + 'August';
    }
    else if (widget.myEvent[position].time.month == 9){
      return '${widget.myEvent[position].time.day.toString()}' + '. ' + 'September';
    }
    else if (widget.myEvent[position].time.month == 10){
      return '${widget.myEvent[position].time.day.toString()}' + '. ' + 'Oktober';
    }
    else if (widget.myEvent[position].time.month == 11){
      return '${widget.myEvent[position].time.day.toString()}' + '. ' + 'November';
    }
    else if (widget.myEvent[position].time.month == 12){
      return '${widget.myEvent[position].time.day.toString()}' + '. ' + 'Desember';
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
