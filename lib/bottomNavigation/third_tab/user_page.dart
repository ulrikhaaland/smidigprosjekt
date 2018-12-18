import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:smidigprosjekt/auth.dart';
import 'package:smidigprosjekt/utils/uidata.dart';
import 'package:smidigprosjekt/objects/user.dart';

class UserPage extends StatefulWidget {
  UserPage({Key key, this.auth, this.onSignOut, this.user}) : super(key: key);
  final BaseAuth auth;
  final VoidCallback onSignOut;
  final User user;

  @override
  UserPageState createState() => UserPageState();
}

class UserPageState extends State<UserPage> {
  String groupCode = "ererasdas";
  String groupName;
  String groupId;
  String currentUser;
  String userName;
  String email;
  bool userFound = false;

  @override
  void initState() {
    super.initState();
    print(widget.user.getName());
  }

  Widget loading() {
    return new Center(
      child: new CircularProgressIndicator(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: UIData.green,
          title: new Text(
            "Settings",
            style: new TextStyle(fontSize: UIData.fontSize24),
          )),
      backgroundColor: UIData.green,
      body: page(),
    );
  }

  Widget page() {
    return ListView(
      children: <Widget>[
        new ListTile(
          leading: new Icon(
            Icons.person,
            size: 40.0,
            color: Colors.blue,
          ),
          title: new Text(
            "${widget.user.getName()}",
            style:
                new TextStyle(fontSize: UIData.fontSize20, color: UIData.green),
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: new Text(
            "${widget.user.getEmail()}",
            style:
                new TextStyle(fontSize: UIData.fontSize16, color: Colors.grey),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        new Divider(
          height: .0,
          color: Colors.black,
        ),
        new Padding(
          padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
        ),
        new ListTile(
          leading: new Icon(
            Icons.insert_invitation,
            size: 40.0,
            color: Colors.yellow[700],
          ),
          title: new Text(
            "Invites",
            style:
                new TextStyle(color: UIData.green, fontSize: UIData.fontSize20),
          ),
          onTap: null,
        ),
        new Divider(
          height: .0,
          color: Colors.black,
        ),
        // new ListTile(
        //   leading: new Icon(
        //     Icons.notifications,
        //     size: 40.0,
        //     color: UIData.green,
        //   ),
        //   title: padded(
        //       child: new Text(
        //     "Notifications",
        //     style: new TextStyle(
        //       color: UIData.green,
        //       fontSize: UIData.fontSize20,
        //     ),
        //   )),
        //   trailing: new Switch(
        //     materialTapTargetSize: MaterialTapTargetSize.padded,
        //     activeColor: UIData.green,
        //     inactiveThumbColor: UIData.red,
        //     inactiveTrackColor: Colors.grey,
        //     activeTrackColor: Colors.grey,
        //     value: false,
        //     onChanged: (bool val) {
        //       val = false;
        //     },
        //   ),
        //   onTap: null,
        // ),
        // new Divider(
        //   height: .0,
        //   color: Colors.black,
        // ),
        new ListTile(
          leading: new Icon(
            Icons.exit_to_app,
            size: 40.0,
            color: UIData.red,
          ),
          title: new Text(
            "Logout",
            style:
                new TextStyle(color: UIData.green, fontSize: UIData.fontSize20),
          ),
          onTap: () {
            widget.onSignOut();
          },
        ),
        new Divider(
          height: .0,
          color: Colors.black,
        ),
      ],
    );
  }

  Widget padded({Widget child}) {
    return new Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: child,
    );
  }

  void onChanged(String value) {
    setState(() {
      groupCode = value;
    });
    print(groupCode);
  }
}
