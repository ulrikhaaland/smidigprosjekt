import 'package:flutter/material.dart';
import 'package:smidigprosjekt/utils/uidata.dart';

class PrimaryButton extends StatelessWidget {
  PrimaryButton({this.key, this.text, this.onPressed, this.color, this.padding})
      : super(key: key);
  final Key key;
  final String text;
  final Color color;
  final VoidCallback onPressed;
  final double padding;

  @override
  Widget build(BuildContext context) {
    return new ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: 50.0,
          minWidth: 500.0,
        ),
        child: new Padding(
          padding: EdgeInsets.only(left: padding, right: padding),
          child: new RaisedButton(
              child: new Text(text,
                  style: new TextStyle(color: Colors.black, fontSize: 20.0)),
              shape: new RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              color: color,
              textColor: Colors.white,
              elevation: 8.0,
              onPressed: onPressed),
        ));
  }
}
