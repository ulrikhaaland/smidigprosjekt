import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:smidigprosjekt/auth.dart';
import 'package:smidigprosjekt/objects/user.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_page_indicator/flutter_page_indicator.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import '../auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'dart:async';
import 'dart:convert';

class Feide extends StatefulWidget {
  Feide({
    Key key,
    this.auth,
  }) : super(key: key);

  final BaseAuth auth;

  @override
  _FeideState createState() => _FeideState();
}

class _FeideState extends State<Feide> {
  final FlutterWebviewPlugin flutterWebviewPlugin = new FlutterWebviewPlugin();

  String verify;
  bool verified = false;

  @override
  void initState() {
    super.initState();
    webViewListener();
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      routes: {
        "/": (_) => new WebviewScaffold(
              url:
                  "https://auth.dataporten.no/oauth/authorization?response_type=code&client_id=8a3f6c00-555b-432b-a9bf-89acd1711c3d&redirect_uri=https://us-central1-smidigprosjekt.cloudfunctions.net/getUserInfoFromFeide",
            ),
      },
    );
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
    User user = new User(valueMap["email"], valueMap["userid"],
        valueMap["name"], await updateFcmToken(valueMap["userid"]), true);
    await widget.auth.createUser(user.email, user.id);
    Firestore.instance.document("users/${user.id}").setData(user.toJson());
  }

  Future<String> updateFcmToken(String uid) async {
    String messagingToken;
    messagingToken = await FirebaseMessaging().getToken();
    print(messagingToken);
    Firestore.instance
        .document("users/$uid")
        .updateData({"fcm": messagingToken});

    return messagingToken;
  }
}
