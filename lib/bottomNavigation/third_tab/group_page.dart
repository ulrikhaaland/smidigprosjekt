import 'package:flutter/material.dart';
import 'package:smidigprosjekt/objects/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smidigprosjekt/utils/uidata.dart';
import 'package:smidigprosjekt/service/service_provider.dart';

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

  bool _value1 = false;
  bool _value2 = false;

  void _value1Changed(bool value) => setState(() => _value1 = value);
  void _value2Changed(bool value) => setState(() => _value2 = value);

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
    List<String> taskList = [
      "oppgave 1",
      "oppgave 2",
      "oppgave 3",
      "oppgave 4"
    ];
    
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
                    height: ServiceProvider.instance.screenService.getHeightByPercentage(context, 42),
                    color: UIData.pink,
                    child: new Column(
                      children: <Widget> [
                        //for(var item in taskList) new Text(item),
                        for(var item in taskList) new Checkbox(value: _value1, onChanged: _value1Changed, checkColor: UIData.blue, activeColor: Colors.white),
                        /* for(var item in taskList)  */ /*new CheckboxListTile(
                          value: _value1,
                          onChanged: _value1Changed,
                          title: new Text("Big orgie"),
                          controlAffinity: ListTileControlAffinity.leading,
                          subtitle: new Text('Great for getting to know each other'),
                          activeColor: UIData.pink,
                          checkColor: Colors.yellowAccent,
                        ) */
                      ]
                    )
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

