import 'package:flutter/material.dart';
import '../auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/uidata.dart';
import 'package:flutter/foundation.dart';
import 'package:smidigprosjekt/auth.dart';
import 'package:smidigprosjekt/objects/user.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';

import 'dart:async';
import 'dart:convert';

class Login extends StatefulWidget {
  Login(
      {Key key,
      this.title,
      this.auth,
      this.onSignIn,
      this.currentUser,
      this.messagingToken})
      : super(key: key);
  final String messagingToken;
  final String title;
  final BaseAuth auth;
  final VoidCallback onSignIn;
  final String currentUser;

  @override
  LoginState createState() => new LoginState();
}

enum FormType { login, register, forgotPassword }

class LoginState extends State<Login> {
  static final formKey = new GlobalKey<FormState>();
  final FlutterWebviewPlugin flutterWebviewPlugin = new FlutterWebviewPlugin();

  MediaQueryData queryData;

  bool feide = false;
  String verify;
  bool verified = false;

  @override
  void initState() {
    super.initState();
    webViewListener();
  }

  @override
  Widget build(BuildContext context) {
    queryData = MediaQuery.of(context);
    if (!feide) {
      return new Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: <Widget>[
            new Padding(
              padding: EdgeInsets.only(top: 48),
              child: new Align(
                alignment: Alignment.topLeft,
                child: new Container(
                  width: queryData.size.width / 2,
                  height: 30,
                  color: UIData.green,
                ),
              ),
            ),
            new Padding(
              padding: EdgeInsets.only(top: 48),
              child: new Align(
                alignment: Alignment.topRight,
                child: new Container(
                  width: queryData.size.width / 2,
                  height: 30,
                  color: UIData.red,
                ),
              ),
            ),
            // Container(
            //   height: queryData.size.height / 4,
            // ),
            new Stack(
              children: <Widget>[
                new Image.asset("lib/assets/images/logo.gif"),
                new Padding(
                    padding: EdgeInsets.only(left: 64.0, right: 64, top: 220),
                    child: new ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: 50.0,
                          minWidth: 500.0,
                        ),
                        child: new FlatButton(
                          shape: new RoundedRectangleBorder(
                            side: BorderSide(color: Colors.black),
                            // borderRadius: BorderRadius.all(Radius.circular(10.0))
                          ),
                          onPressed: () {
                            setState(() {
                              feide = true;
                            });
                          },
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              new Text(
                                "Logg inn med FEIDE",
                                style: new TextStyle(color: Colors.black),
                                textAlign: TextAlign.center,
                              ),
                              new Image.asset(
                                "lib/assets/images/logo-feide-2092px.png (content).png",
                                scale: 20,
                              ),
                            ],
                          ),
                        ))),
              ],
            ),

            new Padding(
              padding: EdgeInsets.only(top: 48),
              child: new Align(
                alignment: Alignment.topLeft,
                child: new Container(
                  width: queryData.size.width / 2,
                  height: 30,
                  color: UIData.purple,
                ),
              ),
            ),
            new Padding(
              padding: EdgeInsets.only(top: 48),
              child: new Align(
                alignment: Alignment.topRight,
                child: new Container(
                  width: queryData.size.width / 2,
                  height: 30,
                  color: UIData.darkpurple,
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return new MaterialApp(
        routes: {
          "/": (_) => new WebviewScaffold(
                url:
                    "https://auth.dataporten.no/oauth/authorization?response_type=code&client_id=8a3f6c00-555b-432b-a9bf-89acd1711c3d&redirect_uri=https://us-central1-smidigprosjekt.cloudfunctions.net/getUserInfoFromFeide",
              ),
        },
      );
    }
  }

  void webViewListener() {
    flutterWebviewPlugin.onUrlChanged.listen((String url) {
      if (url.contains("?code=")) {
        int indexOf = url.indexOf("=");
        verify = url.substring(indexOf + 1, url.length);
        print(verify);
        // verified = true;
        httpTest();
        // flutterWebviewPlugin.close();
      }
    });
  }

  void httpTest() async {
    // String dataURL =
    //     "https://auth.dataporten.no/oauth/authorization?response_type=code&client_id=8a3f6c00-555b-432b-a9bf-89acd1711c3d&redirect_uri=https://us-central1-smidigprosjekt.cloudfunctions.net/getUserInfoFromFeide";

    var response =
        await http.post("https://auth.dataporten.no/oauth/token", body: {
      "grant_type": "authorization_code",
      "code": verify,
      "client_id": "8a3f6c00-555b-432b-a9bf-89acd1711c3d",
      "client_secret": "dc705fbf-1091-47a2-9774-ec1b3c5df7da",
      "redirect_uri":
          "https://us-central1-smidigprosjekt.cloudfunctions.net/getUserInfoFromFeide",
    });
    String body = response.body;
    body = body.substring(body.indexOf(":") + 3, body.indexOf(",") - 1);
    print(body);

    var infoResponse =
        await http.get("https://auth.dataporten.no/userinfo", headers: {
      "Authorization": "Bearer " + body,
    });

    body = infoResponse.body;
    body = body.substring(1);
    body = body.substring(
      body.indexOf("{") + 1,
      body.indexOf("}"),
    );
    body = "{" + body + "}";
    Map valueMap = json.decode(body);
    String uid =
        await widget.auth.createUser(valueMap["email"], valueMap["userid"]);

    User user = new User(
        valueMap["email"],
        uid,
        valueMap["userid"],
        valueMap["name"],
        await updateFcmToken(valueMap["userid"]),
        true,
        null,
        null,
        null);
    await Firestore.instance.document("users/$uid").setData(user.toJson());
    widget.onSignIn();
  }

  Future<String> updateFcmToken(String uid) async {
    String messagingToken;
    messagingToken = await FirebaseMessaging().getToken();
    print(messagingToken);

    return messagingToken;
  }
}
