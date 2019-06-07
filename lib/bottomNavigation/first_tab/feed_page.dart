import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:toast/toast.dart';
import 'package:smidigprosjekt/service/service_provider.dart';
import '../../auth.dart';
import '../second_tab/search_page.dart';
import 'package:smidigprosjekt/objects/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../../root_page.dart';
import '../../utils/uidata.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../third_tab/group_page.dart';
import '../../objects/user.dart';
import 'package:image_picker/image_picker.dart';
import '../../utils/layout.dart';
import 'package:intl/intl.dart';
import '../../widgets/primary_button.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:smidigprosjekt/bottomNavigation/fourth_tab/profile_page.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage(
      {this.auth,
        this.onSignOut,
        this.currentUser,
        this.userEmail,
        this.userName,
        this.user});
  final BaseAuth auth;
  final VoidCallback onSignOut;
  final String currentUser;
  final String userName;
  final String userEmail;
  final User user;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Event> eventList = [];
  List<Event> myEvent = [];

  final Key keyOne = PageStorageKey('pageOne');
  final Key keyTwo = PageStorageKey('pageTwo');
  final Key keyThree = PageStorageKey('pageThree');
  final Key keyFour = PageStorageKey('pageFour');

  final BaseAuth auth = Auth();

  Firestore firestoreInstance = Firestore.instance;

  int currentTab = 0;

  String currentUser;

  PageOne one;
  SearchPage two;
  GroupPage three;
  ProfilePage four;
  StatefullNew five;

  List<Widget> pages;
  Widget currentPage;

  final PageStorageBucket bucket = PageStorageBucket();

  @override
  void initState() {
    print(widget.user.getName());
    one = PageOne(
      key: keyOne,
      auth: auth,
      user: widget.user,
      eventList: eventList,
      // onRefresh: () => _getEventsData(),
    );

    two = SearchPage(
      key: keyTwo,
      auth: auth,
      user: widget.user,
    );

    three = GroupPage(
      user: widget.user,
    );

    four = ProfilePage(
      user: widget.user,
      // myEvent: myEvent,
      onSignOut: () => _signOut(),
    );

    pages = [one, two, three, four];

    currentPage = one;

    super.initState();
  }

  void _signOut() async {
    try {
      await auth.signOut();
      widget.onSignOut();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UIData.grey,
      body: PageStorage(
        child: currentPage,
        bucket: bucket,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        currentIndex: currentTab,
        onTap: (int index) {
          setState(() {
            currentTab = index;
            currentPage = pages[index];
          });
        },
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            activeIcon: new Image.asset(
              "lib/assets/images/feed_icon_fill.png",
              scale: 10,
            ),
            backgroundColor: UIData.lightBlue,
            icon: new Image.asset(
              "lib/assets/images/feed_icon.png",
              scale: 10,
            ),
            title: Text(''),
          ),
          BottomNavigationBarItem(
            activeIcon: new Image.asset(
              "lib/assets/images/search_icon_fill.png",
              scale: 10,
            ),
            backgroundColor: UIData.lightBlue,
            icon: new Image.asset(
              "lib/assets/images/search_icon.png",
              scale: 10,
            ),
            title: Text(''),
          ),
          BottomNavigationBarItem(
            activeIcon: new Image.asset(
              "lib/assets/images/group_icon_fill.png",
              scale: 10,
            ),
            backgroundColor: UIData.lightBlue,
            icon: new Image.asset(
              "lib/assets/images/group_icon.png",
              scale: 10,
            ),
            title: Text(''),
          ),
          BottomNavigationBarItem(
            activeIcon: new Image.asset(
              "lib/assets/images/profile_icon_fill.png",
              scale: 10,
            ),
            backgroundColor: UIData.lightBlue,
            icon: new Image.asset(
              "lib/assets/images/profile_icon.png",
              scale: 10,
            ),
            title: Text(''),
          ),
        ],
      ),
    );
  }
}

class PageOne extends StatefulWidget {
  PageOne({
    Key key,
    this.auth,
    this.onSignOut,
    this.user,
    this.eventList,
    this.onRefresh,
  }) : super(key: key);
  final BaseAuth auth;
  final VoidCallback onSignOut;
  final User user;
  final VoidCallback onRefresh;
  final List<Event> eventList;

  @override
  PageOneState createState() => PageOneState();
}

class PageOneState extends State<PageOne> {
  static final formKey = new GlobalKey<FormState>();
  final f = new DateFormat('yyyy-MM-dd hh:mm');

  var tapped = -1;
  double cardWidth;
  bool tap = false;

  bool going = false;

  int starred = -1;

  List<String> list = [ 'hei', 'hallo',];

