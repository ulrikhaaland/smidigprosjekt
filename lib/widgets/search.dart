import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smidigprosjekt/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smidigprosjekt/bottomNavigation/fourth_tab/profile_page.dart';
import 'package:smidigprosjekt/service/service_provider.dart';
import 'package:smidigprosjekt/utils/uidata.dart';
import 'package:smidigprosjekt/userSearch/search.dart';
import 'package:smidigprosjekt/objects/user.dart';
import 'package:smidigprosjekt/widgets/primary_button.dart';

class Search extends StatefulWidget {
  const Search({
    Key key,
    this.user,
    this.addUsers,
    this.fromGroup,
    this.onDone,
  }) : super(key: key);
  final User user;
  final List<User> addUsers;
  final bool fromGroup;
  final VoidCallback onDone;
  @override
  SearchState createState() => SearchState();
}

class SearchState extends State<Search> {
  String _searchTextValue = "";

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
    return Column(
      children: <Widget>[
        Align(
          alignment: Alignment.center,
          child: Container(
            //color: Colors.white,
            margin: EdgeInsets.only(top: 20),
            width: 300,

            child: TextField(
              textInputAction: TextInputAction.done,
              textCapitalization: TextCapitalization.words,
              autocorrect: false,
              style: new TextStyle(color: Colors.black),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(width: 0, style: BorderStyle.none)),
                prefixIcon: Icon(Icons.search, color: UIData.blue),
                fillColor: Colors.white,
                filled: true,
                labelText: 'Søk etter personer..',
                labelStyle: new TextStyle(color: Colors.grey[700]),
              ),
              onChanged: (String value) {
                setState(() {
                  _searchTextValue = value;
                });
              },
            ),
          ),
        ),
        StreamBuilder(
          stream: Firestore.instance
              .collection("users")
              .where("name", isEqualTo: _searchTextValue)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Center(child: Text("Laster.."));

            // return Text("data");

            return ListView.builder(
              shrinkWrap: true,
              // itemExtent: 200.0,
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) =>
                  //  Text("dasdas"),
                  _buildResultItems(context, snapshot.data.documents[index]),
            );
          },
        ),
        if (widget.fromGroup) ...[
          Container(
            height: ServiceProvider.instance.screenService
                .getHeightByPercentage(context, 2),
          ),
          PrimaryButton(
            text: "Gå videre",
            color: UIData.blue,
            onPressed: () => widget.onDone(),
          )
        ],
      ],
    );
  }

  Widget _buildResultItems(BuildContext context, DocumentSnapshot doc) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          width: 150,
          height: 180,
          child: Card(
            color: Colors.white,
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
                        child:(doc.data["profileImage"]) !=null?
                        Image.network(
                          (doc.data["profileImage"]), // fra list [index]
                          width: 62,
                          fit: BoxFit.cover,
                        )
                        :
                        Image.asset(
                          "lib/assets/images/profilbilde.png", // fra list [index]
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
                      Expanded(
                        child: Text(
                          (doc.data["name"]),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(padding: EdgeInsets.all(1)),
                      Expanded(child: Text(doc.data["school"])),
                      Expanded(
                        child: Text(doc.data["program"],
                            style: TextStyle(fontStyle: FontStyle.italic)),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(top: 0),
                    width: 150,
                    decoration: new BoxDecoration(
                      color: UIData.pink,
                      borderRadius: new BorderRadius.only(
                          bottomLeft: const Radius.circular(8.0),
                          bottomRight: const Radius.circular(8.0)),
                    ),
                    child: FlatButton(
                      onPressed: () {
                        User clickedUser = User(
                          userName: doc.data["name"],
                          id: doc.data["id"],
                          email: doc.data["email"],
                          school: doc.data["school"],
                          program: doc.data["program"],
                          profileImage: doc.data["profileImage"],
                          bio: doc.data["bio"],
                        );
                        if (widget.fromGroup) {
                          bool cleared = false;
                          String snackText = "";
                          widget.addUsers.forEach((u) =>
                              u.userName == doc.data["name"]
                                  ? cleared = false
                                  : cleared = true);
                          if (cleared) {
                            widget.addUsers.add(clickedUser);
                            snackText =
                                "${doc.data["name"]} har blitt lagt valgt!";
                          } else {
                            snackText =
                                "${doc.data["name"]} har allerede blitt valgt!";
                          }

                          Scaffold.of(context).showSnackBar(new SnackBar(
                              backgroundColor: UIData.blue,
                              content: Container(
                                height: ServiceProvider.instance.screenService
                                    .getHeightByPercentage(context, 2.5),
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      snackText,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              )));
                        } else {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ProfilePage(
                                  user: clickedUser,
                                  myProfile: false,
                                ),
                          ));
                        }
                      },
                      child:
                          Text("Velg", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
