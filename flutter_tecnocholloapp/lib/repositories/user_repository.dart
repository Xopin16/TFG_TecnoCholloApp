import 'dart:convert';
import 'package:flutter_tecnocholloapp/config/locator.dart';
import 'package:flutter_tecnocholloapp/models/user.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_tecnocholloapp/rest/rest.dart';

@Order(-1)
@singleton
class UserRepository {
  late RestAuthenticatedClient _client;

  UserRepository() {
    _client = getIt<RestAuthenticatedClient>();
  }

  Future<dynamic> me() async {
    String url = "/usuario/me";

    var jsonResponse = await _client.get(url);
    return UserResponse.fromJson(jsonDecode(jsonResponse));
  }

  void deleteUser() async {
    String url = "/usuario/";
    await _client.delete(url);
  }
}
