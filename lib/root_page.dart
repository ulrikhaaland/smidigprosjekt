import 'dart:async';

import 'package:flutter/material.dart';
import 'package:smidigprosjekt/auth.dart';
import 'package:smidigprosjekt/login/login.dart';
import 'bottomNavigation/first_tab/feed_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'utils/essentials.dart';
import 'package:smidigprosjekt/objects/user.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
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

  bool fromIntro = false;

  AuthStatus authStatus = AuthStatus.loading;

  initState() {
    super.initState();

    getUserId();
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
        email: docSnap.data["email"],
        id: docSnap.data["id"],
        feideId: docSnap.data["feideid"],
        userName: docSnap.data["name"],
        intro: docSnap.data["intro"],
        school: docSnap.data["school"],
        program: docSnap.data["program"],
        bio: docSnap.data["bio"],
        profileImage: docSnap.data["profileImage"],
        groupId: docSnap.data["groupid"],
      );
      setState(() {
        authStatus =
            currentUser != null ? AuthStatus.signedIn : AuthStatus.notSignedIn;
        if (user.intro) {
          fromIntro = true;
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
            fromIntro: fromIntro,
            onSignOut: () => _updateAuthStatus(AuthStatus.notSignedIn));
      case AuthStatus.loading:
        return new Essentials(
          imageLoad: true,
        );
      case AuthStatus.intro:
        return new Intro(
            user: user,
            onIntroFinished: () => _updateAuthStatus(AuthStatus.signedIn),
            onSignOut: () => _updateAuthStatus(AuthStatus.notSignedIn));
    }
  }
}
