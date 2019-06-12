import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smidigprosjekt/bottomNavigation/third_tab/create_or_search.dart';
import 'package:smidigprosjekt/objects/group.dart';
import 'package:smidigprosjekt/objects/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smidigprosjekt/service/styles.dart';
import 'package:smidigprosjekt/utils/uidata.dart';
import 'package:smidigprosjekt/service/service_provider.dart';
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

class MyPainter extends CustomPainter {
  Color lineColor;
  Color completeColor;
  double completePercent;
  double width;
  MyPainter(
      {this.lineColor, this.completeColor, this.completePercent, this.width});

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

    Offset center = new Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2, size.height / 2);
    canvas.drawCircle(center, radius, line);

    double arcAngle = 2 * pi * (completePercent / 100);

    canvas.drawArc(new Rect.fromCircle(center: center, radius: radius), -pi / 2,
        arcAngle, false, complete);
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
  double newPercentage;
  String activeChallenge = "";
  AnimationController percentageAnimationController;

  final _controller = TextEditingController();
  var dbUrl;

  File imgUrl;

  Firestore firestoreInstance = Firestore.instance;

  bool choosen = false;

  int index;

  bool isLoading = true;

  Group _group;

  List<User> groupMembers = <User>[];

  QuerySnapshot qSnapChallenge;

  var names;

  @override
  void initState() {
    super.initState();
    groupMembers.add(widget.user);
    _getGroup();
    _tabController = new TabController(vsync: this, length: 3);
    setState(() {
      //percentage = 0.0;
    });

    percentageAnimationController = new AnimationController(
        vsync: this, duration: new Duration(milliseconds: 1000))
      ..addListener(() {
        setState(() {
          percentage = lerpDouble(
              percentage, newPercentage, percentageAnimationController.value);
        });
      });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  _getGroup() async {
    DocumentSnapshot docSnap =
        await firestoreInstance.document("groups/${widget.user.groupId}").get();
    if (docSnap.exists) {
      _group = Group(
          name: docSnap.data["name"],
          id: docSnap.documentID,
          members: [],
          memberAmount: docSnap.data["members"]);
      _group.members = [];
      QuerySnapshot qSnap = await firestoreInstance
          .collection("groups/${widget.user.groupId}/members")
          .getDocuments();
      qSnap.documents.forEach((d) => _group.members.add(User(
            id: d.data["id"],
            userName: d.data["name"],
            school: d.data["school"],
            program: d.data["program"],
        profileImage: d.data["profileImage"]

          )));
    } else {
      widget.user.introChoice = IntroChoice.search;
    }

    setState(() {
      isLoading = false;
    });

    await firestoreInstance
        .document("groups/${_group.id}")
        .updateData({"memberamount": _group.members.length});

    _getChallenges();
  }

  _getChallenges() async {
    qSnapChallenge = await Firestore.instance
        .collection("groups/${_group.id}/challenges")
        .getDocuments();
    if (qSnapChallenge.documents.isEmpty) {
      print("Empty");
      _createChallenges();
    }
  }

  _createChallenges() {
    var db = Firestore.instance;
    db
        .collection("groups/${_group.id}/challenges")
        .document("utfordring1")
        .setData({
      "id": 0,
      "challenge": "Ta en kaffe sammen",
      "isDone": false,
      "prosent": 0.0,
      "activeChallange": "Ta en kaffe sammen"
    });
    db
        .collection("groups/${_group.id}/challenges")
        .document("utfordring2")
        .setData({"id": 1, "challenge": "Grille i parken", "isDone": false});
    db
        .collection("groups/${_group.id}/challenges")
        .document("utfordring3")
        .setData({
      "id": 2,
      "challenge": "Velg film sammen og dra på kino",
      "isDone": false
    });
    db
        .collection("groups/${_group.id}/challenges")
        .document("utfordring4")
        .setData({"id": 3, "challenge": "Dra på Syng sammen", "isDone": false});
    db
        .collection("groups/${_group.id}/challenges")
        .document("utfordring5")
        .setData({"id": 4, "challenge": "4 stjerners middag", "isDone": false});
  }

  @override
  Widget build(BuildContext context) {
    var db = Firestore.instance;
    List<double> proList = [
      0.0,
      20.0,
      40.0,
      60.0,
      80.0,
      100.0,
    ];
    List<String> taskList = [
      "Ta en kaffe sammen",
      "Grille i parken",
      "Velg film sammen og dra på kino",
      "Dra på Syng sammen",
      "4 stjerners middag",
      "Dere har ingen flere utfordringer"
    ];

    void itemChange(bool val, int index) {
      setState(() {
        inputs[index] = val;
        if (inputs[index] = true) {
          if (index == 4) {
            percentage = proList[5];
            activeChallenge = "Dere har ingen flere utfordringer";
            db.collection("groups/${_group.id}/challenges")
                .document("utfordring" + "${index + 1}")
                .updateData({"isDone": true});
            db.collection("groups/${_group.id}/challenges")
                .document("utfordring1")
                .updateData({"prosent": percentage, "activeChallange": activeChallenge});
          } else {
            activeChallenge = taskList[index + 1];
            percentage = proList[index + 1];
            db
                .collection("groups/${_group.id}/challenges")
                .document("utfordring" + "${index + 1}")
                .updateData({"isDone": true});
            db
                .collection("groups/${_group.id}/challenges")
                .document("utfordring1")
                .updateData({
              "prosent": percentage,
              "activeChallange": activeChallenge
            });
          }
        }
      });
    }

    queryData = MediaQuery.of(context);

    if (isLoading)
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );

    if (widget.user.introChoice == IntroChoice.search)
      return CreateOrSearchPage(
          groupMembers: groupMembers,
          user: widget.user,
          onDone: () async {
            setState(() {
              isLoading = true;
            });
            _group = Group(
                name: "Min gruppe",
                id: null,
                memberAmount: groupMembers.length,
                members: groupMembers);
            DocumentReference docRef = await firestoreInstance
                .collection("groups")
                .add(_group.toJson());
            _group.members.forEach((m) {
              firestoreInstance
                  .collection("groups/${docRef.documentID}/members")
                  .add(m.toJson());
            });
            setState(() {
              isLoading = false;
              widget.user.introChoice = IntroChoice.assigned;
            });
          });

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
                title: new Text(
                  _group.name,
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
                            itemCount: _group.members.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Card(
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(70),
                                            side: _group.members[index].userName
                                                    .contains(
                                                        widget.user.userName)
                                                ? BorderSide(
                                                    color: UIData.pink,
                                                    width: 2)
                                                : BorderSide(
                                                    color: Colors.white)),
                                        //decoration: BoxDecoration(borderRadius: BorderRadius.circular(60), border: index == 0 ? Border.all(width: 3, color: UIData.pink) : Border.all(color: Colors.white) ),
                                        child: ClipRRect(
                                          borderRadius:
                                              new BorderRadius.circular(80),
                                          child: _group.members[index].profileImage != null ?
                                           Image.network(
                                        _group.members[index].profileImage,
                                          //widget.user.profileImage,
                                          width: 42,
                                          height: 42,
                                          fit: BoxFit.cover,
                                        )
                                              : Image.asset(
                                                  //_group.members[index].profileImage, // fra list [index]
                                                  "lib/assets/images/profilbilde.png",

                                                  width: 42,
                                                  height: 42,
                                                  fit: BoxFit.cover,
                                                ),
                                        ),
                                      ),
                                      _group.members[index].userName.contains(widget.user.userName) ? Text("Meg", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))
                                          : Text("${_getFirstName(index)}", style: TextStyle(fontSize: 11),),
                                    ]),
                              );
                            },
                          ),
                        ),
                      ),
                      Padding(padding: EdgeInsets.all(4)),
                      new Container(
                        decoration: const BoxDecoration(
                          border: Border(
                              top: BorderSide(width: 0.4, color: UIData.black)),
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
            body: TabBarView(controller: _tabController, children: [
              new SingleChildScrollView(
                child: StreamBuilder(
                    stream: Firestore.instance
                        .collection("groups")
                        .document("${_group.id}")
                        .collection("challenges")
                        //document("groups/${_group.id}/challenges")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return Container();
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          new Padding(
                            padding: EdgeInsets.only(top: 30),
                          ),
                          new Center(
                            child: new Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                new Padding(
                                  padding: EdgeInsets.only(left: 45),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      new Text(
                                        "Neste utfordring:",
                                        textAlign: TextAlign.left,
                                        style: new TextStyle(
                                          color: UIData.black,
                                          fontFamily: 'Anton',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      new Padding(
                                        padding: EdgeInsets.only(bottom: 5),
                                      ),
                                      new Text(
                                        snapshot.data.documents[0]
                                            .data["activeChallange"],
                                        textAlign: TextAlign.left,
                                        style: new TextStyle(
                                            color: UIData.black,
                                            fontFamily: 'Anton'),
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
                                        completePercent: snapshot.data
                                                .documents[0].data["prosent"] +
                                            .0,
                                        width: 15.0),
                                    child: new Padding(
                                        padding: const EdgeInsets.all(30.0),
                                        child: new FlatButton(
                                            color: UIData.grey,
                                            splashColor: Color(0x00FFFFFF),
                                            shape: new CircleBorder(),
                                            child: new Text((snapshot
                                                        .data
                                                        .documents[0]
                                                        .data["prosent"])
                                                    .toStringAsFixed(0) +
                                                "%"),
                                            onPressed: () {})),
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
                          width: ServiceProvider.instance.screenService
                              .getPortraitWidthByPercentage(context, 80),
                          height: ServiceProvider.instance.screenService
                              .getHeightByPercentage(context, 38),
                          color: Colors.white,
                          child: new ListView.builder(
                              itemCount: 5,
                              itemBuilder: (context, int index) {
                                DocumentSnapshot document =
                                snapshot.data.documents[index];
                              inputs[index] = document.data["isDone"];
                              //percentage = document.data["prosent"] + .0;


                                return new Column(children: [
                                  new Padding(
                                    padding: EdgeInsets.only(top: 5),
                                  ),
                                  new CheckboxListTile(
                                      value: inputs[index],
                                      title: new Text(taskList[index],
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontFamily: "Anton")),
                                      activeColor: UIData.blue,
                                      controlAffinity:
                                          ListTileControlAffinity.trailing,
                                      onChanged: (bool val) {

                                        //if (inputs[index] == true) {
                                        if(inputs[index] == true) {


                                        } else {
                                          itemChange(val, index);
                                          setState(() {
                                            percentage = newPercentage;

                                            newPercentage -=
                                                100 / taskList.length;
                                            if (newPercentage < 0) {
                                              percentage = 0.0;
                                              newPercentage = 0.0;
                                            }
                                            percentageAnimationController
                                                .reverse(from: 100.0);
                                          });
                                        }
                                      })
                                ]);
                              }),
                        )),
                    new Divider(
                      color: UIData.grey,
                      height: 20,
                    ),

                  ],
                );}),

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
                            .collection("groups/${_group.id}/chat_room")
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
                              if (document['user_name'] ==
                                  widget.user.getName()) {
                                isOwnMessage = true;
                              }
                              return isOwnMessage
                                  ? _ownMessage(
                                      document['message'],
                                      document['user_name'],
                                      document['image'],
                                      document['isText'])
                                  : _message(
                                      document['message'],
                                      document['user_name'],
                                      document['image'],
                                      document['profileImage'],
                                      document['isText']);
                            },
                            itemCount: snapshot.data.documents.length,
                          );
                        },
                      ),
                    ),
                    new Divider(height: 1.0),
                    choosen
                        ? Container(
                            margin: EdgeInsets.only(
                                bottom: 10.0,
                                top: 10.0,
                                right: 10.0,
                                left: 10.0),
                            child: Row(
                              //mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Stack(alignment: Alignment.topRight, children: <
                                    Widget>[
                                  Padding(
                                      padding: EdgeInsets.all(10),
                                      child: ClipRRect(
                                          borderRadius:
                                              new BorderRadius.circular(8.0),
                                          child: Container(
                                              width: 100,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Image.file(
                                                imgUrl,
                                                fit: BoxFit.fill,
                                              )))),
                                  Container(
                                      margin: EdgeInsets.only(right: 2, top: 2),
                                      height: 30,
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: FloatingActionButton(
                                          elevation: 1,
                                          mini: true,
                                          backgroundColor: Colors.white,
                                          foregroundColor: UIData.black,
                                          onPressed: () {
                                            setState(() {
                                              choosen = false;
                                            });
                                          },
                                          child: Icon(Icons.clear,
                                              color: UIData.black),
                                        ),
                                      ))
                                ]),
                                FlatButton(
                                    child: Icon(Icons.send,
                                        color: UIData.pink, size: 24),
                                    onPressed: () {
                                      uploadImage(imgUrl);
                                      setState(() {
                                        choosen = false;
                                      });
                                    })
                              ],
                            ),
                          )
                        : Container(
                            height: 50,
                            margin: EdgeInsets.only(
                                bottom: 10.0,
                                top: 10.0,
                                right: 10.0,
                                left: 10.0),
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
                                            contentPadding: EdgeInsets.all(0),
                                            hintText: "Skriv noe..",
                                            fillColor: Colors.white,
                                            filled: true,
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                borderSide: BorderSide(
                                                    width: 0,
                                                    style: BorderStyle.none)),
                                            prefixIcon: IconButton(
                                                icon: Icon(Icons.camera_alt,
                                                    color: UIData.blue,
                                                    size: 30),
                                                onPressed: () {
                                                  openOptions();
                                                }),
                                            suffixIcon: IconButton(
                                                icon: Icon(Icons.send,
                                                    color: UIData.pink,
                                                    size: 24),
                                                onPressed: () {
                                                  _handleSubmit(
                                                      _controller.text);
                                                }))))
                              ],
                            ))
                  ],
                ),
              )
            ])));
  }

  Widget _ownMessage(
      String message, String userName, String image, bool isText) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            isText
                ? Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    child: ClipRRect(
                        borderRadius: new BorderRadius.circular(8.0),
                        child: new Container(
                            color: UIData.pink,
                            constraints: BoxConstraints(
                                minWidth: 0,
                                maxWidth: ServiceProvider.instance.screenService
                                    .getPortraitWidthByPercentage(context, 50)),
                            padding: EdgeInsets.only(
                                left: 10, right: 10, top: 6, bottom: 6),
                            child: Text(message,
                                style: TextStyle(color: Colors.white)))))
                : Padding(
                    padding: EdgeInsets.only(bottom: 10, top: 10),
                    child: GestureDetector(
                        child: ClipRRect(
                            borderRadius: new BorderRadius.circular(8.0),
                            child: Container(
                                constraints: BoxConstraints(
                                    minWidth: 0,
                                    maxWidth: ServiceProvider
                                        .instance.screenService
                                        .getPortraitWidthByPercentage(
                                            context, 50)),
                                child:
                                    Image.network(image, fit: BoxFit.cover))),
                        onTap: () {
                          _showImage(image);
                        }),
                  )
          ],
        ),
        Card(
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(70)),
          child: ClipRRect(
            borderRadius: new BorderRadius.circular(100),
            child: Image.network(
              widget.user.profileImage, // fra list [index]
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
    var fullnames = userName;
    var split = fullnames.split(' ');
    String firstName = split[0];
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Card(
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(70)),
          child: ClipRRect(
            borderRadius: new BorderRadius.circular(100),
            child: Image.asset(
              "lib/assets/images/profilbilde.png", // fra list [index]
              height: 40,
              width: 40,
              fit: BoxFit.cover,
            ),
          ),
        ), 
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              firstName,
              style: TextStyle(fontSize: 11, color: Colors.grey)
            ),
            isText
                ? Padding(
                    padding: EdgeInsets.only(top: 2, bottom: 10),
                    child: ClipRRect(
                        borderRadius: new BorderRadius.circular(8.0),
                        child: new Container(
                            color: Colors.white,
                            constraints: BoxConstraints(
                                minWidth: 0,
                                maxWidth: ServiceProvider.instance.screenService
                                    .getPortraitWidthByPercentage(context, 50)),
                            padding: EdgeInsets.only(
                                left: 10, right: 10, top: 6, bottom: 6),
                            child: Text(message,
                                style: TextStyle(color: UIData.black)))))
                : Padding(
                    padding: EdgeInsets.only(bottom: 10, top: 10),
                    child: GestureDetector(
                        child: ClipRRect(
                          borderRadius: new BorderRadius.circular(8.0),
                          child: Container(
                              constraints: BoxConstraints(
                                  minWidth: 0,
                                  maxWidth: ServiceProvider
                                      .instance.screenService
                                      .getPortraitWidthByPercentage(
                                          context, 50)),
                              child: Image.network(image, fit: BoxFit.cover)),
                        ),
                        onTap: () {
                          _showImage(image);
                        }),
                  ),
          ],
        )
      ],
    );
  }

  _showImage(String image) {
    showDialog(
        context: context,
        barrierDismissible: true,
        child: Stack(
          children: <Widget>[
            Center(
                child: Padding(
              padding: EdgeInsets.all(10),
              child: Image.network(image),
            )),
            Container(
                margin: EdgeInsets.only(left: 10, top: 10),
                height: 30,
                child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: FloatingActionButton(
                        elevation: 1,
                        mini: false,
                        backgroundColor: Colors.white,
                        foregroundColor: UIData.black,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child:
                            Icon(Icons.clear, color: UIData.black, size: 40))))
          ],
        ));
  }

  _handleSubmit(String message) {
    if (_controller.text.trim().isEmpty) {
    } else {
      _controller.text = "";
      var db = Firestore.instance;
      db.collection("groups/${_group.id}/chat_room").add({
        "user_name": widget.user.getName(),
        "message": message.trim(),
        "image": "",
        "profileImage": "",
        "isText": true,
        "created_at": DateTime.now()
      }).then((val) {
        print("success");
      }).catchError((err) {
        print(err);
      });
    }
  }

  _sendImage(String dbUrl) {
    var db = Firestore.instance;
    db.collection("groups/${_group.id}/chat_room").add({
      "user_name": widget.user.getName(),
      "image": dbUrl,
      "message": "",
      "profileImage": "",
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

  String _getFirstName(int index) {
    var fullnames = _group.members[index].userName;
    var split = fullnames.split(' ');
    String firstName = split[0];
    return firstName;
  }

  Future openCamera() async {
    var picture = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      imgUrl = picture;
      choosen = true;
    });
    dbUrl = picture.path.toString();
    Navigator.of(context, rootNavigator: true).pop();
  }

  Future openGallery() async {
    var gallery = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      imgUrl = gallery;
      choosen = true;
    });
    dbUrl = gallery.path.toString();
    Navigator.of(context, rootNavigator: true).pop();
  }

  void uploadImage(imgUrl) async {
    final StorageReference imgRef =
        FirebaseStorage.instance.ref().child("${_group.id}/Chat_Images");
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
}
