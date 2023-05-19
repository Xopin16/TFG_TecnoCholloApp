class LoginResponse {
  String? id;
  String? username;
  String? fullName;
  String? createdAt;
  String? avatar;
  String? token;
  String? role;
  String? email;
  // String? refreshToken;

  LoginResponse(
      {this.id,
      this.username,
      this.fullName,
      this.createdAt,
      this.avatar,
      this.token,
      // this.refreshToken,
      this.role,
      this.email});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    fullName = json['fullName'];
    createdAt = json['createdAt'];
    avatar = json['avatar'];
    token = json['token'];
    // refreshToken = json['refreshToken'];
    role = json['role'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['fullName'] = fullName;
    data['createAt'] = createdAt;
    data['token'] = token;
    data['avatar'] = avatar;
    // data['refreshToken'] = refreshToken;
    data['email'] = email;
    data['roile'] = role;
    return data;
  }
}

class LoginRequest {
  String? username;
  String? password;

  LoginRequest({this.username, this.password});

  LoginRequest.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['username'] = username;
    data['password'] = password;
    return data;
  }
}
