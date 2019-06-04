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
    _getEventsData();
    print(widget.user.getName());
    one = PageOne(
      key: keyOne,
      auth: auth,
      user: widget.user,
      eventList: eventList,
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
      myEvent: myEvent,
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

  void _getEventsData()  async {
    QuerySnapshot eventDocs =  await Firestore.instance.collection("events").orderBy('time', descending: false).getDocuments();
    eventDocs.documents.forEach((doc) {
      eventList.add(Event(address: doc.data["address"], cat: doc.data["cat"], desc: doc.data["desc"], id: doc.data["id"], time: doc.data["time"] as DateTime,  title: doc.data["title"], imgUrl: doc.data["imgUrl"]));
    });

    eventList.forEach((e){
      if(e.id.contains(widget.user.userName)){
        myEvent.add(e);
      }

    });


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
  PageOne({Key key, this.auth, this.onSignOut, this.user, this.eventList, }) : super(key: key);
  final BaseAuth auth;
  final VoidCallback onSignOut;
  final User user;
  final List<Event> eventList;


  @override
  PageOneState createState() => PageOneState();
}

class PageOneState extends State<PageOne> {
  static final formKey = new GlobalKey<FormState>();
  final f = new DateFormat('yyyy-MM-dd hh:mm');


  int tapped = -1;
  double cardWidth;
  bool tap = false;

  bool going = false;

  int starred = -1;


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
                   MaterialPageRoute(builder: (context) => StatefullNew(user: widget.user.userName)),);
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

                    icon: Image.asset('lib/assets/images/filter_icon.png', scale: 10,),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => StateFilterPage()),);

                  },
              ),
            ),

        )],

          title: Image.asset('lib/assets/images/logo_tekst.png', fit: BoxFit.contain, scale: 8,),
            centerTitle: true,



    ),
        body: new SingleChildScrollView(


            child: new




          Stack(

          //child: new Stack(
            children: <Widget>[


              Column(
                children: <Widget>[

                    Align(
                    alignment: Alignment.topCenter,
                                child: Container(
                                  height: ServiceProvider.instance.screenService
                                      .getPortraitHeightByPercentage(context, 80),
                                  width: ServiceProvider.instance.screenService
                                      .getPortraitWidthByPercentage(context, 82),
                                  child: ListView.builder(
                                  // scrollDirection: Axis.vertical,
                                 //shrinkWrap: true,
                                  itemBuilder: (context, position){
                                    return Column(
                                      children: <Widget>[

                                        Divider(
                                          color: UIData.grey,
                                        ),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(_DateText(position),

                                           
                                          ),
                                        ),
                                       Divider(
                                         color: UIData.grey,
                                         height: 0.2,


                                       ),

                                        GestureDetector(
                                          onTap: () { _tapped(position);},


                                          child: Column(
                                            children: <Widget>[
                                              tap == true && tapped != null && tapped == position ?
                                                  SizedBox (
                                                    height: 310,
                                                    child: Card(
                                                      elevation: 0.0,
                                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),

                                                      child: Column(
                                                        children: <Widget>[
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            //crossAxisAlignment: CrossAxisAlignment.stretch,

                                                            children: <Widget>[
                                                              ClipRRect(
                                                                borderRadius: new BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                                                                child: Image.network(widget.eventList[position].imgUrl,

                                                                  height: 120,
                                                                  width: 287,
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
                                                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.white)),
                                                                child: Padding(
                                                                  padding: EdgeInsets.all(8),
                                                                  child: Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: <Widget>[
                                                                      Text("Beskrivelse:", style: TextStyle(fontWeight: FontWeight.bold)),
                                                                      Divider(
                                                                        height: 10,
                                                                        color: Colors.white,
                                                                      ),
                                                                      Text( '${widget.eventList[position].desc}', style: TextStyle(fontSize: 13)

                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),

                                                              ),

                                                            ),

                                                          Expanded(
                                                            child:


                                                          Container(
                                                            height: 40,
                                                            margin: EdgeInsets.only(top: 0),
                                                            width: ServiceProvider.instance.screenService
                                                                .getPortraitWidthByPercentage(context, 82),

                                                            decoration: new BoxDecoration(
                                                            color: Colors.pink,
                                                            borderRadius: new BorderRadius.only(
                                                                bottomLeft:  const  Radius.circular(8.0),
                                                                bottomRight: const  Radius.circular(8.0)),
                                                          ),
                                                            child:
                                                            FlatButton(
                                                            color: UIData.pink,
                                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                                                            padding: EdgeInsets.all(10),
                                                            onPressed: () {
                                                              //going = true;
                                                              _tapped(position);
                                                              _starred(position);


                                                          },
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: <Widget>[

                                                                Icon(going && starred == position ? Icons.star : Icons.star_border, color: Colors.white, size: 20,),
                                                                Padding(
                                                                  padding: EdgeInsets.all(3)
                                                                ),
                                                                Text("Interessert", style: TextStyle(color: Colors.white, fontSize: 13)),

                                                              ],
                                                            ),


                                                          ),),),




                                                        ],
                                                      ),








                                                    ),


                                                  ) : SizedBox(
                                                height: 130,
                                                child: Card(
                                                  elevation: 0.0,
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),

                                                  child: Column(
                                                    children: <Widget>[
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        //crossAxisAlignment: CrossAxisAlignment.stretch,

                                                        children: <Widget>[
                                                          ClipRRect(
                                                            borderRadius: new BorderRadius.only(topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)),
                                                            child: Image.network(widget.eventList[position].imgUrl,
                                                              height: 120,
                                                              width: 110,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: EdgeInsets.all(10),
                                                            child: Align(
                                                              alignment: Alignment.centerRight,
                                                              child:

                                                              Column(
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: <Widget>[

                                                                  Row(

                                                                    children: <Widget>[
                                                                      new Text(widget.eventList[position].title, style: ServiceProvider.instance.styles.cardTitle()),
                                                                      Icon(Icons.star, color: going && starred == position ? UIData.pink : Colors.white, size: 20,),
                                                                    ],
                                                                  ),


                                                                  Divider(
                                                                      color: Colors.white
                                                                  ),
                                                                  Row(
                                                                    children: <Widget>[
                                                                      Icon(Icons.location_on, color: UIData.blue, size: 20,),
                                                                      Text(widget.eventList[position].address, style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Divider(
                                                                    color: Colors.white,
                                                                  ),
                                                                  Row(
                                                                    children: <Widget>[
                                                                      Icon(Icons.access_time, color: UIData.black, size: 17,),
                                                                      Text(' ${widget.eventList[position].time.hour.toString()}' + ':' + '${widget.eventList[position].time.minute.toString().padRight(2, '0')}', style: TextStyle( fontSize: 12),
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

                                },
                                itemCount: widget.eventList.length,
                              ),


                      ),
                  ),
                  
                ],
              )
              ,


              Align(

              alignment: Alignment.center,






              ),
            ],
          ),


        ),
        );

  }

  void _starred(position) {
    setState((){
      if(going) {
        going = false;
        starred = position;
      } else {
        starred = position;
        going = true;
      }
    });
  }


  void _tapped(position) {
    setState((){
      if(tap) {
        tap = false; 
        tapped = position;
      } else {
         tap = true; 
        tapped = position;
      }

    });

  }

  String _DateText(int position) {
    if (widget.eventList[position].time.month == 1){
      return '${widget.eventList[position].time.day.toString()}' + '. ' + 'Januar';
    }
     else if (widget.eventList[position].time.month == 2){
       return '${widget.eventList[position].time.day.toString()}' + '. ' + 'Februar';
     }
     else if (widget.eventList[position].time.month == 3){
        return '${widget.eventList[position].time.day.toString()}' + '. ' + 'Mars';
      }
      else if (widget.eventList[position].time.month == 4){
        return '${widget.eventList[position].time.day.toString()}' + '. ' + 'April';
      }
       else if (widget.eventList[position].time.month == 5){
         return '${widget.eventList[position].time.day.toString()}' + '. ' + 'Mai';
       }
       else if (widget.eventList[position].time.month == 6){
          return '${widget.eventList[position].time.day.toString()}' + '. ' + 'Juni';
        }
        else if (widget.eventList[position].time.month == 7){
          return '${widget.eventList[position].time.day.toString()}' + '. ' + 'Juli';
        }
         else if (widget.eventList[position].time.month == 8){
           return '${widget.eventList[position].time.day.toString()}' + '. ' + 'August';
         }
         else if (widget.eventList[position].time.month == 9){
            return '${widget.eventList[position].time.day.toString()}' + '. ' + 'September';
          }
          else if (widget.eventList[position].time.month == 10){
            return '${widget.eventList[position].time.day.toString()}' + '. ' + 'Oktober';
          }
           else if (widget.eventList[position].time.month == 11){
             return '${widget.eventList[position].time.day.toString()}' + '. ' + 'November';
           }
            else if (widget.eventList[position].time.month == 12){
              return '${widget.eventList[position].time.day.toString()}' + '. ' + 'Desember';
            }
    
  }

  Future<void> _Refresh() async {
    print('refreshing');
    //setState(() => _getEventsData()


  }
}



















class StateFilterPage extends StatefulWidget {

  StateFilterPage({this.user});
  final User user;


  @override
  FilterPage createState() => FilterPage();
}

class FilterPage extends State<StateFilterPage> {
  void initState() {
    super.initState();
  }


  List<String> cate = ['lib/assets/images/skole.png', 'lib/assets/images/kaffe.png', 'lib/assets/images/gaming.png', 'lib/assets/images/fest.png', 'lib/assets/images/prosjekt.png' ];
  List<String> cat =  ["Skolejobbing", "Kaffe", "Gaming", "Fest", "Prosjekt" ];

  String dropdown = '';

  bool skole = false;
  bool kaffe = false;
  bool gaming = false;
  bool fest = false;
  bool prosjekt = false;

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

                   icon: Image.asset('lib/assets/images/filter_icon_selected.png', scale: 10, ),
               onPressed: () {
                 Navigator.pop(context);

               },
          ),
        ),
    )],

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
              child: Text("Sorter etter:", style: TextStyle(color: UIData.black, fontSize: 13, )),
            ),
           Divider(
             color: UIData.grey,
           ),


           Container(
             width: ServiceProvider.instance.screenService
                 .getPortraitWidthByPercentage(context, 82),
             //height: 50,
             decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.white),
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
                           items: <String>['Avstand', 'Popularitet','']
                             .map<DropdownMenuItem<String>>((String value) {
                               return DropdownMenuItem(
                                 value: value,
                                 child: Padding(
                                   padding: EdgeInsets.all(10),
                                   child: Text(value),
                                 ),
                               );
                             })

                             .toList(),
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
             child: Text("Filtrer:", style: TextStyle(color: UIData.black, fontSize: 13, )),
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
                       shape: (nullstill && skole ?   RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(width: 1, style: BorderStyle.solid, color: UIData.black)) :  RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(width: 0, style: BorderStyle.none))),



                       child: Padding(
                         padding: EdgeInsets.all(7),
                         child: Column(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: <Widget>[
                             Image.asset(cate[0], scale: 20,),
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
                       shape: (nullstill && kaffe ?   RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(width: 1, style: BorderStyle.solid, color: UIData.black)) :  RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(width: 0, style: BorderStyle.none))),



                       child: Padding(
                         padding: EdgeInsets.all(7),
                         child: Column(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: <Widget>[
                             Image.asset(cate[1], scale: 20,),
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
                       shape: (nullstill && gaming ?   RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(width: 1, style: BorderStyle.solid, color: UIData.black)) :  RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(width: 0, style: BorderStyle.none))),



                       child: Padding(
                         padding: EdgeInsets.all(7),
                         child: Column(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: <Widget>[
                             Image.asset(cate[2], scale: 20,),
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
                       shape: (nullstill && fest ?   RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(width: 1, style: BorderStyle.solid, color: UIData.black)) :  RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(width: 0, style: BorderStyle.none))),



                       child: Padding(
                         padding: EdgeInsets.all(7),
                         child: Column(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: <Widget>[
                             Image.asset(cate[3], scale: 20,),
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
                       shape: (nullstill && prosjekt  ?  RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(width: 1, style: BorderStyle.solid, color: UIData.black)) :  RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(width: 0, style: BorderStyle.none))),



                       child: Padding(
                         padding: EdgeInsets.all(7),
                         child: Column(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: <Widget>[
                             Image.asset(cate[4], scale: 20,),
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
                       shape: (RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(width: 0, style: BorderStyle.none))),



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
                       shape: (RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(width: 0, style: BorderStyle.none))),



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
                       shape: (RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(width: 0, style: BorderStyle.none))),



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
                       shape: (RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(width: 0, style: BorderStyle.none))),



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
                 nullstill = false;
                 if (prosjekt) {
                   pressedProsjekt();
                   nullstill = true;
                 }
                 if (kaffe) {
                   pressedKaffe();
                   nullstill = true;
                 }
                 if (gaming) {
                   pressedGaming();
                   nullstill = true;
                 }
                 if (skole) {
                   pressedSkole(); 
                   nullstill = true;
                 }
                 if (fest) {
                   pressedFest();
                   nullstill = true;
                 }
               
               

               },
               child: Text("Nullstill filter", style: TextStyle(color: UIData.blue, fontSize: 15),),
             ),
             Divider(                   
               color: UIData.grey,
               height: 20,
             ),                         
             RaisedButton(
               color: UIData.pink,
               elevation: 0,
               padding: EdgeInsets.fromLTRB(40, 15, 40, 15),
               shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(100)), side: BorderSide(style: BorderStyle.none)),
               onPressed: () {
                 if (kaffe) {
                   print(cat[1]);
                 }
                 if (skole) {
                   print(cat[0]);
                 }
                 if (gaming) {
                   print(cat[2]);
                 }
                 if (fest) {
                   print(cat[3]);
                 }
                 if (prosjekt) {
                   print(cat[4]);
                 }
                 //print("${widget.user.userName}");
                Navigator.pop(context);
               },
               child: Text("Bruk filter", style: TextStyle(color: Colors.white))
             ),                                                                                                                                                                                                                                                                                                                                                                                                    

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
      }
      else {
        skole = true;
      }
    } );
  }

    void pressedKaffe() {
    setState(() {
       if(kaffe){
         kaffe = false;
       }
       else {
         kaffe = true;
       }
    })    ;
    }

    void pressedGaming() {
    setState(() {
      if (gaming) {
        gaming = false;
      }
      else {
        gaming = true;
      }
    });
    }
    void pressedFest(){
    setState(() {
      if (fest) {
        fest = false;
      }
      else {
        fest = true;
      }
    });
    }
    void pressedProsjekt(){
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
  Event({this.imgUrl, this.address, this.cat, this.desc, this.id, this.time, this.title});


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

  var dbUrl;

  File imgUrl;

  bool choosen = false;


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
  List<String> cate = ['lib/assets/images/skole.png', 'lib/assets/images/kaffe.png', 'lib/assets/images/gaming.png', 'lib/assets/images/fest.png', 'lib/assets/images/prosjekt.png' ];
  List<String> cat =  ["Skolejobbing", "Kaffe", "Gaming", "Fest", "Prosjekt" ];

  bool tap = false;
  int tapped = -1;




  Future<Null> selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: new DateTime(2018),
        lastDate: new DateTime(2020),
    );
    if(picked != null && picked != _date) {
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
    if(picked != null && picked != _time) {
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
    onTap: (){
      this._removeKeyboard(context);

    },
    child:  Scaffold(
      backgroundColor: UIData.grey,
      appBar: AppBar(
        elevation: 1,
        iconTheme: IconThemeData(
          color: UIData.black,
        ),
        centerTitle: true,

        title: Text("Nytt event", style: ServiceProvider.instance.styles.title(),),
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
                    child: Text("Kategori:"),

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
                                //RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(width: 2, style: BorderStyle.solid));

                              },
                              splashColor: UIData.grey,
                            highlightColor: UIData.grey,
                              child: Card(
                                shape: ( tap == true && tapped != null && tapped == index ? RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(width: 1, style: BorderStyle.solid, color: UIData.black)) :
                                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(width: 0, style: BorderStyle.none))),

                                child: Padding(
                                  padding: EdgeInsets.all(7),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Image.asset(cate[index], scale: 20,),
                                      Divider(
                                        color: Colors.white,
                                        height: 10,
                                      ),
                                      Text(cat[index], style: TextStyle(fontSize: 10)),

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
                            child:

                            FlatButton.icon(

                              onPressed: () {
                                selectDate(context);
                              },
                              icon: Icon(Icons.calendar_today, color: UIData.blue, size: 20,),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8)), side: BorderSide(style: BorderStyle.none)),

                              color: Colors.white,

                              label: (datovalg? Text(dats, style: TextStyle(color: UIData.black),) : Text("Dato", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.normal))),
                            ),
                          ),


                          Padding(
                            padding: EdgeInsets.all(5),
                          ),
                          SizedBox(
                            width: 140,
                            height: 50,
                            child:

                            FlatButton.icon(
                              onPressed: () {
                                selectTime(context);
                              },
                              icon: Icon(Icons.access_time, color: UIData.blue, size: 22),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8)), side: BorderSide(style: BorderStyle.none)),

                              color: Colors.white,

                              label: (tidspunkt? Text(tids, style: TextStyle(color: UIData.black),) : Text("Tid", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.normal))),
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
                    height: 50,
                    child: TextField(
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        hintText: "Tittel",
                        filled: true,
                        contentPadding: EdgeInsets.all(17.0),
                        fillColor: Colors.white,
                        hintStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(width: 0, style: BorderStyle.none)),

                      ),
                      onChanged: (text) {
                        tit = text;
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
                    height: 50,
                    child: TextField(
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        hintText: "Addresse",
                        filled: true,
                        contentPadding: EdgeInsets.all(17.0),
                        fillColor: Colors.white,
                        hintStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(width: 0, style: BorderStyle.none)),
                      ),
                      onChanged: (text) {
                        add = text;
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
                        textInputAction: TextInputAction.done,
                        textCapitalization: TextCapitalization.sentences,
                        maxLines: 6,
                        decoration: InputDecoration(
                          hintText: "Beskrivelse",
                          filled: true,
                          contentPadding: EdgeInsets.all(17.0),
                          fillColor: Colors.white,
                          hintStyle: TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(width: 0, style: BorderStyle.none)),
                        ),
                        onChanged: (text) {
                          bes = text;
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
                        child: Text( "Legg til bilde:"
                        ),
                      ),
                      Divider(
                        color: UIData.grey,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child:  choosen?
                            Column(
                              //mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                FlatButton.icon(
                                  onPressed: openOptions,
                                  color: UIData.grey,
                                  icon: Icon(Icons.replay, color: UIData.blue),
                                  label:  Text  ("Ta på nytt", style: TextStyle(color: UIData.blue, fontWeight: FontWeight.bold)),


                                ),

                                Container(
                                    height: 200,
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),),

                                    child: Image.file(
                                      imgUrl,
                                      fit: BoxFit.fill,

                                      // width: 200,
                                      //height: 400,
                                    )
                                ),


                              ],
                            )

                         :


                        Container(

                          height: 80,

                          child: FittedBox(

                            child:  FloatingActionButton(
                              onPressed: () {
                                openOptions();
                                //choosen = true;

                              },
                              child:
                              Icon(Icons.photo_camera, size: 30.0,),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0)), ),
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
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(100)), side: BorderSide(style: BorderStyle.none)),
                    onPressed: () {
                      uploadImage(imgUrl);



                      print("post pressed");

                      DateTime titi = new DateTime(_date.year, _date.month, _date.day, _time.hour, _time.minute);

                      id = new DateTime.now().millisecondsSinceEpoch;
                      String name = widget.user;
                      String idu = name + " " + id.toString();


                      //if(add != null && kat != null && bes != null && titi != null && dbUrl != null) {

                          var data =
                          {
                            "address": add,
                            "cat": kat,
                            "desc": bes,
                            "id": idu,
                            "time": titi,
                            "title": tit,
                            "imgUrl": dbUrl,
                          };
                          Firestore.instance.document("events/$idu").setData(data);


                       Navigator.pop(context);


                    },
                    child: Text("Post event", style: TextStyle(color: Colors.white))
                  )

                ],
                
              ),
            ),

          ),
          Align(
          

          ),
        ],




      ),
      ),
    ),
    );
  }

  String saveAdd(a) {
    print(a);
    return a;
  }

  String saveTit(t) {
    print (t);
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
    return showDialog(context: context,
        builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),

        content:
         new SingleChildScrollView(
          child: new ListBody(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(Icons.photo_camera, color: UIData.blue),
                  Padding(
                    padding: EdgeInsets.all(7.0),
                  ),
                  GestureDetector(
                    child: new Text('Ta et bilde', style: TextStyle(fontSize: 20) ,),
                    onTap:
                      openCamera,



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
                    child: new Text('Velg fra kamerarull', style: TextStyle(fontSize: 20)),
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
    var picture = await ImagePicker.pickImage(
        source: ImageSource.camera );

    setState((){
      imgUrl = picture;
      choosen = true;

    });

    //uploadImage(imgUrl);


    dbUrl = picture.path.toString();
    print("You selected: " + dbUrl);


  }

  Future openGallery() async {
    var gallery = await ImagePicker.pickImage(
        source: ImageSource.gallery);
    setState((){
      imgUrl = gallery;
      choosen = true;

    });

    //uploadImage(imgUrl);

    dbUrl = gallery.path.toString();
    print("You selected: " + dbUrl);
    //saveUrlDb(dbUrl);
  }

  void uploadImage(imgUrl) async {

    final StorageReference imgRef = FirebaseStorage.instance.ref().child("Event Images");
    var timeKey = new DateTime.now();
    final StorageUploadTask upTask = imgRef.child(timeKey.toString() + ".jpg").putFile(imgUrl);

    var url = await (await upTask.onComplete).ref.getDownloadURL();
    dbUrl = url.toString();
    print("upload $dbUrl");




  }

    void _tapped(index) {
      setState((){
        if(tap) {
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


//## return InkWell(
//                          onTap: () {
//                            print("tapped: $index");
//                            },
//                          child: Container(
//                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0), color: Colors.white),
//                            width: 80,
//                            alignment: Alignment.center,
//                            //color: Colors.white,
//                            child: Image.asset(cate[index], ),
//                            padding: EdgeInsets.all(20),
//                          ),
//
//                        );



//##  Padding(
//                                                            padding: EdgeInsets.fromLTRB(0, 80, 0, 0),
//                                                            child:
//                                                            SizedBox(
//                                                              height: 40,
//                                                              child:
//
//                                                              Card(
//                                                                elevation: 0,
//                                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30), side: BorderSide(color: UIData.pink, width: 1)),
//                                                                //decoration: BoxDecoration(borderRadius: BorderRadius.circular(60), border: index == 0 ? Border.all(width: 3, color: UIData.pink) : Border.all(color: Colors.white) ),
//                                                                child: ClipRRect(
//                                                                  borderRadius: new BorderRadius.circular(50),
//                                                                  child: Image.asset("lib/assets/images/fortnite.jpg", // fra list [index]
//
//                                                                    width: 32,
//                                                                    fit: BoxFit.cover,
//                                                                  ),
//                                                                ),
//                                                              ), ),

//                                                          ),








//## } else {
//                       //Scaffold.of(context).showSnackBar(new SnackBar(content: new Text("Alle felt må fylles ut")));
//                      Toast.show("Alle felt må fylles inn", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM, backgroundColor: UIData.black, backgroundRadius: 8);
//                     }





//## https://firebasestorage.googleapis.com/v0/b/smidigprosjekt.appspot.com/o/Event%20Images%2F2019-06-04%2013%3A15%3A34.105184.jpg?alt=media&token=e527f008-a911-4004-be0d-1f3e58c5d924
//## https://firebasestorage.googleapis.com/v0/b/smidigprosjekt.appspot.com/o/Event%20Images%2F2019-06-04%2013%3A15%3A40.973055.jpg?alt=media&token=78c0590f-6637-426e-97e0-2d65e9d8a4a0

