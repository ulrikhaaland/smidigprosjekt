import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smidigprosjekt/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

class GamePage extends StatefulWidget {
  const GamePage({Key key, this.auth, this.user, this.onSignOut})
      : super(key: key);
  final BaseAuth auth;
  final VoidCallback onSignOut;
  final User user;
  @override
  GamePageState createState() => GamePageState();

  
}






class GamePageState extends State<GamePage> {
  static final formKey = new GlobalKey<FormState>();

  //final Firestore firestoreInstance = Firestore.instance;
  //final BaseAuth auth = Auth();

  int screen = 0;

  GamePageState() {
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
  }

  @override
  dispose() {
    super.dispose();
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
            style: new TextStyle(
                fontFamily: 'Anton', fontSize: 24, color: Colors.black),

          ),

          // backgroundColor: UIData.green,
        ),



        body: new Stack(
          //alignment: Alignment.center,

          children: [

            Column(

              children: <Widget>[
                
                Padding(
                  
                  padding: EdgeInsets.only(top: 100),
                  child: Align(
                    
                    alignment: Alignment.center,
                    child: Text(
                      "Finn personer", 
                      style: TextStyle(
                        fontSize: 20,
                      
                    ),),
                  ),
                ),


                Align(

                  alignment: Alignment.center,

                  child: Container(

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

                Row(
                  
                  children: <Widget>[
                    
                      Container(
                        width: 150,
                        height: 150,
                        child: new ListView.builder(
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            return Card(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: ClipRRect(
                                borderRadius: new BorderRadius.circular(70),
                                
                                child: CircleAvatar(
                                  
                                  backgroundImage: NetworkImage("https://i.imgur.com/BoN9kdC.png"),
                                ),
                              ),
                            );
                          }
                        ),
                                             
                        
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
                    ),
                   

                  ],
                ),
              ],
            ),
          ],

        ));
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