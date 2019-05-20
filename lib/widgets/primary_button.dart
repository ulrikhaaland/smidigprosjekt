import 'package:flutter/material.dart';
import 'package:smidigprosjekt/utils/uidata.dart';
import '../service/service_provider.dart';

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
          minHeight: ServiceProvider.instance.screenService
              .getPortraitHeightByPercentage(context, 6),
          minWidth: 500.0,
        ),
        child: new Padding(
          padding: EdgeInsets.only(
              left: ServiceProvider.instance.screenService
                  .getPortraitWidthByPercentage(context, 25),
              right: ServiceProvider.instance.screenService
                  .getPortraitWidthByPercentage(context, 25)),
          child: new FlatButton(
              child: new Text(text,
                  style: new TextStyle(color: Colors.white, fontSize: 20.0)),
              shape: new RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(24.0))),
              color: UIData.pink,
              onPressed: onPressed),
        ));
  }
}
