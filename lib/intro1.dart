import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:smidigprosjekt/auth.dart';
import 'package:smidigprosjekt/utils/uidata.dart';
import 'package:smidigprosjekt/objects/user.dart';
import 'intro2.dart';
import 'intro3.dart';
import 'widgets/primary_button.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_page_indicator/flutter_page_indicator.dart';

class IntroPageOne extends StatelessWidget {
  IntroPageOne({Key key, this.auth, this.onSignOut, this.user})
      : super(key: key);
  final BaseAuth auth;
  final VoidCallback onSignOut;
  final User user;

  @override
  Widget build(BuildContext context) {
    
  }
}
