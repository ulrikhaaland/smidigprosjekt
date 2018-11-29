import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../../auth.dart';
import '../second_tab/game_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../root_page.dart';
import '../../utils/uidata.dart';
import '../third_tab/user_page.dart';
import '../../objects/user.dart';
import '../../utils/layout.dart';
import '../../widgets/primary_button.dart';

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
  // final Key keyThree = PageStorageKey('pageThree');

  final BaseAuth auth = Auth();

  Firestore firestoreInstance = Firestore.instance;

  int currentTab = 0;

  String currentUser;

  PageOne one;
  GamePage two;
  UserPage three;
  // DisplaySearch three;
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

    three = UserPage(
      key: keyTwo,
      auth: auth,
      onSignOut: () => _signOut(),
      user: widget.user,
    );

    pages = [one, two, three];

    currentPage = one;

    super.initState();
    setPage();
  }

  void _signOut() async {
    try {
      await auth.signOut();
      widget.onSignOut();
    } catch (e) {
      print(e);
    }
  }

  setPage() {
    setState(() {
      currentTab = 1;
      currentPage = two;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UIData.darkest,
      body: PageStorage(
        child: currentPage,
        bucket: bucket,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        currentIndex: currentTab,
        onTap: (int index) {
          setState(() {
            currentTab = index;
            currentPage = pages[index];
          });
        },
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            backgroundColor: UIData.darkest,
            icon: Icon(Icons.search),
            title: Text('Find'),
          ),
          BottomNavigationBarItem(
            backgroundColor: UIData.darkest,
            icon: Icon(Icons.group),
            title: Text(
              "Groups",
              style: new TextStyle(),
            ),
          ),
          BottomNavigationBarItem(
            backgroundColor: UIData.darkest,
            icon: Icon(
              Icons.settings,
            ),
            title: Text(
              "Settings",
              style: new TextStyle(),
            ),
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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: UIData.dark,
        appBar: new AppBar(
          backgroundColor: UIData.darkest,
          title: new Text(
            "Find Group",
            style: new TextStyle(fontSize: UIData.fontSize24),
          ),
        ),
        body: Container());
  }
}
