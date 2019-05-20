import 'dart:async';

import 'package:flutter/material.dart';
import 'package:smidigprosjekt/auth.dart';
import 'package:smidigprosjekt/login/login.dart';
import 'bottomNavigation/first_tab/feed_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'utils/essentials.dart';
import 'package:smidigprosjekt/objects/user.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'utils/uidata.dart';
import 'intro.dart';

class RootPage extends StatefulWidget {
  RootPage({Key key, this.auth}) : super(key: key);
  final BaseAuth auth;

  @override
  State<StatefulWidget> createState() => new RootPageState();
}

enum AuthStatus {
  notSignedIn,
  signedIn,
  intro,
  loading,
}

class RootPageState extends State<RootPage> {
  String currentUser;
  String userName;
  String userEmail;
  String messagingToken;
  User user;

  FirebaseMessaging firebaseMessaging = FirebaseMessaging();

  AuthStatus authStatus = AuthStatus.loading;

  initState() {
    super.initState();

    var users = [
      {
        "bio": "Enkelt og greit menneske.",
        "email": "",
        "linje": "Økonomi og administrasjon",
        "skole": "Oslo Met",
        "name": "Per Arne Heimesen",
      },
      {
        "bio": "Ser etter studenter som er interessert i å få gode karakterer.",
        "email": "",
        "linje": "Markedsføring",
        "skole": "Universitet i Oslo",
        "name": "Camilla Hunders",
      },
      {
        "bio": "Glad i å fiske og se på tv",
        "email": "",
        "linje": "IT",
        "skole": "Oslo Met",
        "name": "Pripjet Vladikovski",
      },
      {
        "bio": "Hater instagram ads",
        "email": "",
        "linje": "Film og Tv",
        "skole": "Høyskolen Kristiania",
        "name": "Amanda Gundersen",
      },
      {
        "bio": "Jeg er ikke din kokk",
        "email": "",
        "linje": "Kunst",
        "skole": "Høyskolen Kristiania",
        "name": "Lerant Dufreau",
      },
      {
        "bio": "Trene, venner og seriemordere.",
        "email": "",
        "linje": "Ernæring",
        "skole": "Oslo Met",
        "name": "Fredrik Holtet",
      },
    ];

    users.forEach((u) {
      Firestore.instance.collection("users").add(u);
    });

    getUserId();
    firebaseMessaging.configure(onLaunch: (Map<String, dynamic> msg) {
      print("onLaunch called");
      handleMessage(msg);
    }, onResume: (Map<String, dynamic> msg) {
      print("onResume called");
      handleMessage(msg);
    }, onMessage: (Map<String, dynamic> msg) {
      print("onMessage called");
      handleMessage(msg);
    });
    firebaseMessaging
        .requestNotificationPermissions(const IosNotificationSettings(
      sound: true,
      alert: true,
      badge: true,
    ));
    firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings setting) {
      print("IOS Setting Registered");
    });
  }

  Future<String> updateFcmToken() async {
    if (currentUser != null) {
      messagingToken = await firebaseMessaging.getToken();
      print(messagingToken);
      Firestore.instance
          .document("users/$currentUser")
          .updateData({"fcm": messagingToken});
    }
    return messagingToken;
  }

  void handleMessage(Map<String, dynamic> message) async {}

  Future<String> getUserId() async {
    currentUser = await widget.auth.currentUser();
    Timer(Duration(seconds: 1), () async => await getUserInfo());
    // await getUserInfo();
    return currentUser;
  }

  Future<Null> getUserInfo() async {
    DocumentSnapshot docSnap =
        await Firestore.instance.document("users/$currentUser").get();
    if (docSnap.exists) {
      user = new User(
        docSnap.data["email"],
        docSnap.data["id"],
        docSnap.data["feideid"],
        docSnap.data["name"],
        await updateFcmToken(),
        docSnap.data["intro"],
        docSnap.data["skole"],
        docSnap.data["linje"],
        docSnap.data["bio"],
      );
      setState(() {
        authStatus =
            currentUser != null ? AuthStatus.signedIn : AuthStatus.notSignedIn;
        if (user.intro) {
          authStatus = AuthStatus.intro;
        }
      });
    } else {
      setState(() {
        authStatus = AuthStatus.notSignedIn;
      });
    }
  }

  void _updateAuthStatus(AuthStatus status) {
    setState(() {
      authStatus = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.notSignedIn:
        return new Login(
          title: 'Login',
          messagingToken: messagingToken,
          auth: widget.auth,
          onSignIn: () => getUserId(),
        );
      case AuthStatus.signedIn:
        return new MyHomePage(
            auth: widget.auth,
            currentUser: currentUser,
            userEmail: userEmail,
            userName: userName,
            user: user,
            onSignOut: () => _updateAuthStatus(AuthStatus.notSignedIn));
      case AuthStatus.loading:
        return new Essentials(
          imageLoad: true,
        );
      case AuthStatus.intro:
        return new Intro(
            user: user,
            onIntroFinished: () => getUserId(),
            onSignOut: () => _updateAuthStatus(AuthStatus.notSignedIn));
    }
  }
}
