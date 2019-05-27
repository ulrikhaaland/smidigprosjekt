import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:smidigprosjekt/service/service_provider.dart';
import '../../auth.dart';
import '../second_tab/game_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../../root_page.dart';
import '../../utils/uidata.dart';
import '../third_tab/group_page.dart';
import '../../objects/user.dart';
import 'package:image_picker/image_picker.dart';
import '../../utils/layout.dart';
import 'package:intl/intl.dart';
import '../../widgets/primary_button.dart';
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
  final Key keyOne = PageStorageKey('pageOne');
  final Key keyTwo = PageStorageKey('pageTwo');
  final Key keyThree = PageStorageKey('pageThree');
  final Key keyFour = PageStorageKey('pageFour');

  final BaseAuth auth = Auth();

  Firestore firestoreInstance = Firestore.instance;

  int currentTab = 0;

  String currentUser;

  PageOne one;
  GamePage two;
  GroupPage three;
  ProfilePage four;

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
    );

    two = GamePage(
      key: keyTwo,
      auth: auth,
      user: widget.user,
    );

    three = GroupPage(
      user: widget.user,
    );

    four = ProfilePage(
      user: widget.user,
      onSignOut: () => _signOut(),
    );

    pages = [
      one,
      two,
      three,
      four,
    ];

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
  PageOne({Key key, this.auth, this.onSignOut, this.user}) : super(key: key);
  final BaseAuth auth;
  final VoidCallback onSignOut;
  final User user;

  @override
  PageOneState createState() => PageOneState();
}

class PageOneState extends State<PageOne> {
  static final formKey = new GlobalKey<FormState>();
  final f = new DateFormat('yyyy-MM-dd hh:mm');
  List<Event> eventList = [];

  @override
  void initState() {
    super.initState();
    _getEventsData();
  }

  void _getEventsData() async {
    QuerySnapshot eventDocs = await Firestore.instance
        .collection("events")
        .orderBy('time', descending: false)
        .getDocuments();
    eventDocs.documents.forEach((doc) {
      eventList.add(Event(
          address: doc.data["address"],
          cat: doc.data["cat"],
          desc: doc.data["desc"],
          id: doc.data["id"],
          time: doc.data["time"] as DateTime,
          title: doc.data["title"]));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UIData.grey,
      appBar: new AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'lib/assets/images/logo_tekst.png',
              fit: BoxFit.contain,
              scale: 8,
            ),
          ],
        ),
      ),
      body: new Stack(
        //child: new Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text(
                      "juni",
                      style: ServiceProvider
                          .instance.instanceStyleService.appStyle.body1,
                    )),
              ),
              new Divider(
                color: Colors.white,
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  height: 400,
                  width: 300,
                  child: ListView.builder(
                    itemBuilder: (context, position) {
                      return Column(
                        children: <Widget>[
                          Divider(
                            color: UIData.grey,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '${eventList[position].time.day.toString()}' +
                                  '/' +
                                  '${eventList[position].time.month.toString()}',
                              style: ServiceProvider
                                  .instance.instanceStyleService.appStyle.title,
                            ),
                          ),
                          Divider(
                            color: UIData.grey,
                            height: 0.2,
                          ),
                          Card(
                            elevation: 0.0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0)),
                            child: Padding(
                              padding: EdgeInsets.all(17),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  new Text(eventList[position].title,
                                      style: ServiceProvider.instance
                                          .instanceStyleService.appStyle.title),
                                  Divider(color: Colors.white),
                                  new Text(eventList[position].address),
                                  Divider(
                                    color: Colors.white,
                                  ),
                                  new Text(
                                      ' ${eventList[position].time.hour.toString()}' +
                                          ':' +
                                          '${eventList[position].time.minute.toString()}' +
                                          '0'),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                    itemCount: eventList.length,
                  ),
                ),
              ),
            ],
          ),
          Align(
              alignment: Alignment(0.8, 0.9),
              child: FloatingActionButton(
                child: new Icon(Icons.add),
                onPressed: () {
                  print('button tapped');
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => StatefullNew()),
                  );
                },
                backgroundColor: UIData.pink,
                elevation: 0.0,
              )),
        ],
      ),
    );
  }

  void opencard() {
    final open = true;
  }
}

class Event {
  Event({this.address, this.cat, this.desc, this.id, this.time, this.title});

  final String address;
  final String cat;
  final String desc;
  final int id;
  final DateTime time;
  final String title;
}

class StatefullNew extends StatefulWidget {
  StatefullNew({Key key}) : super(key: key);

  @override
  NewEventPage createState() => NewEventPage();
}

