import 'package:flutter/material.dart';
import 'package:smidigprosjekt/auth.dart';
import 'package:smidigprosjekt/login/login.dart';
import 'bottomNavigation/first_tab/bottom_nav.dart';
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
    await getUserInfo();
    return currentUser;
  }

  Future<Null> getUserInfo() async {
    Firestore.instance.runTransaction((Transaction tx) async {
      DocumentSnapshot docSnap =
          await Firestore.instance.document("users/$currentUser").get();
      if (docSnap.exists) {
        user = new User(
            docSnap.data["email"],
            docSnap.data["id"],
            docSnap.data["name"],
            await updateFcmToken(),
            docSnap.data["intro"]);
        setState(() {
          authStatus = currentUser != null
              ? AuthStatus.signedIn
              : AuthStatus.notSignedIn;
          if (user.intro) {
            authStatus = AuthStatus.intro;
          }
        });
      } else {
        setState(() {
          authStatus = AuthStatus.notSignedIn;
        });
      }
    });
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
          title: 'Flutter Login',
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
        return new Essentials();
      case AuthStatus.intro:
        return new Intro(
            user: user,
            onSignOut: () => _updateAuthStatus(AuthStatus.notSignedIn));
    }
  }
}
