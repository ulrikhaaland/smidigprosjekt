import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../../auth.dart';
import '../second_tab/game_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../root_page.dart';
import '../../utils/uidata.dart';
import '../third_tab/group_page.dart';
import '../../objects/user.dart';
import '../../utils/layout.dart';
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
  PageOne({Key key, this.auth, this.onSignOut, this.user}) : super(key: key);
  final BaseAuth auth;
  final VoidCallback onSignOut;
  final User user;

  @override
  PageOneState createState() => PageOneState();
}

class PageOneState extends State<PageOne> {
  static final formKey = new GlobalKey<FormState>();

  List<Event> eventList = [];

  @override
  void initState() {
    super.initState();
    _getEventsData();
  }

  void _getEventsData() async {
   QuerySnapshot eventDocs = await Firestore.instance.collection("events").getDocuments();
   eventDocs.documents.forEach((doc) {
     eventList.add(Event(address: doc.data["address"], cat: doc.data["cat"], desc: doc.data["data"], id: doc.data["id"], time: doc.data["data"], title: doc.data["title"]));
   });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: UIData.grey,
        appBar: new AppBar(
          backgroundColor: Colors.white,
          actions: <Widget>[
            new Image.asset("lib/assets/images/logo_tekst.png", scale: 8,),
            new IconButton(icon: new Image.asset("lib/assets/images/filter_icon.png", scale: 10,), onPressed: null)
          ],
        ),
        body: new Center(
          child:
          new ListView.builder(
            itemCount: 5,
              itemBuilder: (context, i) {
              return new Column(
                children: <Widget>[
                  new Container(
                    padding: new EdgeInsets.all(16.0),
                  decoration: new BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  child: new Column(
                  children: eventList.map((e) {
                    Text(e.title);
                  }).toList()
              ),
              ),
                  new Divider(),
                ],
              );

              },
          )
        ));
  }
}

class Event {
  Event({this.address, this.cat, this.desc, this.id, this.time, this.title});

  final String address;
  final String cat;
  final String desc;
  final int id;
  final Timestamp time;
  final String title;


}