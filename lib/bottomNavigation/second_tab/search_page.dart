import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smidigprosjekt/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smidigprosjekt/service/service_provider.dart';
import 'package:smidigprosjekt/utils/uidata.dart';
import 'package:smidigprosjekt/userSearch/search.dart';
import 'package:smidigprosjekt/objects/user.dart';

SearchBar searchBar;
bool _fresh = false;

AppBar _buildAppBar(BuildContext context) {
  return new AppBar(
    title: new Text("Søk etter medlemmer"),
    actions: <Widget>[
      searchBar.getSearchAction(context),
    ],
  );
}

class SearchPage extends StatefulWidget {
  
  const SearchPage({Key key, this.auth, this.user, this.onSignOut})
      : super(key: key);
  final BaseAuth auth;
  final VoidCallback onSignOut;
  final User user;
  @override

  SearchPageState createState() => SearchPageState();
}






class SearchPageState extends State<SearchPage> {
  static final formKey = new GlobalKey<FormState>();
  var items = List<String>();
  var items2 = List<String>();


  //final Firestore firestoreInstance = Firestore.instance;
  //final BaseAuth auth = Auth();

  int screen = 0;

  SearchPageState() {
    searchBar = new SearchBar(
      showClearButton: true,
      inBar: true,
      buildDefaultAppBar: _buildAppBar,
      setState: setState,
    );
  }

  /*
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView(
        physics: BouncingScrollPhysics(), // if you want IOS bouncing effect, otherwise remove this line
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),//change the number as you want
        children: images.map((url) {
          return Card(child: Image.network(url));
        }).toList(),
      ),
    );
  }*/



  @override
  initState() {
    super.initState();
    items.add("Carl");
    items.add("John");
    items.add("Eric");
    items.add("Dan");
  }

  @override
  dispose() {
    super.dispose();
  }

