enum IntroChoice {
  search,
  assigned,
}

class User {
  User(
      {this.email,
      this.id,
      this.feideId,
      this.userName,
      this.intro,
      this.school,
      this.program,
      this.bio,
      this.profileImage,
      this.groupId,
      this.introChoice});

  final String userName;
  final String id;
  final String feideId;
  final String email;
  IntroChoice introChoice;
  bool intro;
  String school;
  String program;
  String bio;
  String profileImage;
  String groupId;

  String getName() {
    return this.userName;
  }

  String getProfileImage() {
    return this.profileImage;
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
        'intro': this.intro,
        'school': this.school,
        'program': this.program,
        'bio': this.bio,
        'profileImage': this.profileImage,
        'groupid': this.groupId,
      };
}
