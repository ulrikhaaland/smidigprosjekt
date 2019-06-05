class User {
  User(
      this.email,
      this.id,
      this.feideid,
      this.userName,
      // this.fcm,
      this.intro,
      this.skole,
      this.linje,
      this.bio);

  final String userName;
  final String id;
  final String feideid;
  final String email;
  // final String fcm;
  bool intro;
  String skole;
  String linje;
  String bio;

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
        'feideid': this.feideid,
        'name': this.userName,
        'email': this.email,
        // 'fcm': this.fcm,
        'intro': this.intro,
        'skole': this.skole,
        'linje': this.linje,
        'bio': this.bio,
      };
}