    void filterSearchResults(String query) {
    
    List<String> dummySearchList = List<String>();
      dummySearchList.addAll(items);
        if(query.isNotEmpty) {
          List<String> dummyListData = List<String>();
          dummySearchList.forEach((item) {
            if(item.contains(query)) {
              dummyListData.add(item);
            }
          });
          setState(() {
            items.clear();
            items.addAll(dummyListData);
          });
          return;
      } else {
        setState(() {
          items.clear();
          items.addAll(items);
        });
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      

        backgroundColor: UIData.grey,
        resizeToAvoidBottomPadding: true,
        //backgroundColor: UIData.white,
        appBar: new AppBar(

          backgroundColor: Colors.white,
          elevation: 1,
          centerTitle: true,
          title: new Text(
            "Søk",
            style: ServiceProvider.instance.styles.title(),

          ),

          // backgroundColor: UIData.green,
        ),



        body:

        new Stack(
          //alignment: Alignment.center,

          children: [

            Column(

              children: <Widget>[

                Align(

                  alignment: Alignment.center,

                  child: Container(
                    height: 50,

                    //color: Colors.white,
                    margin: EdgeInsets.only(top: 20),
                    width: 300,
                    

                    child: TextField(
                      
                      
                      autocorrect: false,
                      style: new TextStyle(color: Colors.black),
                      decoration: InputDecoration(

                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(width: 0, style: BorderStyle.none)),

                        prefixIcon: Icon(Icons.search, color: UIData.blue),
                        fillColor: Colors.white,
                        filled: true,
                        labelText: 'Søk etter personer..',
                        labelStyle: new TextStyle(color: Colors.grey[700]),

                      ),

                      

                      onChanged: (String value) {

                        filterSearchResults(value);

                        // groupSearchName = value.toLowerCase();
                        // if (screen == 0) {
                        //   setState(() {
                        //     screen = 1;

                        //     setScreen();
                        //   });
                        // } else if (value == "") {
                        //   setState(() {
                        //     screen = 0;

                        //     setScreen();
                        //   });
                        // } else if (screen == 1) {
                        //   setState(() {
                        //     setScreen();
                        //   });
                        // }

                      },
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.all(10)
                ),


                new SingleChildScrollView(
                
                child: Center(
                  child: new SizedBox(
                    height: ServiceProvider.instance.screenService
                        .getPortraitHeightByPercentage(context, 64.5),
                    //width: 100,

                    child: ListView.builder(
                      itemCount: items.length,  //list.lenght
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              width: 150,
                              height: 180,
                              child:

                            Card(
                              color: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              //decoration: BoxDecoration(borderRadius: BorderRadius.circular(60), border: index == 0 ? Border.all(width: 3, color: UIData.pink) : Border.all(color: Colors.white) ),
                             child: Column(
                               children: <Widget>[
                                 Padding(
                                   padding: EdgeInsets.all(10),
                                       child: Container(
                                         
                                          height: 60,
                                          child: SizedBox(
                                            // height: 70,
                                            child: ClipRRect(
                                              borderRadius: new BorderRadius.circular(70),
                                              child: Image.asset("lib/assets/images/fortnite.jpg", // fra list [index]
                                                width: 62,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),

                                 Container(
                                   height: 60,
                                   child: Column(
                                     
                                     children: <Widget>[
                                     
                                        Text( (items[index]),
                                        style: TextStyle(fontWeight: FontWeight.bold),),
                                        
                                       Text("Skole"),
                                       Text("linje", style: TextStyle(fontStyle: FontStyle.italic)),
                                       
                                     ],
                                   ),
                                 ),
                                 Expanded(
                                   child: Container(
                                     height: 40,
                                     margin: EdgeInsets.only(top: 0),
                                     width: 150,
                                     decoration: new BoxDecoration(
                                       color: Colors.pink,
                                       borderRadius: new BorderRadius.only(
                                           bottomLeft:  const  Radius.circular(8.0),
                                           bottomRight: const  Radius.circular(8.0)),
                                     ),
                                     child: FlatButton(
                                       onPressed: () {},
                                       child: Text("Velg", style: TextStyle(color: Colors.white)),
                                     ),
                                   ),
                                 ),

                               ],
                             ),

                            ),
                        ),
                            SizedBox(
                              width: 150,
                              height: 180,
                              child:

                              Card(
                                color: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                //decoration: BoxDecoration(borderRadius: BorderRadius.circular(60), border: index == 0 ? Border.all(width: 3, color: UIData.pink) : Border.all(color: Colors.white) ),
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Container(
                                        height: 60,
                                        child: SizedBox(
                                          // height: 70,
                                          child: ClipRRect(
                                            borderRadius: new BorderRadius.circular(70),
                                            child: Image.asset("lib/assets/images/fortnite.jpg", // fra list [index]
                                              width: 62,
                                              fit: BoxFit.cover,
                                              
                                            ),
                                          ),
                                        ),



                                      ),
                                    ),
                                    Container(
                                      height: 60,
                                      child: Column(
                                        children: <Widget>[
                                          Text(
                                            (items[index]),
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                          Text("Skole"),
                                          Text("linje", style: TextStyle(fontStyle: FontStyle.italic)),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        height: 40,
                                        margin: EdgeInsets.only(top: 0),
                                        width: 150,
                                        decoration: new BoxDecoration(
                                          color: Colors.pink,
                                          borderRadius: new BorderRadius.only(
                                              bottomLeft:  const  Radius.circular(8.0),
                                              bottomRight: const  Radius.circular(8.0)),
                                        ),
                                        child: FlatButton(
                                          onPressed: () {},
                                          child: Text("Velg", style: TextStyle(color: Colors.white)),
                                        ),
                                      ),
                                    ),

                                  ],
                                ),

                              ),
                            ),
                          ],

                        );

                      },



                    ),

                  ),
                ),),


                        
                      /*
                      child: new ListView.builder(
                        itemCount: 5,
                        itemBuilder: (context, position) {
                          
                          return Card(
                            elevation: 0,
                            
                            child: ClipRRect(
                              borderRadius: new BorderRadius.circular(30),
                              child: Container(
                                height: 150,
                                width: 150,
                                

                                decoration: BoxDecoration(
                                  borderRadius: new BorderRadius.only(
                                    topLeft: const Radius.circular(20),
                                    bottomLeft: const Radius.circular(20),
                                  ),
                                ),

                                child: CircleAvatar(
                                  backgroundImage: NetworkImage("https://i.imgur.com/BoN9kdC.png"),
                                ),
                              ),
                            ),
                          );
                        },
                      ),*/

              ],
            ),
          ],

        ),);
  }

// Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
//   return ListTile(
//     contentPadding: EdgeInsets.all(3.0),
//     title: new Row(
//       mainAxisAlignment: MainAxisAlignment.start,
//       children: <Widget>[
//         Expanded(
//             child: Container(
//           padding: EdgeInsets.all(10.0),
//           decoration: new BoxDecoration(
//               border: Border.all(color: Colors.white),
//               borderRadius: new BorderRadius.all(const Radius.circular(8.0))),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: <Widget>[
//               Text(
//                 document['name'],
//                 style: new TextStyle(
//                     color: Colors.white, fontSize: UIData.fontSize20),
//                 overflow: TextOverflow.ellipsis,
//               ),
//               new Padding(
//                 padding: EdgeInsets.all(1.0),
//               ),
//               new Row(children: <Widget>[
//                 new Icon(
//                   Icons.whatshot,
//                   color: Colors.red,
//                   size: 25.0,
//                 ),
//                 new Align(),
//                 Text(" ${document["numberoftournaments"].toString()}",
//                     overflow: TextOverflow.ellipsis,
//                     style: new TextStyle(
//                         color: Colors.yellow[700],
//                         fontSize: UIData.fontSize20)),
//                 new Icon(
//                   Icons.attach_money,
//                   color: Colors.green,
//                   size: 25.0,
//                 ),
//                 Text("${document["numberofcashgames"].toString()}",
//                     overflow: TextOverflow.ellipsis,
//                     style: new TextStyle(
//                         color: Colors.yellow[700],
//                         fontSize: UIData.fontSize20)),
//               ]),
//             ],
//           ),
//         )),
//       ],
//     ),
//     onTap: () {
//       groupId = document.documentID;

//       Navigator.push(
//         context,
//         MaterialPageRoute(
//             builder: (context) => GroupDashboard(
//                   user: widget.user,
//                   groupId: groupId,
//                   // groupType: type,
//                   onUpdate: () => _registeredGames(),
//                 )),
//       );
//     },
//   );
// }

// Widget friendSearch() {
//   return StreamBuilder(
//       stream: firestoreInstance
//           .collection("users/$currentUserId/groups")
//           .orderBy("members", descending: true)
//           .snapshots(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) return loading();
//         return ListView.builder(
//           itemExtent: 50.0,
//           itemCount: snapshot.data.documents.length,
//           itemBuilder: (context, index) =>
//               _buildListItem(context, snapshot.data.documents[index]),
//         );
//       });
// }

// Widget buildSearch(BuildContext context, DocumentSnapshot document) {
//   return ListTile(
//     contentPadding: EdgeInsets.all(3.0),
//     title: new Row(
//       mainAxisAlignment: MainAxisAlignment.start,
//       children: <Widget>[
//         Expanded(
//             child: Container(
//           padding: EdgeInsets.all(10.0),
//           decoration: new BoxDecoration(
//               border: Border.all(color: Colors.white),
//               borderRadius: new BorderRadius.all(const Radius.circular(8.0))),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: <Widget>[
//               Text(document['name'],
//                   overflow: TextOverflow.ellipsis,
//                   style: new TextStyle(
//                       color: Colors.white, fontSize: UIData.fontSize20)),
//               new Row(
//                 children: <Widget>[
//                   new Icon(
//                     Icons.people,
//                     color: Colors.blue,
//                     size: 25.0,
//                   ),
//                   new Padding(
//                       padding: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0)),
//                   Text("${document['members']}",
//                       overflow: TextOverflow.ellipsis,
//                       style: new TextStyle(
//                           color: Colors.white, fontSize: UIData.fontSize20)),
//                 ],
//               ),
//             ],
//           ),
//         )),
//       ],
//     ),
//     onTap: () {
//       groupId = document.documentID;

//       Navigator.push(
//         context,
//         MaterialPageRoute(
//             builder: (context) => GroupDashboard(
//                   user: widget.user,
//                   groupId: groupId,
//                   // groupType: type,
//                   onUpdate: () => _registeredGames(),
//                 )),
//       );
//     },
//   );
// }

// Widget groupSearch() {
//   return StreamBuilder(
//       stream: firestoreInstance
//           .collection("groups")
//           .where("lowercasename", isEqualTo: groupSearchName.trim())
//           .where("public", isEqualTo: true)
//           .snapshots(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) return loading();
//         return ListView.builder(
//           itemExtent: 50.0,
//           itemCount: snapshot.data.documents.length,
//           itemBuilder: (context, index) =>
//               buildSearch(context, snapshot.data.documents[index]),
//         );
//       });
// }
}