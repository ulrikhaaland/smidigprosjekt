import 'user.dart';

class Group {
  Group({
    this.memberList,
    this.challengesList,
    this.chatList,
    this.eventsList,
    this.id,
    this.name,
  });

  final String id;
  final String name;

  final List<User> memberList;
  final List<Event> eventsList;
  final List<Challenge> challengesList;
  final List<Chat> chatList;
}
