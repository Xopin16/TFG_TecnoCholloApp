import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_tecnocholloapp/config/locator.dart';
import 'package:flutter_tecnocholloapp/models/login.dart';
import 'package:flutter_tecnocholloapp/models/user.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_tecnocholloapp/rest/rest.dart';

import '../models/edit_user.dart';

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

  Future<LoginResponse> editUser(
      EditUser body, PlatformFile file, String token) async {
    String url = "/usuario/";
    var jsonResponse = await _client.putMultiPart(url, body, file, token);
    return LoginResponse.fromJson(jsonDecode(jsonResponse));
  }

  void deleteUser() async {
    String url = "/usuario/";
    await _client.delete(url);
  }
}