  bool mine = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: new Icon(Icons.add),
        onPressed: () {
          print('button tapped');
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => StatefullNew(user: widget.user.userName)),
          );
        },
        backgroundColor: UIData.pink,
        elevation: 0.0,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      backgroundColor: UIData.grey,
      appBar: new AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        actions: <Widget>[
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
              child: IconButton(
                icon: Image.asset(
                  'lib/assets/images/filter_icon.png',
                  scale: 10,
                ),
                onPressed: () {

                  _sendToFilter(context);

                },
              ),
            ),
          )
        ],
        title: Image.asset(
          'lib/assets/images/logo_tekst.png',
          fit: BoxFit.contain,
          scale: 8,
        ),
        centerTitle: true,
      ),
      body: new SingleChildScrollView(
        child: new Stack(
          //child: new Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                      width: ServiceProvider.instance.screenService
                          .getPortraitWidthByPercentage(context, 100),
                      height: ServiceProvider.instance.screenService
                          .getPortraitHeightByPercentage(context, 80),
                      child: StreamBuilder(
                          stream: Firestore.instance
                              .collection("events")
                              .orderBy('time', descending: false)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) return Center(child: Text("Laster.."));

                            return ListView.builder(
                              //itemExtent: 350.0,
                              itemCount: snapshot.data.documents.length,
                              itemBuilder: (context, index) {
                                DocumentSnapshot document = snapshot.data.documents[index];

                                var now = new DateTime.now();
                                if (document.data["time"].isAfter(now)) {

                                return Column(
                                  children: <Widget>[
                                    Divider(
                                      color: UIData.grey,
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                        child: Text(
                                          _DateText(document),
                                        ),
                                      ),
                                    ),
                                    Divider(
                                      color: UIData.grey,
                                      height: 0.2,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        _tapped(index);

                                        setState((){
                                if(document.data["id"].contains(widget.user.userName)) {
                                  mine = true;
                                } else { mine = false;};
                                        });
                                      },
                                      child: Column(
                                        children: <Widget>[
                                          tap == true && tapped != null && tapped == index?
                                          SizedBox(
                                            height: 310,
                                            width: ServiceProvider.instance.screenService
                                                .getPortraitWidthByPercentage(context, 82),
                                            child: Card(
                                              elevation: 0.0,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(8)),
                                              child: Column(
                                                children: <Widget>[
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    //crossAxisAlignment: CrossAxisAlignment.stretch,

                                                    children: <Widget>[
                                                      ClipRRect(
                                                        borderRadius: new BorderRadius.only(
                                                            topLeft: Radius.circular(8),
                                                            topRight: Radius.circular(8)),
                                                        child: Image.network(
                                                          document.data["imgUrl"],
                                                          height: 120,
                                                          width: ServiceProvider.instance.screenService
                                                              .getPortraitWidthByPercentage(context, 79.7),
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
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(8),
                                                          border: Border.all(color: Colors.white)),
                                                      child: Padding(
                                                        padding: EdgeInsets.all(8),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment.start,
                                                          children: <Widget>[
                                                            Text("Beskrivelse:",
                                                                style: TextStyle(
                                                                    fontWeight: FontWeight.bold)),
                                                            Divider(
                                                              height: 10,
                                                              color: Colors.white,
                                                            ),
                                                            Text('${document.data["desc"]}',
                                                                style: TextStyle(fontSize: 13)),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      height: 40,
                                                      margin: EdgeInsets.only(top: 0),
                                                      width: ServiceProvider.instance.screenService
                                                          .getPortraitWidthByPercentage(context, 82),
                                                      decoration: new BoxDecoration(
                                                        color: mine && tapped != null && tapped == index? UIData.blue : UIData.pink,
                                                        borderRadius: new BorderRadius.only(
                                                            bottomLeft: const Radius.circular(8.0),
                                                            bottomRight: const Radius.circular(8.0)),
                                                      ),
                                                      child: FlatButton(
                                                        color: mine && tapped != null && tapped == index? UIData.blue : UIData.pink,
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(100)),
                                                        padding: EdgeInsets.all(10),
                                                        onPressed: () {
                                                          //going = true;
                                                          _tapped(document);
                                                          _starred(snapshot);
                                                        },
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: <Widget>[
                                                            mine && tapped != null && tapped == index?
                                                                Icon(Icons.person, color: Colors.white, size: 20)
                                                                :
                                                            Icon(
                                                              // going && starred == position
                                                              //  ? Icons.star

                                                              Icons.star_border,
                                                              color: Colors.white,
                                                              size: 20,
                                                            ),
                                                            Padding(padding: EdgeInsets.all(3)),
                                                            mine && tapped != null && tapped == index?
                                                            Text("Mitt event", style: TextStyle(
                                                                color: Colors.white,
                                                                fontSize: 13) )
                                                                :
                                                            Text

                                                              ("Interessert",
                                                                style: TextStyle(
                                                                    color: Colors.white,
                                                                    fontSize: 13)),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ) :
                                          SizedBox(
                                            height: 130,
                                            width: ServiceProvider.instance.screenService
                                                .getPortraitWidthByPercentage(context, 82),
                                            child: Card(
                                              elevation: 0.0,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(8)),
                                              child: Column(
                                                children: <Widget>[
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    //crossAxisAlignment: CrossAxisAlignment.stretch,

                                                    children: <Widget>[
                                                      ClipRRect(
                                                        borderRadius: new BorderRadius.only(
                                                            topLeft: Radius.circular(8),
                                                            bottomLeft: Radius.circular(8)),
                                                        child: Image.network(
                                                          document.data["imgUrl"],
                                                          height: 122,
                                                          width: 110,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: EdgeInsets.all(10),
                                                        child: Align(
                                                          alignment: Alignment.centerRight,
                                                          child: Column(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment.start,
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment.start,
                                                            children: <Widget>[
                                                              Row(
                                                                children: <Widget>[
                                                                  new Text(
                                                                      document.data["title"],
                                                                      style: ServiceProvider
                                                                          .instance.styles
                                                                          .cardTitle()),
                                                                  Icon(
                                                                    Icons.star,
                                                                    color:
                                                                    going && starred == snapshot
                                                                        ? UIData.pink
                                                                        : Colors.white,
                                                                    size: 20,
                                                                  ),
                                                                ],
                                                              ),
                                                              Divider(color: Colors.white),
                                                              Row(
                                                                children: <Widget>[
                                                                  Icon(
                                                                    Icons.location_on,
                                                                    color: UIData.blue,
                                                                    size: 20,
                                                                  ),
                                                                  Text(
                                                                    document.data["address"],
                                                                    style: TextStyle(
                                                                        fontStyle: FontStyle.italic,
                                                                        fontSize: 12),
                                                                  ),
                                                                ],
                                                              ),
                                                              Divider(
                                                                color: Colors.white,
                                                              ),
                                                              Row(
                                                                children: <Widget>[
                                                                  Icon(
                                                                    Icons.access_time,
                                                                    color: UIData.black,
                                                                    size: 17,
                                                                  ),
                                                                  Text(
                                                                    ' ${document.data["time"].hour.toString()}' +
                                                                        ':' +
                                                                        '${document.data["time"].minute.toString().padRight(2, '0')}',
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
                                    )
                                  ],
                                );
                                } else {
                                  return Divider(color: UIData.grey, height: 0);
                                };

                              }



                            );
                          })),
                ),
              ],
            ),
            Padding(padding: EdgeInsets.all(100)),
            Padding(padding: EdgeInsets.all(90)),
            Align(
              alignment: Alignment.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _eventList(BuildContext context, DocumentSnapshot snapshot) {

    // Text(snapshot.data["address"])


  }

  void _starred(snapshot) {
    setState(() {
      if (going) {
        going = false;
        starred = snapshot;
      } else {
        starred = snapshot;
        going = true;
      }
    });
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
      return '${dt.day.toString()}' +
          '. ' +
          'Januar';
    } else if (dt.month == 2) {
      return '${dt.day.toString()}' +
          '. ' +
          'Februar';
    } else if (dt.month == 3) {
      return '${dt.day.toString()}' +
          '. ' +
          'Mars';
    } else if (dt.month == 4) {
      return '${dt.day.toString()}' +
          '. ' +
          'April';
    } else if (dt.month == 5) {
      return '${dt.day.toString()}' + '. ' + 'Mai';

    } else if (dt.month == 6) {
      return '${dt.day.toString()}' +
          '. ' +
          'Juni';
    } else if (dt.month == 7) {
      return '${dt.day.toString()}' +
          '. ' +
          'Juli';
    } else if (dt.month == 8) {
      return '${dt.day.toString()}' +
          '. ' +
          'August';
    } else if (dt.month == 9) {
      return '${dt.day.toString()}' +
          '. ' +
          'September';
    } else if (dt.month == 10) {
      return '${dt.day.toString()}' +
          '. ' +
          'Oktober';
    } else if (dt.month == 11) {
      return '${dt.day.toString()}' +
          '. ' +
          'November';
    } else if (dt.month == 12) {
      return '${dt.day.toString()}' +
          '. ' +
          'Desember';
    }
  }

  Future<void> _refresh() async {
    print('refreshing');
    //setState(() => _getEventsData()
  }

  void _sendToFilter(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => StateFilterPage(),)
    );

    setState((){
      list = result;
    });
  }
}

class StateFilterPage extends StatefulWidget {
  StateFilterPage({this.user});
  final User user;

  @override
  FilterPage createState() => FilterPage();
}

class FilterPage extends State<StateFilterPage> {
  List<String> data;

  void initState() {
    super.initState();
  }

  List<String> cate = [
    'lib/assets/images/skole.png',
    'lib/assets/images/kaffe.png',
    'lib/assets/images/gaming.png',
    'lib/assets/images/fest.png',
    'lib/assets/images/prosjekt.png'
  ];
  List<String> cat = ["Skolejobbing", "Kaffe", "Gaming", "Fest", "Prosjekt"];

  String dropdown = '';

  bool skole = false;
  bool kaffe = false;
  bool gaming = false;
  bool fest = false;
  bool prosjekt = false;

  var kategori;

  bool nullstill = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UIData.grey,
      appBar: new AppBar(
        elevation: 1,
        //iconTheme: IconThemeData(
        // color: UIData.black,
        // ),
        backgroundColor: Colors.white,
        actions: <Widget>[
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
              child: IconButton(
                icon: Image.asset(
                  'lib/assets/images/filter_icon_selected.png',
                  scale: 10,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          )
        ],

        title: Text("Filter", style: ServiceProvider.instance.styles.title()),
        centerTitle: true,
      ),
      body: new Stack(
        children: <Widget>[
          Center(
            child: Column(
              children: <Widget>[
                Divider(
                  color: UIData.grey,
                  height: 20,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text("Sorter etter:",
                      style: TextStyle(
                        color: UIData.black,
                        fontSize: 13,
                      )),
                ),
                Divider(
                  color: UIData.grey,
                ),
                Container(
                  width: ServiceProvider.instance.screenService
                      .getPortraitWidthByPercentage(context, 82),
                  //height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white),
                  //color: Colors.white,
                  child: SizedBox(
                    height: 40,
                    child: new Theme(
                      data: Theme.of(context).copyWith(
                        canvasColor: Colors.white,
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: false,
                          value: dropdown,
                          style: TextStyle(fontSize: 13, color: UIData.black),
                          onChanged: (String newValue) {
                            setState(() {
                              dropdown = newValue;
                            });
                          },
                          items: <String>['', 'Favoritter', 'Avstand', 'Popularitet']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem(
                              value: value,
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(value),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ),
                Divider(
                  color: UIData.grey,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text("Filtrer:",
                      style: TextStyle(
                        color: UIData.black,
                        fontSize: 13,
                      )),
                ),
                Divider(
                  color: UIData.grey,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        pressedSkole();
                        print(cat[0]);
                      },
                      child: Container(
                        height: 100,
                        child: SizedBox(
                          width: 100,
                          child: Card(
                            elevation: 0,
                            //color: (pressed ? Colors.white : UIData.pink),
                            shape: (nullstill && skole
                                ? RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(
                                    width: 1,
                                    style: BorderStyle.solid,
                                    color: UIData.black))
                                : RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(
                                    width: 0, style: BorderStyle.none))),

                            child: Padding(
                              padding: EdgeInsets.all(7),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Image.asset(
                                    cate[0],
                                    scale: 20,
                                  ),
                                  Divider(
                                    color: Colors.white,
                                    height: 10,
                                  ),
                                  Text(cat[0], style: TextStyle(fontSize: 10)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        pressedKaffe();
                      },
                      child: Container(
                        height: 100,
                        child: SizedBox(
                          width: 100,
                          child: Card(
                            elevation: 0,
                            //color: (pressed ? Colors.white : UIData.pink),
                            shape: (nullstill && kaffe
                                ? RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(
                                    width: 1,
                                    style: BorderStyle.solid,
                                    color: UIData.black))
                                : RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(
                                    width: 0, style: BorderStyle.none))),

                            child: Padding(
                              padding: EdgeInsets.all(7),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Image.asset(
                                    cate[1],
                                    scale: 20,
                                  ),
                                  Divider(
                                    color: Colors.white,
                                    height: 10,
                                  ),
                                  Text(cat[1], style: TextStyle(fontSize: 10)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        pressedGaming();
                      },
                      child: Container(
                        height: 100,
                        child: SizedBox(
                          width: 100,
                          child: Card(
                            elevation: 0,
                            //color: (pressed ? Colors.white : UIData.pink),
                            shape: (nullstill && gaming
                                ? RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(
                                    width: 1,
                                    style: BorderStyle.solid,
                                    color: UIData.black))
                                : RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(
                                    width: 0, style: BorderStyle.none))),

                            child: Padding(
                              padding: EdgeInsets.all(7),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Image.asset(
                                    cate[2],
                                    scale: 20,
                                  ),
                                  Divider(
                                    color: Colors.white,
                                    height: 10,
                                  ),
                                  Text(cat[2], style: TextStyle(fontSize: 10)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        pressedFest();
                      },
                      child: Container(
                        height: 100,
                        child: SizedBox(
                          width: 100,
                          child: Card(
                            elevation: 0,
                            //color: (pressed ? Colors.white : UIData.pink),
                            shape: (nullstill && fest
                                ? RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(
                                    width: 1,
                                    style: BorderStyle.solid,
                                    color: UIData.black))
                                : RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(
                                    width: 0, style: BorderStyle.none))),

                            child: Padding(
                              padding: EdgeInsets.all(7),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Image.asset(
                                    cate[3],
                                    scale: 20,
                                  ),
                                  Divider(
                                    color: Colors.white,
                                    height: 10,
                                  ),
                                  Text(cat[3], style: TextStyle(fontSize: 10)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        pressedProsjekt();
                      },
                      child: Container(
                        height: 100,
                        child: SizedBox(
                          width: 100,
                          child: Card(
                            elevation: 0,
                            //color: (pressed ? Colors.white : UIData.pink),
                            shape: (nullstill && prosjekt
                                ? RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(
                                    width: 1,
                                    style: BorderStyle.solid,
                                    color: UIData.black))
                                : RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(
                                    width: 0, style: BorderStyle.none))),

                            child: Padding(
                              padding: EdgeInsets.all(7),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Image.asset(
                                    cate[4],
                                    scale: 20,
                                  ),
                                  Divider(
                                    color: Colors.white,
                                    height: 10,
                                  ),
                                  Text(cat[4], style: TextStyle(fontSize: 10)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        //pressedFilter();
                      },
                      child: Container(
                        height: 100,
                        child: SizedBox(
                          width: 100,
                          child: Card(
                            elevation: 0,
                            //color: (pressed ? Colors.white : UIData.pink),
                            shape: (RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(
                                    width: 0, style: BorderStyle.none))),

                            child: Padding(
                              padding: EdgeInsets.all(7),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  //Image.asset(cate[0], scale: 20,),
                                  Divider(
                                    color: Colors.white,
                                    height: 10,
                                  ),
                                  //Text(cat[0], style: TextStyle(fontSize: 10)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        // pressedFilter();
                      },
                      child: Container(
                        height: 100,
                        child: SizedBox(
                          width: 100,
                          child: Card(
                            elevation: 0,
                            //color: (pressed ? Colors.white : UIData.pink),
                            shape: (RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(
                                    width: 0, style: BorderStyle.none))),

                            child: Padding(
                              padding: EdgeInsets.all(7),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  //Image.asset(cate[0], scale: 20,),
                                  Divider(
                                    color: Colors.white,
                                    height: 10,
                                  ),
                                  //Text(cat[0], style: TextStyle(fontSize: 10)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                        //pressedFilter();
                      },
                      child: Container(
                        height: 100,
                        child: SizedBox(
                          width: 100,
                          child: Card(
                            elevation: 0,
                            //color: (pressed ? Colors.white : UIData.pink),
                            shape: (RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(
                                    width: 0, style: BorderStyle.none))),

                            child: Padding(
                              padding: EdgeInsets.all(7),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  //Image.asset(cate[1], scale: 20,),
                                  Divider(
                                    color: Colors.white,
                                    height: 10,
                                  ),
                                  // Text(cat[1], style: TextStyle(fontSize: 10)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    //Text("${widget.user.userName}"),

                    GestureDetector(
                      onTap: () {
                        //pressedFilter();
                      },
                      child: Container(
                        height: 100,
                        child: SizedBox(
                          width: 100,
                          child: Card(
                            elevation: 0,
                            //color: (pressed ? Colors.white : UIData.pink),
                            shape: (RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(
                                    width: 0, style: BorderStyle.none))),

                            child: Padding(
                              padding: EdgeInsets.all(7),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  //Image.asset(cate[2], scale: 20,),
                                  Divider(
                                    color: Colors.white,
                                    height: 10,
                                  ),
                                  //Text(cat[2], style: TextStyle(fontSize: 10)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Divider(
                  color: UIData.grey,
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    setState((){
                      if (skole) {skole = false;};
                      if (kaffe) {kaffe = false;};
                      if (gaming) {gaming = false;};
                      if (fest) {fest = false;};
                      if (prosjekt) {prosjekt = false;};
                    });
                  },
                  child: Container(
                    height: 20,
                    child: Text(
                      "Nullstill filter",
                      style: TextStyle(color: UIData.blue, fontSize: 15),
                    ),
                  ),


                ),
                Divider(
                  color: UIData.grey,
                  height: 20,
                ),
                RaisedButton(
                    color: UIData.pink,
                    elevation: 0,
                    padding: EdgeInsets.fromLTRB(40, 15, 40, 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                        side: BorderSide(style: BorderStyle.none)),
                    onPressed: () {
                      if (kaffe) {
                        kategori = cat[1];
                        data.add(cat[1]);
                        print(cat[1]);
                      }
                      if (skole) {
                        kategori = cat[0];
                        data.add(cat[0]);
                        print(cat[0]);
                      }
                      if (gaming) {
                        kategori = cat[2];
                        data.add(cat[2]);
                        print(cat[2]);
                      }
                      if (fest) {
                        kategori = cat[3];
                        data.add(cat[3]);
                        print(cat[3]);
                      }
                      if (prosjekt) {
                        kategori = cat[4];
                        data.add(cat[4]);
                        print(cat[4]);
                      }
                      //print("${widget.user.userName}");

                      Navigator.pop(context, data);
                    },
                    child: Text("Bruk filter",
                        style: TextStyle(color: Colors.white))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void pressedSkole() {
    setState(() {
      if (skole) {
        skole = false;
      } else {
        skole = true;
      }
    });
  }

  void pressedKaffe() {
    setState(() {
      if (kaffe) {
        kaffe = false;
      } else {
        kaffe = true;
      }
    });
  }

  void pressedGaming() {
    setState(() {
      if (gaming) {
        gaming = false;
      } else {
        gaming = true;
      }
    });
  }

  void pressedFest() {
    setState(() {
      if (fest) {
        fest = false;
      } else {
        fest = true;
      }
    });
  }

  void pressedProsjekt() {
    setState(() {
      if (prosjekt) {
        prosjekt = false;
      } else {
        prosjekt = true;
      }
    });
  }
}

class Event {
  Event(
      {this.imgUrl,
        this.address,
        this.cat,
        this.desc,
        this.id,
        this.time,
        this.title});

  final String address;
  final String cat;
  final String desc;
  final String imgUrl;
  final String id;
  final DateTime time;
  final String title;
}

class StatefullNew extends StatefulWidget {
  StatefullNew({this.user});
  final String user;

  @override
  NewEventPage createState() => NewEventPage();
}

class NewEventPage extends State<StatefullNew> {
  String dropdownValue = "Skolejobbing";
  String add = "";
  String tit = "";
  int id;
  String bes = "";
  String tids;
  String dats;
  String kat = "";

  final _add = TextEditingController();
  final _tit = TextEditingController();
  final _bes = TextEditingController();

  var dbUrl;

  File imgUrl;

  bool choosen = false;

  bool _validate = false;
  bool _validateB = false;
  bool _validateT = false;
  bool _validateD = false;
  bool _validateS = false;
  bool _validateK = false;
  bool _validateP = false;

  void initState() {
    super.initState();
  }

  bool skole = false;
  bool kaffe = false;
  bool gaming = false;
  bool fest = false;
  bool prosjekt = false;
  bool tidspunkt = false;
  bool datovalg = false;

  DateTime _date = new DateTime.now();
  TimeOfDay _time = new TimeOfDay.now();

  List<Event> newEvent = [];
  List<String> cate = [
    'lib/assets/images/skole.png',
    'lib/assets/images/kaffe.png',
    'lib/assets/images/gaming.png',
    'lib/assets/images/fest.png',
    'lib/assets/images/prosjekt.png'
  ];
  List<String> cat = ["Skolejobbing", "Kaffe", "Gaming", "Fest", "Prosjekt"];

  bool tap = false;
  int tapped = -1;

  Future<Null> selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: new DateTime(2018),
      lastDate: new DateTime(2020),
    );
    if (picked != null && picked != _date) {
      print("Date: ${_date.toString()}");
      setState(() {
        _date = picked;
        dats = '${_date.day.toString()}' + '.' + '${_date.month.toString()}';
        datovalg = true;
      });
    }
  }

  Future<Null> selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: _time,
    );
    if (picked != null && picked != _time) {
      setState(() {
        _time = picked;
        print(_time.hour.toString());
        tids = '${_time.hour.toString()}' + ':' + '${_time.minute.toString()}';
        tidspunkt = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () {
        this._removeKeyboard(context);
      },
      child: Scaffold(
        backgroundColor: UIData.grey,
        appBar: AppBar(
          elevation: 1,
          iconTheme: IconThemeData(
            color: UIData.black,
          ),
          centerTitle: true,
          title: Text(
            "Nytt event",
            style: ServiceProvider.instance.styles.title(),
          ),
          backgroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.all(30.0),
                  child: Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: _validateK ? Row(children: <Widget>[
                          Text("Kategori: "),
                          Text("* Velg en kategori", style: TextStyle(color: UIData.pink, fontSize: 10))
                        ],) :Text("Kategori:"),
                      ),
                      Divider(
                        color: UIData.grey,
                        height: 10,
                      ),
                      SizedBox(
                        height: 90,
                        child: ListView.builder(
                          itemCount: cate.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            //EdgeInsets.all(10);
                            return Container(
                              width: 90,
                              child: InkWell(
                                onTap: () {
                                  _tapped(index);

                                  print(cat[index]);
                                  kat = cat[index];

                                  setState((){
                                    _validateK = false;
                                  });
                                  //RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(width: 2, style: BorderStyle.solid));
                                },
                                splashColor: UIData.grey,
                                highlightColor: UIData.grey,
                                child: Card(
                                  shape: (tap == true &&
                                      tapped != null &&
                                      tapped == index
                                      ? RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(8),
                                      side: BorderSide(
                                          width: 1,
                                          style: BorderStyle.solid,
                                          color: UIData.black))
                                      : RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(8),
                                      side: BorderSide(
                                          width: 0,
                                          style: BorderStyle.none))),
                                  child: Padding(
                                    padding: EdgeInsets.all(7),
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: <Widget>[
                                        Image.asset(
                                          cate[index],
                                          scale: 20,
                                        ),
                                        Divider(
                                          color: Colors.white,
                                          height: 10,
                                        ),
                                        Text(cat[index],
                                            style: TextStyle(fontSize: 10)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Divider(
                        color: UIData.grey,
                      ),
                      Theme(
                        data: Theme.of(context).copyWith(
                          primaryColor: UIData.blue,
                          splashColor: UIData.pink,
                        ),
                        child: Container(
                          width: ServiceProvider.instance.screenService
                              .getPortraitWidthByPercentage(context, 82),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              SizedBox(
                                width: 140,
                                height: 50,
                                child: FlatButton.icon(
                                  onPressed: () {
                                    selectDate(context);

                                    setState((){
                                      _validateD = false;
                                    });
                                  },
                                  icon: Icon(
                                    Icons.calendar_today,
                                    color: UIData.blue,
                                    size: 20,
                                  ),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                      side: _validateD ? BorderSide(style: BorderStyle.solid, width: 1, color: UIData.pink) :
                                      BorderSide(style: BorderStyle.none)),
                                  color: Colors.white,
                                  label: (datovalg
                                      ? Text(
                                    dats,
                                    style: TextStyle(color: UIData.black),
                                  )
                                      : Text("Dato",
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.normal))),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(5),
                              ),
                              SizedBox(
                                width: 140,
                                height: 50,
                                child: FlatButton.icon(
                                  onPressed: () {
                                    selectTime(context);

                                    setState((){
                                      _validateS = false;
                                    });

                                  },
                                  icon: Icon(Icons.access_time,
                                      color: UIData.blue, size: 22),
                                  shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(8)),
                            side: _validateS ? BorderSide(style: BorderStyle.solid, width: 1, color: UIData.pink) :
                            BorderSide(style: BorderStyle.none)),
                                  color: Colors.white,
                                  label: (tidspunkt
                                      ? Text(
                                    tids,
                                    style: TextStyle(color: UIData.black),
                                  )
                                      : Text("Tid",
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.normal))),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Divider(
                        color: UIData.grey,
                      ),
                      Container(
                        width: 300.0,
                        height: _validateT ? 70 :50,
                        child: TextField(
                          controller: _tit,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: InputDecoration(
                            hintText: "Tittel",
                            filled: true,
                            errorStyle: TextStyle(color: UIData.pink, fontSize: 10,),
                            errorText: _validateT ? "* Fyll ut" : null,
                            contentPadding: EdgeInsets.all(17.0),
                            fillColor: Colors.white,
                            hintStyle: TextStyle(color: Colors.grey),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: _validateT ? BorderSide(
                                    width: 1, style: BorderStyle.solid, color: UIData.pink) :BorderSide(
                                    width: 0, style: BorderStyle.none) ),
                          ),
                          onChanged: (text) {
                            tit = text;
                            setState((){
                              _validateT = false;
                            });
                          },
                          onSubmitted: (text) {
                            String t = text;
                            tit = text;
                            //rint(t);
                            saveTit(t);
                          },
                        ),
                      ),
                      Divider(
                        color: UIData.grey,
                      ),
                      Container(
                        width: 300.0,
                        height: _validate ? 70 :50,
                        child: TextField(
                          textCapitalization: TextCapitalization.sentences,
                          controller: _add,
                          decoration: InputDecoration(
                            hintText: "Addresse",
                            errorStyle: TextStyle(color: UIData.pink, fontSize: 10,),
                            errorText: _validate ? "* Fyll ut" : null,
                            filled: true,
                            contentPadding: EdgeInsets.all(17.0),
                            fillColor: Colors.white,
                            hintStyle: TextStyle(color: Colors.grey),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: _validate ? BorderSide(
                                    width: 1, style: BorderStyle.solid, color: UIData.pink) :BorderSide(
                                    width: 0, style: BorderStyle.none) ),
                          ),
                          onChanged: (text) {
                            add = text;
                            setState((){
                              _validate = false;
                            });
                          },
                          onSubmitted: (text) {
                            String a = text;
                            add = text;
                            //print(a);
                            saveAdd(a);

                          },
                        ),
                      ),
                      Divider(
                        color: UIData.grey,
                      ),
                      Container(
                        //height: 190.0,
                        width: 300.0,
                        child: SizedBox(
                          height: 105.0,
                          child: TextField(
                            controller: _bes,

                            textInputAction: TextInputAction.done,
                            textCapitalization: TextCapitalization.sentences,
                            maxLines: 6,
                            decoration: InputDecoration(
                              hintText: "Beskrivelse",
                              filled: true,
                              errorStyle: TextStyle(color: UIData.pink, fontSize: 10,),
                              errorText: _validateB ? "* Fyll ut" : null,
                              contentPadding: EdgeInsets.all(17.0),
                              fillColor: Colors.white,
                              hintStyle: TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: _validateB ? BorderSide(
                                      width: 1, style: BorderStyle.solid, color: UIData.pink) :BorderSide(
                                      width: 0, style: BorderStyle.none) ),
                            ),
                            onChanged: (text) {
                              bes = text;
                              setState((){
                                _validateB = false;
                              });
                            },
                            onSubmitted: (text) {
                              String b = text;
                              bes = text;
                              //print(b);
                              saveBes(b);
                            },
                          ),
                        ),
                      ),
                      Divider(
                        color: UIData.grey,
                      ),
                      Column(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: _validateP ? Row(children: <Widget>[
                              Text("Legg til bilde: "),
                              Text("* Velg bilde", style: TextStyle(color: UIData.pink, fontSize: 10))
                            ],) : Text("Legg til bilde:"),
                          ),
                          Divider(
                            color: UIData.grey,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: choosen
                                ? Column(
                              //mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: <Widget>[
                                FlatButton.icon(
                                  onPressed: openOptions,
                                  color: UIData.grey,
                                  icon: Icon(Icons.replay,
                                      color: UIData.blue),
                                  label: Text("Ta på nytt",
                                      style: TextStyle(
                                          color: UIData.blue,
                                          fontWeight: FontWeight.bold)),
                                ),
                           ClipRRect(
                              borderRadius: new BorderRadius.circular(8.0),
                                child: Container(
                                    height: 200,
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),),
                                    child: Image.file(
                                      imgUrl,
                                      fit: BoxFit.fill,

                                      // width: 200,
                                      //height: 400,
                                    )),),
                              ],
                            )
                                : Container(
                              height: 80,
                              child: FittedBox(
                                child: FloatingActionButton(
                                  onPressed: () {
                                    openOptions();
                                    //choosen = true;
                                  },
                                  child: Icon(
                                    Icons.photo_camera,
                                    size: 30.0,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(8.0)),
                                  ),
                                  backgroundColor: Colors.white,
                                  foregroundColor: UIData.black,
                                  elevation: 0.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Divider(
                        color: UIData.grey,
                        height: 40,
                      ),
                      RaisedButton(
                          color: UIData.pink,
                          elevation: 0,
                          padding: EdgeInsets.fromLTRB(30, 15, 30, 15),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(100)),
                              side: BorderSide(style: BorderStyle.none)),
                          onPressed: () {

                            DateTime titi = new DateTime(
                                _date.year,
                                _date.month,
                                _date.day,
                                _time.hour,
                                _time.minute);

                            if(add != null && kat != null && bes != null && titi != null && imgUrl != null) {
                              uploadImage(imgUrl, bes, tit, kat, add, titi);
                              Navigator.pop(context);
                            } else  {
                              setState((){
                                _add.text.isEmpty ? _validate = true : _validate = false;
                                _bes.text.isEmpty ? _validateB = true : _validateB = false;
                                _tit.text.isEmpty ? _validateT = true : _validateT = false;
                                dats == null ? _validateD = true : _validateD = false;
                                tids == null ? _validateS = true : _validateS = false;
                                tap? _validateK = false : _validateK = true;
                                choosen? _validateP = false : _validateP = true;
                              });
                              Toast.show("Alle felt på fylles", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM, backgroundColor: UIData.black);

                            }
                            print("post pressed");



                            //if(add != null && kat != null && bes != null && titi != null && dbUrl != null) {




                          },
                          child: Text("Post event",
                              style: TextStyle(color: Colors.white)))
                    ],
                  ),
                ),
              ),
              Align(),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> save() async {


}

  String saveAdd(a) {
    print(a);
    return a;
  }

  String saveTit(t) {
    print(t);
    return t;
  }

  String saveTid(tid) {
    print(tid);
    return tid;
  }

  String saveBes(b) {
    print(b);
    return b;
  }

  String saveKat(newValue) {
    return newValue;
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

  Future openCamera() async {
    var picture = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      imgUrl = picture;
      choosen = true;
    });

    //uploadImage(imgUrl);

    //dbUrl = picture.path.toString();
    print("You selected: " + dbUrl);
    Navigator.pop(context);
  }

  Future openGallery() async {
    var gallery = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      imgUrl = gallery;
      choosen = true;
    });
    Navigator.pop(context);
    //uploadImage(imgUrl);

    // dbUrl = gallery.path.toString();
    //saveUrlDb(dbUrl);
  }

  void uploadImage(imgUrl, add, kat, bes, tit, titi) async {



    final StorageReference imgRef =
    FirebaseStorage.instance.ref().child("Event_Images");

    final id = new DateTime.now().millisecondsSinceEpoch;
    String name = widget.user;
    String idu = name + " " + id.toString();

    final StorageUploadTask upTask = imgRef.child(idu + ".jpg").putFile(imgUrl);

    var url = await (await upTask.onComplete).ref.getDownloadURL();
    dbUrl = url.toString();
    print("upload $dbUrl");


    var data = {
      "address": add,
      "cat": kat,
      "desc": bes,
      "id": idu,
      "time": titi,
      "title": tit,
      "imgUrl": dbUrl,
    };
    Firestore.instance
        .document("events/$idu")
        .setData(data);



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

  void _removeKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(new FocusNode());
  }
}



//// ##  : SizedBox(
//                       height: 130,
//                       width: ServiceProvider.instance.screenService
//                           .getPortraitWidthByPercentage(context, 82),
//                       child: Card(
//                         elevation: 0.0,
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8)),
//                         child: Column(
//                           children: <Widget>[
//                             Row(
//                              mainAxisAlignment: MainAxisAlignment.start,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               //crossAxisAlignment: CrossAxisAlignment.stretch,
//
//                               children: <Widget>[
//                                 ClipRRect(
//                                   borderRadius: new BorderRadius.only(
//                                       topLeft: Radius.circular(8),
//                                       bottomLeft: Radius.circular(8)),
//                                   child: Image.network(
//                                    widget.eventList[position].imgUrl,
//                                     height: 122,
//                                     width: 110,
//                                    fit: BoxFit.cover,
//                                   ),
//                                 ),
//                                 Padding(
//                                   padding: EdgeInsets.all(10),
//                                   child: Align(
//                                     alignment: Alignment.centerRight,
//                                     child: Column(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.start,
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: <Widget>[
//                                         Row(
//                                           children: <Widget>[
//                                             new Text(
//                                                 snapshot.data["title"],
//                                                 style: ServiceProvider
//                                                     .instance.styles
//                                                     .cardTitle()),
//                                             Icon(
//                                               Icons.star,
//                                               color:
//                                                   going && starred == position
//                                                       ? UIData.pink
//                                                       : Colors.white,
//                                               size: 20,
//                                             ),
//                                           ],
//                                         ),
//                                         Divider(color: Colors.white),
//                                         Row(
//                                           children: <Widget>[
//                                             Icon(
//                                               Icons.location_on,
//                                               color: UIData.blue,
//                                               size: 20,
//                                             ),
//                                             Text(
//                                               snapshot.data["address"],
//                                               style: TextStyle(
//                                                   fontStyle: FontStyle.italic,
//                                                   fontSize: 12),
//                                             ),
//                                           ],
//                                         ),
//                                         Divider(
//                                           color: Colors.white,
//                                         ),
//                                         Row(
//                                           children: <Widget>[
//                                             Icon(
//                                               Icons.access_time,
//                                               color: UIData.black,
//                                               size: 17,
//                                             ),
//                                             Text(
//                                               ' ${snapshot.data["time"].hour.toString()}' +
//                                                   ':' +
//                                                   '${snapshot.data["time"].time.minute.toString().padRight(2, '0')}',
//                                               style: TextStyle(fontSize: 12),
//                                             ),
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
