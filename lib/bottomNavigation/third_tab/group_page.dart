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
  double bufferPercentage = 0.0;
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
      "Oppgave 1",
      "Oppgave 2",
      "Oppgave 3",
      "Oppgave 4",
      "Oppgave 5"
    ];

 
void itemChange(bool val,int index){
  setState(() {
    inputs[index] = val;
  });
}
    
    queryData = MediaQuery.of(context);
    return new Scaffold(
        backgroundColor: UIData.grey,
        appBar: new AppBar(
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.settings,
                  color: Colors.black,
                ),
                onPressed: null,
              )
            ],
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
            new Column(
              crossAxisAlignment: CrossAxisAlignment.center, 
              children:[
                new Padding(
                  padding: EdgeInsets.only(top: 20),
                ),
                new Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children:[
                    new Column(
                      children:[
                        new Text(
                          "Ukens utfordring:",
                          textAlign: TextAlign.left,
                          style: new TextStyle(
                            color: UIData.black, fontFamily: 'Anton'
                          ),
                        ),
                        new Text(
                          "Lorem ipsum dolor sit amet\n,consectetur adipiscing elit, sed",
                          textAlign: TextAlign.left,
                          style: new TextStyle(
                            color: UIData.black, fontFamily: 'Anton'
                          ),
                        ),
                      ],
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
                onPressed:(){})),
                      ),
                    )
                    /*
                     * 
                     * Percentage indicator Ends here
                     * 
                     */

                  ], // Text and meter row children 
                ),
                new Padding(
                  padding: EdgeInsets.only(top: 20),
                ),

                new ClipRRect(
                  borderRadius: new BorderRadius.circular(8.0),
                  child: new Container(
                    width:  ServiceProvider.instance.screenService.getPortraitWidthByPercentage(context, 85),
                    height: ServiceProvider.instance.screenService.getHeightByPercentage(context, 42),
                    color: Colors.white,
                    child: new ListView.builder(
                      itemCount: taskList.length,
                        itemBuilder: (context, int index) {
                          return new Column(
                            children: [
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
                                    bufferPercentage = newPercentage;
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
                        //for(var item in taskList) new Text(item),
                        //for(var item in taskList) new Checkbox(value: _value1, onChanged: _value1Changed, checkColor: UIData.blue, activeColor: Colors.white),
                        
                )
              ],
            ),
            
            new Text("data"),
            new Text("data"),
          ],
        ));
  }
}

