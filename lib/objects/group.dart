import 'package:smidigprosjekt/objects/user.dart';

class Group {
  String name;
  List<User> members;
  String id;
  int memberAmount;

  Group({this.name, this.members, this.id, this.memberAmount});

  Map<String, dynamic> toJson() => {
        'id': this.id,
        "name": this.name,
        "memberamount": this.memberAmount,
      };

}
