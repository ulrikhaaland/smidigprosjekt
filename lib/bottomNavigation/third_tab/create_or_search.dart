import 'package:flutter/material.dart';
import 'package:smidigprosjekt/objects/user.dart';
import 'package:smidigprosjekt/service/service_provider.dart';
import 'package:smidigprosjekt/service/styles.dart';
import 'package:smidigprosjekt/utils/uidata.dart';
import 'package:smidigprosjekt/widgets/primary_button.dart';
import 'package:smidigprosjekt/widgets/search.dart';

class CreateOrSearchPage extends StatefulWidget {
  CreateOrSearchPage({Key key, this.user, this.onDone, this.groupMembers})
      : super(key: key);

  final User user;
  final VoidCallback onDone;
  List<User> groupMembers;

  _CreateOrSearchPageState createState() => _CreateOrSearchPageState();
}

class _CreateOrSearchPageState extends State<CreateOrSearchPage> {
  bool _showSearch = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget content;

    _showSearch
        ? content = Search(
            user: widget.user,
            addUsers: widget.groupMembers,
            fromGroup: true,
            onDone: () => setState(() {
                  _showSearch = false;
                }),
          )
        : content = Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Lag en gruppe:",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Container(
                  height: ServiceProvider.instance.screenService
                      .getHeightByPercentage(context, 3),
                ),
                Text(
                  "Søk etter andre mennesker og legg de til i gruppen din!",
                  style: Styles().textLight(),
                ),
                Container(
                  height: ServiceProvider.instance.screenService
                      .getHeightByPercentage(context, 5),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                        children: widget.groupMembers.map((u) {
                      Widget finalChild;
                      if (widget.user.profileImage != null) {
                        finalChild = Image.network(
                          widget.user.profileImage,
                          width: 52,
                          height: 52,
                          fit: BoxFit.cover,
                        );
                      } else {
                        finalChild = Image.asset(
                          //_group.members[index].profileImage, // fra list [index]
                          "lib/assets/images/profilbilde.png",

                          width: 52,
                          height: 52,
                          fit: BoxFit.cover,
                        );
                      }
                      return Column(
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: new BorderRadius.circular(80),
                            child: finalChild,
                          ),
                          Text(u.userName.substring(0, 3) + "..."),
                          Container(
                            width: ServiceProvider.instance.screenService
                                .getWidthByPercentage(context, 2),
                          ),
                        ],
                      );
                    }).toList()),
                    Container(
                      width: ServiceProvider.instance.screenService
                          .getWidthByPercentage(context, 2),
                    ),
                    Padding(padding: EdgeInsets.all(7)),
                    Column(
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: new BorderRadius.circular(80),
                          child: Container(
                            width: 52,
                            height: 52,
                            color: UIData.blue,
                            child: IconButton(
                              icon: Icon(Icons.add),
                              color: Colors.white,
                              onPressed: () => setState(() {
                                    _showSearch = true;
                                  }),
                            ),
                          ),
                        ),
                        Text("")
                      ],
                    ),
                  ],
                ),
                Container(
                  height: ServiceProvider.instance.screenService
                      .getHeightByPercentage(context, 5),
                ),
                PrimaryButton(
                  text: "Opprett gruppe",
                  onPressed: () => widget.onDone(),
                )
              ],
            ),
          );

    return Scaffold(
        appBar: AppBar(
          elevation: 1,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: new Text(
            "Lag gruppe",
            style: ServiceProvider.instance.styles.title(),
          ),
        ),
        backgroundColor: UIData.grey,
        body: content);
  }
}
