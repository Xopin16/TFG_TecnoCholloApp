import 'dart:convert';
import 'package:flutter_tecnocholloapp/models/models.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_tecnocholloapp/rest/rest.dart';

@Order(-1)
@singleton
class AuthenticationRepository {
  late RestClient _client;

  AuthenticationRepository() {
    _client = GetIt.I.get<RestClient>();
    //_client = RestClient();
  }

  Future<dynamic> doLogin(String username, String password) async {
    String url = "/auth/login";

    var jsonResponse = await _client.post(
        url, LoginRequest(username: username, password: password));
    return LoginResponse.fromJson(jsonDecode(jsonResponse));
  }

  Future<LoginResponse> doRegister(
      String username,
      String password,
      String verifyPassword,
      String email,
      String verifyEmail,
      String fullName) async {
    String url = "/auth/register";

    var jsonResponse = await _client.post(
        url,
        CreateUser(
            username: username,
            password: password,
            verifyPassword: verifyPassword,
            email: email,
            verifyEmail: verifyEmail,
            fullName: fullName));
    return LoginResponse.fromJson(jsonDecode(jsonResponse));
  }

  Future<LoginResponse> doRegisterAdmin(
      String username,
      String password,
      String verifyPassword,
      String email,
      String verifyEmail,
      String fullName) async {
    String url = "/auth/register/admin";

    var jsonResponse = await _client.post(
        url,
        CreateUser(
            username: username,
            password: password,
            verifyPassword: verifyPassword,
            email: email,
            verifyEmail: verifyEmail,
            fullName: fullName));
    return LoginResponse.fromJson(jsonDecode(jsonResponse));
  }

  Future<LoginResponse> changePassword(UserPassword userPassword) async {
    String url = "/user/changePassword";
    var jsonResponse = await _client.put(url, userPassword);
    return LoginResponse.fromJson(jsonDecode(jsonResponse));
  }
}