class NewEventPage extends State<StatefullNew> {
  String dropdownValue = "Skolejobbing";
  String add = "";
  String tit = "";
  String bes = "";
  String tim;
  String kat = "";

  List<Event> newEvent = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UIData.grey,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: UIData.black,
        ),
        centerTitle: true,
        title: Text(
          "Nytt event",
          style: ServiceProvider.instance.instanceStyleService.appStyle.title,
        ),
        backgroundColor: Colors.white,
      ),
      body: new Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.all(30.0),
              child: Column(
                children: <Widget>[
                  Container(
                    width: 300,
                    //color: Colors.white,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colors.white),
                    child: SizedBox(
                      height: 55,
                      child: Padding(
                        padding: EdgeInsets.all(17),
                        child: DropdownButton<String>(
                          //disabledHint: Text("hei"),
                          value: dropdownValue,
                          style: TextStyle(color: Colors.grey, fontSize: 16),

                          elevation: 0,
                          iconSize: 30,
                          onChanged: (String newValue) {
                            setState(() {
                              dropdownValue = newValue;
                              print(newValue);
                              kat = newValue;
                              saveKat(newValue);
                            });
                          },
                          hint: Text("Kategori:"),
                          items: <String>[
                            "Skolejobbing",
                            "Kaffe",
                            "Gaming",
                            "Prosjekt",
                            "Fest"
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                  Divider(color: UIData.grey),
                  Container(
                    width: 300.0,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Tittel",
                        filled: true,
                        contentPadding: EdgeInsets.all(17.0),
                        fillColor: Colors.white,
                        hintStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide:
                                BorderSide(width: 0, style: BorderStyle.none)),
                      ),
                      onChanged: (text) {
                        String value = text;
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
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Addresse",
                        filled: true,
                        contentPadding: EdgeInsets.all(17.0),
                        fillColor: Colors.white,
                        hintStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide:
                                BorderSide(width: 0, style: BorderStyle.none)),
                      ),
                      onChanged: (text) {
                        String value = text;
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
                    width: 300.0,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Tidspunkt",
                        filled: true,
                        contentPadding: EdgeInsets.all(17.0),
                        fillColor: Colors.white,
                        hintStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide:
                                BorderSide(width: 0, style: BorderStyle.none)),
                      ),
                      onChanged: (text) {
                        String value = text;
                      },
                      onSubmitted: (text) {
                        String tid = text;
                        //print(tid);
                        tim = text;
                        saveTid(tid);
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
                        maxLines: 10,
                        decoration: InputDecoration(
                          hintText: "Beskrivelse",
                          filled: true,
                          contentPadding: EdgeInsets.all(17.0),
                          fillColor: Colors.white,
                          hintStyle: TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(
                                  width: 0, style: BorderStyle.none)),
                        ),
                        onChanged: (text) {
                          String value = text;
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
                  Text("Legg til bilde: "),
                  Divider(
                    color: UIData.grey,
                  ),
                  Container(
                    height: 100,
                    width: 100,
                    child: FittedBox(
                      child: FloatingActionButton(
                        onPressed: () {
                          openOptions();
                        },
                        child: Icon(
                          Icons.photo_camera,
                          size: 30.0,
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0))),
                        backgroundColor: Colors.white,
                        foregroundColor: UIData.black,
                        elevation: 0.0,
                      ),
                    ),
                  ),
                  Divider(
                    color: UIData.grey,
                  ),
                  PrimaryButton(
                    text: "Post event",
                    padding: 52,
                    onPressed: () {
                      print("post pressed");
                      newEvent.add(Event(
                          address: add,
                          cat: kat,
                          desc: bes,
                          id: 10,
                          time: new DateTime(2019),
                          title: tit));
                      for (var item in newEvent) print(item.address.toString());
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            ),
          ),
          Align(),
        ],
      ),
    );
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
  }

  Future openGallery() async {
    var gallery = await ImagePicker.pickImage(source: ImageSource.gallery);
  }
}

//##  new ListView.builder(
//            itemCount: eventList.length,
//              itemBuilder: (context, i) {
//              return new Column(
//                children: <Widget>[
//                  new Container(
//
//                    padding: new EdgeInsets.all(16.0),
//                  decoration: new BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(8.0))),
//                  child: new Column(
//                  children: <Widget>[
//                 for(var item in eventList)new Text(item.title),
//                    for(var item in eventList) new Text(item.address),
//
//
//                  ]
//
//
//
//
//
//
//              ),
//              ),
//                  new Divider(),
//                ],
//              );
//
//              },
//          )
