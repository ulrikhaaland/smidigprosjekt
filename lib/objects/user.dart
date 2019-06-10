class User {
  User(
      {this.email,
      this.id,
      this.feideId,
      this.userName,
      // this.fcm,
      this.intro,
      this.school,
      this.program,
      this.bio,
      this.groupId});

  final String userName;
  final String id;
  final String feideId;
  final String email;
  // final String fcm;
  bool intro;
  String school;
  String program;
  String bio;
  String groupId;

  // String getToken() {
  //   return this.fcm;
  // }

  String getName() {
    return this.userName;
  }

  String getId() {
    return this.id;
  }

  String getEmail() {
    return this.email;
  }

  Map<String, dynamic> toJson() => {
        'id': this.id,
        'feideid': this.feideId,
        'name': this.userName,
        'email': this.email,
        // 'fcm': this.fcm,
        'intro': this.intro,
        'school': this.school,
        'program': this.program,
        'bio': this.bio,
        'groupid': this.groupId,
      };
}
