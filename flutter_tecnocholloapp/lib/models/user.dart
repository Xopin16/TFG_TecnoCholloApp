import 'package:flutter_tecnocholloapp/models/login.dart';

class User {
  String? id;
  String? username;
  String? avatar;
  String? fullName;
  String? createdAt;
  String? role;
  String? email;

  User(
      {this.id,
      this.username,
      this.avatar,
      this.fullName,
      this.role,
      this.email,
      this.createdAt});

  User.fromLoginResponse(LoginResponse response) {
    this.id = response.id;
    this.username = response.username;
    this.avatar = response.avatar;
    this.fullName = response.fullName;
    this.role = response.role;
    this.email = response.email;
    this.createdAt = response.createdAt;
  }
}

class UserResponse extends User {
  UserResponse(id, username, fullName, avatar, role, email, createdAt)
      : super(
            id: id,
            username: username,
            fullName: fullName,
            avatar: avatar,
            role: role,
            email: email,
            createdAt: createdAt);

  UserResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    avatar = json['avatar'];
    createdAt = json['createdAt'];
    fullName = json['fullName'];
    role = json['role'];
    email = json['email'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['avatar'] = this.avatar;
    data['fullName'] = this.fullName;
    data['role'] = this.role;
    data['email'] = this.email;
    data['createdAt'] = this.email;
    return data;
  }
}
