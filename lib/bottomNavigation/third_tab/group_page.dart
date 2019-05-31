import 'package:flutter/material.dart';
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
      "Lorem ipsum",
      "Lorem ipsum 2",
      "Lorem ipsum 3",
      "Dra på Syng sammen",
      "Lorem ipsum 4"
    ];

  if(inputs[4]==true){
    activeChallenge = "Du har ingen utfordringer igjen!";
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
    return new Scaffold(
        backgroundColor: UIData.grey,
        appBar: new AppBar(
            elevation: 2,
            backgroundColor: Colors.white,
            centerTitle: true,
            title: new Text(
              "Min gruppe",
              style: new TextStyle(
                fontFamily: 'Anton', fontSize: 24, color: Colors.black),
            ),
            bottom: PreferredSize(
              preferredSize:
                  Size(queryData.size.width, queryData.size.height / 6),
              child: new Column(
                children: <Widget>[
                  new Row(),
                  new Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(width: 0.4, color: UIData.black)
                      ),
                      color: Colors.white,
                    ),
                    child: TabBar(
                      labelColor: Colors.grey[800],
                      indicatorColor: UIData.lightBlue,
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
                    padding: EdgeInsets.only(top: 50),
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
                                    color: UIData.black, fontFamily: 'Anton'
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
                    padding: EdgeInsets.only(top: 50),
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
                                        title: new Text(taskList[index]),
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

            new Text("EVENTADO"),
            new Text("CHATAROO"),
          ],
        ));
  }
}

