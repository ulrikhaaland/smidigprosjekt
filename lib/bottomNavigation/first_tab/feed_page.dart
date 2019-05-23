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

    pages = [one, two, three, four,];

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
   QuerySnapshot eventDocs = await Firestore.instance.collection("events").orderBy('time', descending: false).getDocuments();
   eventDocs.documents.forEach((doc) {
     eventList.add(Event(address: doc.data["address"], cat: doc.data["cat"], desc: doc.data["desc"], id: doc.data["id"], time: doc.data["time"] as DateTime,  title: doc.data["title"]));
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

            Align(
              alignment: Alignment(0.3,0.4),
              child: IconButton(icon: new Image.asset("lib/assets/images/filter_icon.png", scale: 10,), onPressed: null)

            ),

          ],
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
                        style: ServiceProvider.instance.styles.month(),
                      )

                    ),


                  ),
                  new Divider(color: Colors.white,),


                  Align(
                    alignment: Alignment.topCenter,
                                child: Container(
                                  height: 300,
                                  width: 300,



                                  child: ListView.builder(
                                  itemBuilder: (context, position){
                                    return Column(
                                      children: <Widget>[

                                        Divider(
                                          color: UIData.grey,
                                        ),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            '${eventList[position].time.day.toString()}' + '/' + '${eventList[position].time.month.toString()}',
                                            style: ServiceProvider.instance.styles.cardTitle(),
                                          ),
                                        ),
                                       Divider(
                                         color: UIData.grey,
                                         height: 0.2,


                                       ),
                                        Card(
                                          elevation: 0.0,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),

                                          child: Padding(
                                            padding: EdgeInsets.all(17),
                                            

                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: <Widget>[
                                                new Text(eventList[position].title, style: ServiceProvider.instance.styles.cardTitle()),
                                                Divider(
                                                    color: Colors.white
                                                ),
                                                new Text(eventList[position].address),
                                                Divider(
                                                  color: Colors.white,
                                                ),
                                                new Text(' ${eventList[position].time.hour.toString()}' + ':' + '${eventList[position].time.minute.toString()}' + '0'),


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
                child:FloatingActionButton(
                  child: new Icon(Icons.add),
                  onPressed: () {
                    print('button tapped');
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => NewEventPage()),);
                  },
                  backgroundColor: UIData.pink,
                  elevation: 0.0,


                )
              ),
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


class NewEventPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UIData.grey,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: UIData.black,
        ),
        centerTitle: true,

        title: Text("Nytt event", style: ServiceProvider.instance.styles.title(),),
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
                    width: 300.0,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Tittel",
                        filled: true,
                        contentPadding: EdgeInsets.all(17.0),
                        fillColor: Colors.white,
                        hintStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(width: 0, style: BorderStyle.none)),

                      ),
                      onChanged: (text) {
                        String value = text;
                      },
                      onSubmitted: (text) {
                        String t = text;
                        print(t);
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
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(width: 0, style: BorderStyle.none)),
                      ),
                      onChanged: (text) {
                        String value = text;
                      },
                      onSubmitted: (text) {
                        String a = text;
                        print(a);
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
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(width: 0, style: BorderStyle.none)),
                      ),
                      onChanged: (text) {
                        String value = text;
                      },
                      onSubmitted: (text) {
                        String tid = text;
                        print(tid);
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
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(width: 0, style: BorderStyle.none)),
                        ),
                        onChanged: (text) {
                          String value = text;
                        },
                        onSubmitted: (text) {
                          String b = text;
                          print(b);
                        },

                      ),
                    ),

                  ),
                  Divider(
                    color: UIData.grey,
                  ),

                  Container(
                    height: 100,
                    width: 100,
                    child: FittedBox(
                      child: FloatingActionButton(
                        onPressed: () {},
                        child: Icon(Icons.photo_camera, size: 30.0,),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
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
                     Navigator.pop(context);
                    },
                  )

                ],
                
              ),
            ),

          ),
          Align(
          

          ),
        ],




      ),
    );
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