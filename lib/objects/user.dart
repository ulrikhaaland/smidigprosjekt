class User {
  User(this.email, this.id, this.userName, this.fcm, this.intro);

  final String userName;
  final String id;
  final String email;
  final String fcm;
  final bool intro;

  String getToken() {
    return this.fcm;
  }

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
        'name': this.userName,
        'email': this.email,
        'fcm': this.fcm,
        'intro': this.intro,
      };
}
