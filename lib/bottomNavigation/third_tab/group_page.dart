import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smidigprosjekt/objects/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smidigprosjekt/utils/uidata.dart';
import 'package:smidigprosjekt/service/service_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';
import 'dart:math';


class GroupPage extends StatefulWidget {
  GroupPage({
    this.user,
  });
  final User user;
  @override
  _GroupPageState createState() => _GroupPageState();
}

class MyPainter extends CustomPainter{

  Color lineColor;
  Color completeColor;
  double completePercent;
  double width;
  MyPainter({this.lineColor,this.completeColor,this.completePercent,this.width});

  @override
  void paint(Canvas canvas, Size size) {
    Paint line = new Paint()
        ..color = lineColor
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke
        ..strokeWidth = width;
    Paint complete = new Paint()
      ..color = completeColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;

    Offset center  = new Offset(size.width/2, size.height/2);
    double radius  = min(size.width/2,size.height/2);
    canvas.drawCircle(
        center,
        radius,
        line
    );

    double arcAngle = 2*pi* (completePercent/100);

    canvas.drawArc(
        new Rect.fromCircle(center: center,radius: radius),
        -pi/2,
        arcAngle,
        false,
        complete
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class _GroupPageState extends State<GroupPage> with TickerProviderStateMixin {

  TabController _tabController;
  MediaQueryData queryData;
  List<bool> inputs = [false, false, false, false, false];
  double percentage = 0.0;
  double newPercentage = 0.0;
  String activeChallenge = "";
  AnimationController percentageAnimationController;

  final _controller = TextEditingController();
  var dbUrl;

  File imgUrl;

  bool choosen = false;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 3);
    setState(() {
        percentage = 0.0;
    });

    percentageAnimationController = new AnimationController(
      vsync: this,
      duration: new Duration(milliseconds: 1000)
    )
    ..addListener((){
      setState(() {
        percentage = lerpDouble(percentage,newPercentage,percentageAnimationController.value);
      });
    });

  }


  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<String> taskList = [
      "Ta en kaffe sammen",
      "Grille i parken",
      "Velg film sammen og dra på kino",
      "Dra på Syng sammen",
      "4 stjerners middag"
    ];

  if(inputs[4]==true){
    activeChallenge = "Dere har ingen utfordringer igjen!";
  }
  if(inputs[4]==false){
    activeChallenge = taskList[4];
  }
  if(inputs[3]==false){
    activeChallenge = taskList[3];
  }
  if(inputs[2]==false){
    activeChallenge = taskList[2];
  }
  if(inputs[1]==false){
    activeChallenge = taskList[1];
  }
  if(inputs[0]==false){
    activeChallenge = taskList[0];
  }

 
void itemChange(bool val,int index){
  setState(() {
    inputs[index] = val;
  });
}
    
    queryData = MediaQuery.of(context);
    return GestureDetector(
      onTap: () {
        this._removeKeyboard(context);
      },
      child: new Scaffold(

        backgroundColor: UIData.grey,
        appBar: new AppBar(
            elevation: 1,
            backgroundColor: Colors.white,
            centerTitle: true,
            title:  new Text(
                    "Min gruppe",
                    style: ServiceProvider.instance.styles.title(),
            ),

            bottom: PreferredSize(
              preferredSize:
                  Size(queryData.size.width, queryData.size.height / 6),
              child: new Column(
                children: <Widget>[

                  new Center(
                   child: new SizedBox(
                     height: 70,

                    child: ListView.builder(
                    itemCount: 5,  //list.lenght
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                    return Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(70), side: index == 0 ? BorderSide(color: UIData.pink, width: 2) : BorderSide(color: Colors.white)),
                      //decoration: BoxDecoration(borderRadius: BorderRadius.circular(60), border: index == 0 ? Border.all(width: 3, color: UIData.pink) : Border.all(color: Colors.white) ),
                      child: ClipRRect(
                        borderRadius: new BorderRadius.circular(70),
                        child: Image.asset("lib/assets/images/fortnite.jpg", // fra list [index]

                          width: 62,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },


                ),

              ),
              ),
                  Padding(
                    padding: EdgeInsets.all(4)
                  ),



                  new Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(width: 0.4, color: UIData.black)
                      ),
                      color: Colors.white,
                    ),
                    child: TabBar(
                      labelColor: Colors.grey[800],
                      indicatorColor: UIData.black,
                      labelStyle: new TextStyle(color: Colors.black),
                      controller: _tabController,
                      tabs: [
                        Tab(
                          child: new Text(
                            "Utfordringer",
                            style: new TextStyle(
                                color: Colors.black, fontFamily: 'Anton'),
                          ),
                        ),
                        Tab(
                          child: new Text(
                            "Events",
                            style: new TextStyle(
                                color: Colors.black, fontFamily: 'Anton'),
                          ),
                        ),
                        Tab(
                          child: new Text(
                            "Chat",
                            style: new TextStyle(
                                color: Colors.black, fontFamily: 'Anton'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
        body: TabBarView(
          controller: _tabController,
          children: [
            
            new SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children:[
                  new Padding(
                    padding: EdgeInsets.only(top: 30),
                  ),
                  new Center(
                    child: new Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:[
                        new Padding(
                          padding: EdgeInsets.only(left: 45),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:[

                              new Text(
                                "Neste utfordring:",
                                textAlign: TextAlign.left,
                                style: new TextStyle(
                                    color: UIData.black, fontFamily: 'Anton', fontWeight: FontWeight.bold,
                                ),
                              ),
                              new Padding(
                                padding: EdgeInsets.only(bottom: 5),
                              ),
                              new Text(
                                activeChallenge,
                                textAlign: TextAlign.left,
                                style: new TextStyle(
                                    color: UIData.black, fontFamily: 'Anton'
                                ),
                              ),
                            ],
                          ),
                        ),


                        new Padding(
                          padding: EdgeInsets.only(right: 10),
                        ),

                        /*
                     *
                     * Percentage indicator here
                     *
                     */
                        new Container(

                          child: new CustomPaint(
                            foregroundPainter: new MyPainter(
                                lineColor: UIData.lightPink,
                                completeColor: UIData.pink,
                                completePercent: percentage,
                                width: 15.0
                            ),
                            child: new Padding(
                                padding: const EdgeInsets.all(30.0),
                                child: new FlatButton(
                                    color: UIData.grey,
                                    splashColor: Color(0x00FFFFFF),
                                    shape: new CircleBorder(),
                                    child: new Text(percentage.toStringAsFixed(0)+"%"),
                                    onPressed:(){})
                            ),
                          ),
                        ),
                        /*
                     *
                     * Percentage indicator Ends here
                     *
                     */
                        new Padding(
                          padding: EdgeInsets.only(right: 35),
                        ),

                      ], // Text and meter row children
                    ),
                  ),

                  new Padding(
                    padding: EdgeInsets.only(top: 30),
                  ),

                  new ClipRRect(

                      borderRadius: new BorderRadius.circular(8.0),
                      child: new Container(
                        width:  ServiceProvider.instance.screenService.getPortraitWidthByPercentage(context, 80),
                        height: ServiceProvider.instance.screenService.getHeightByPercentage(context, 38),
                        color: Colors.white,

                        child: new ListView.builder(
                            itemCount: taskList.length,
                            itemBuilder: (context, int index) {
                              return new Column(
                                  children: [
                                    new Padding(
                                      padding: EdgeInsets.only(top: 5),
                                    ),
                                    new CheckboxListTile(
                                        value: inputs[index],
                                        title: new Text(taskList[index], style: TextStyle(fontSize: 15, fontFamily: "Anton")),
                                        activeColor: UIData.blue,
                                        controlAffinity: ListTileControlAffinity.trailing,
                                        onChanged:(bool val){itemChange(val, index);
                                        if(inputs[index]==true) {
                                          setState(() {
                                            percentage = newPercentage;
                                            newPercentage += 100 / taskList.length;
                                            if(newPercentage>100.0){
                                              percentage=100.0;
                                              newPercentage=100.0;
                                            }
                                            percentageAnimationController.forward(from: 0.0);
                                          });}
                                        else {
                                          setState(() {
                                            percentage = newPercentage;

                                            newPercentage -= 100 / taskList.length;
                                            if(newPercentage<0){
                                              percentage=0.0;
                                              newPercentage=0.0;
                                            }
                                            percentageAnimationController.reverse(from: 100.0);
                                          });}
                                        }
                                    )
                                  ]
                              );
                            }
                        ),
                      )
                  ),
                  new Divider(
                    color: UIData.grey,
                    height: 20,
                  ),
                ],

              ),
            ),

            new Stack(
              children: <Widget>[

                    new Center(
                      child: new Text("Dere har ingen felles events enda"),
                    ),
                  ],
                ),

            Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: <Widget>[
              Flexible(
                child: StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance
                      .collection("chat_room")
                      .orderBy("created_at", descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return Container();
                    return new ListView.builder(
                      padding: new EdgeInsets.all(8.0),
                      reverse: true,
                      itemBuilder: (_, int index) {
                        DocumentSnapshot document =
                        snapshot.data.documents[index];

                        bool isOwnMessage = false;
                        if (document['user_name'] == widget.user.getName()) {
                          isOwnMessage = true;
                        }
                        return isOwnMessage
                            ? _ownMessage(
                            document['message'],  document['user_name'], document['image'], document['isText'])
                            : _message(
                            document['message'], document['user_name'], document['image'], document['isText']);
                      },
                      itemCount: snapshot.data.documents.length,
                    );
                  },
                ),
              ),
              new Divider(height: 1.0),
              choosen?
              Container(
                
                margin: EdgeInsets.only(bottom: 10.0, top: 10.0, right: 10.0, left: 10.0),
                
                child: Row(
                  //mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    
                    Stack(
                      children: <Widget>[
                        Padding(
                          padding:EdgeInsets.all(10),
                          child: ClipRRect(
                            borderRadius: new BorderRadius.circular(8.0),
                            child: Container(
                              width: 100,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),),
                              child: Image.file(
                                imgUrl,
                                fit: BoxFit.fill,
                              )
                            )
                          )
                        ),
                          Container(
                            margin:EdgeInsets.only(right:2, top:2),
                            height: 30,
                            child: Align(
                              alignment: Alignment.topRight,
                              child: FittedBox(
                              child:FloatingActionButton(
                                elevation: 1,
                                mini: true,
                                backgroundColor: Colors.white,
                                foregroundColor: UIData.black,
                                onPressed: (){
                                  setState((){
                                    choosen = false;
                                  });
                                },
                                child: Icon(Icons.clear, color: UIData.black),
                              ),
                            )
                            ),
                            
                          ), 
                      ]
                    ),
                    FlatButton(
                      child: Icon(Icons.send, color: UIData.pink, size: 24),
                      onPressed: (){ 
                        uploadImage(imgUrl);
                        setState((){
                          choosen=false;
                        });
                      } 
                    )
                  ],
                ),
              )
              :

            Container(
                margin: EdgeInsets.only(bottom: 10.0,top:10.0, right: 10.0, left: 10.0), 
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                        new Flexible(
                      child: new TextField(
                        controller: _controller,
                        onSubmitted: _handleSubmit,
                        minLines: 1,
                        maxLines: null,
                        decoration: InputDecoration(
                          hintText: "Skriv noe..",
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(width: 0, style: BorderStyle.none)),
                          prefixIcon: IconButton(
                            icon: Icon(Icons.camera_alt, color: UIData.blue, size: 30),
                            onPressed: () {
                              openOptions();
                            }
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.send, color: UIData.pink, size: 24),
                            onPressed: () {
                              _handleSubmit(_controller.text);
                            }
                          )
                        )
                      )
                    )   
                  ],
                )
              )
            
            ],
          ),
        )
      ]
    )
    )
    );
  }

  Widget _ownMessage(String message, String userName, String image, bool isText) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            isText?
            Padding(
              padding: EdgeInsets.only(top:10, bottom:10),
              child: ClipRRect(
                borderRadius: new BorderRadius.circular(8.0),
                child: new Container(
                  color: UIData.pink,
                  constraints: BoxConstraints(minWidth: 0, maxWidth: ServiceProvider.instance.screenService.getPortraitWidthByPercentage(context, 50)),
                  padding: EdgeInsets.only(left:10, right:10, top:6, bottom:6),
                  child: Text(message, style: TextStyle(color: Colors.white))
                )
              )
            )
             
            :

            Padding(
              padding: EdgeInsets.only(bottom: 10, top:10),
              child: ClipRRect(
              borderRadius: new BorderRadius.circular(8.0),
                child: Container(
                  constraints: BoxConstraints(minWidth: 0, maxWidth: ServiceProvider.instance.screenService.getPortraitWidthByPercentage(context, 50)),
                  child: Image.network(
                    image,
                    fit: BoxFit.cover
                  )
                ) 
              )
            )
            
          ],
        ),
        Card(
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(70)),
              child: ClipRRect(
                borderRadius: new BorderRadius.circular(100),
                child: Image.asset("lib/assets/images/fortnite.jpg", // fra list [index]
                  height: 40,
                  width: 40,
                  fit: BoxFit.cover,
                ),
              ),
            ),
      ],
    );
  }

  Widget _message(String message, String userName, String image, bool isText) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(70)),
              child: ClipRRect(
                borderRadius: new BorderRadius.circular(100),
                child: Image.asset("lib/assets/images/fortnite.jpg", // fra list [index]
                  height: 40,
                  width: 40,
                  fit: BoxFit.cover,
                ),
              ),
            ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            isText?
            Padding(
              padding: EdgeInsets.only(top:10, bottom:10),
              child: ClipRRect(
                borderRadius: new BorderRadius.circular(8.0),
                child: new Container(
                  color: Colors.white,
                  constraints: BoxConstraints(minWidth: 0, maxWidth: ServiceProvider.instance.screenService.getPortraitWidthByPercentage(context, 50)),
                  padding: EdgeInsets.only(left:10, right:10, top:6, bottom:6),
                  child: Text(message, style: TextStyle(color: UIData.black))
                )
              )
            )
             
            :

            Padding(
              padding: EdgeInsets.only(bottom: 10, top:10),
              child: ClipRRect(
              borderRadius: new BorderRadius.circular(8.0),
                child: Container(
                  constraints: BoxConstraints(minWidth: 0, maxWidth: ServiceProvider.instance.screenService.getPortraitWidthByPercentage(context, 50)),
                  child: Image.network(
                    image,
                    fit: BoxFit.cover
                  )
                ) 
              )
            )
          ],
        )
      ],
    );
  }

  _handleSubmit(String message) {
    if(_controller.text.trim().isEmpty){}
    else{
    _controller.text = "";
    var db = Firestore.instance;
    db.collection("chat_room").add({
      "user_name": widget.user.getName(),
      "message": message.trim(),
      "image": "",
      "isText": true,
      "created_at": DateTime.now()
    }).then((val) {
      print("success");
    }).catchError((err) {
      print(err);
    });
    }
  }

  _sendImage (String dbUrl){
    var db = Firestore.instance;
    db.collection("chat_room").add({
      "user_name": widget.user.getName(),
      "image": dbUrl,
      "message": "",
      "isText": false,
      "created_at": DateTime.now()
    }).then((val) {
      print("success");
    }).catchError((err) {
      print(err);
    });
  }

  void _removeKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(new FocusNode());
  }
  Future openCamera() async {
    var picture = await ImagePicker.pickImage(
        source: ImageSource.camera );
      setState((){
        imgUrl = picture;
        choosen = true;
    });
    dbUrl = picture.path.toString();
    Navigator.of(context, rootNavigator: true).pop();
  }

  Future openGallery() async {
    var gallery = await ImagePicker.pickImage(
        source: ImageSource.gallery);
      setState((){
        imgUrl = gallery;
        choosen = true;
    });
    dbUrl = gallery.path.toString();
    Navigator.of(context, rootNavigator: true).pop();
  }

void uploadImage(imgUrl) async {

    final StorageReference imgRef = FirebaseStorage.instance.ref().child("Chat_Images");
    var timeKey = new DateTime.now();
    final StorageUploadTask upTask = imgRef.child(timeKey.toString() + ".jpg").putFile(imgUrl);
    var url = await (await upTask.onComplete).ref.getDownloadURL();
    dbUrl = url.toString();
    print("DBURL AFTER UPLOAD:" + dbUrl);
    _sendImage(dbUrl);
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




