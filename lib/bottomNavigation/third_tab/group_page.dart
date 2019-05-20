import 'package:flutter/material.dart';
import 'package:smidigprosjekt/objects/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smidigprosjekt/utils/uidata.dart';

class GroupPage extends StatefulWidget {
  GroupPage({
    this.user,
  });
  final User user;
  @override
  _GroupPageState createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> with TickerProviderStateMixin {
  TabController _tabController;
  MediaQueryData queryData;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 3);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    queryData = MediaQuery.of(context);
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
              )
            ],
            elevation: 2,
            backgroundColor: Colors.white,
            title: new Text(
              "StudBud",
              style: new TextStyle(
                  fontFamily: 'Anton', fontSize: 24, color: Colors.black),
            ),
            bottom: PreferredSize(
              preferredSize:
                  Size(queryData.size.width, queryData.size.height / 4),
              child: new Column(
                children: <Widget>[
                  new Row(),
                  new Container(
                    color: Colors.grey[200],
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
                  children:[
                    new Column(
                      children:[
                        new Text(
                          "Ukens utfordring:",
                          style: new TextStyle(
                            color: UIData.black, fontFamily: 'Anton'
                          ),
                        ),
                        new Text(
                          "Lorem ipsum dolor sit amet\n,consectetur adipiscing elit, sed",
                          style: new TextStyle(
                            color: UIData.black, fontFamily: 'Anton'
                          ),
                        ),
                      ],
                    ),
                    new Container(
                          width:  ServiceProvider.instance.screenService.getPortraitWidthByPercentage(context, 20),
                          height: ServiceProvider.instance.screenService.getPortraitWidthByPercentage(context, 20),
                          color: UIData.pink
                        ),
                  ], // Text and meter row children 
                ),
                new Padding(
                  padding: EdgeInsets.only(top: 20),
                ),
                new ClipRRect(
                  borderRadius: new BorderRadius.circular(8.0),
                  child: new Container(
                    width:  ServiceProvider.instance.screenService.getPortraitWidthByPercentage(context, 85),
                    height: ServiceProvider.instance.screenService.getHeightByPercentage(context, 30),
                    color: Colors.white
                  ),
                ),
              ],
            ),
            
            new Text("data"),
            new Text("data"),
          ],
        ));
  }
}

