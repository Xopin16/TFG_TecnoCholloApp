class CreateUser {
  String? username;
  String? password;
  String? verifyPassword;
  String? email;
  String? verifyEmail;
  String? fullName;

  CreateUser(
      {this.username,
      this.password,
      this.verifyPassword,
      this.email,
      this.verifyEmail,
      this.fullName});

  CreateUser.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    password = json['password'];
    verifyPassword = json['verifyPassword'];
    email = json['email'];
    verifyEmail = json['verifyEmail'];
    fullName = json['fullName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['password'] = this.password;
    data['verifyPassword'] = this.verifyPassword;
    data['email'] = this.email;
    data['verifyEmail'] = this.verifyEmail;
    data['fullName'] = this.fullName;
    return data;
  }
}
