class EditUser {
  String? avatar;
  String? email;
  String? verifyEmail;

  EditUser({this.avatar, this.email, this.verifyEmail});

  EditUser.fromJson(Map<String, dynamic> json) {
    avatar = json['avatar'];
    email = json['email'];
    verifyEmail = json['verifyEmail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['avatar'] = this.avatar;
    data['email'] = this.email;
    data['verifyEmail'] = this.verifyEmail;
    return data;
  }
}
