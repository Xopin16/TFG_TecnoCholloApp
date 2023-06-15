import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tecnocholloapp/main.dart';
import 'package:flutter_tecnocholloapp/services/localstorage_service.dart';
import 'package:get_it/get_it.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:http_parser/http_parser.dart';
import 'package:injectable/injectable.dart';
import 'package:http/http.dart' as http;

import '../models/login.dart';

class ApiConstants {
  // static String baseUrl = "http://localhost:8080";
  static String baseUrl = "http://10.0.2.2:8080";
}

class HeadersApiInterceptor implements InterceptorContract {
  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    try {
      data.headers["Content-Type"] = "application/json";
      data.headers["Accept"] = "application/json";
    } catch (e) {
      print(e);
    }
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    late LocalStorageService _localStorageService = LocalStorageService();

    interceptResponse() {
      //_localStorageService = getIt<LocalStorageService>();
      // GetIt.I
      //     .getAsync<LocalStorageService>()
      //     .then((value) => _localStorageService = value);
    }

    if (data.statusCode == 401 || data.statusCode == 403) {
      // Future.delayed(Duration(seconds: 1), () {
      //   Navigator.of(GlobalContext.ctx).push<void>(MyApp.route());
      // });
      var refreshToken = _localStorageService.getFromDisk("user_refresh_token");
      final response = await http.post(
          Uri.parse(ApiConstants.baseUrl + "/refreshtoken/"),
          body: jsonEncode({"refreshToken": refreshToken}),
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json"
          });
      if (response.statusCode == 201) {
        LoginResponse loginResponse =
            LoginResponse.fromJson(jsonDecode(response.body));

        await _localStorageService.saveToDisk(
            "user_token", loginResponse.token);
        await _localStorageService.saveToDisk(
            "user_refresh_token", loginResponse.refreshToken);

        var request = data.request;
        request!.headers["Authorization"] =
            "Bearer " + _localStorageService.getFromDisk("user_token");
        var retryResponseStream = await request.toHttpRequest().send();
        var retryResponse = await http.Response.fromStream(retryResponseStream);
        var datos = ResponseData.fromHttpResponse(retryResponse);
        return Future.value(datos);
      }
    }
    return Future.value(data);
  }
}

@Order(-10)
@singleton
class RestClient {
  var _httpClient;

  RestClient() {
    _httpClient =
        InterceptedClient.build(interceptors: [HeadersApiInterceptor()]);
  }

  RestClient.withInterceptors(List<InterceptorContract> interceptors) {
    // El interceptor con los encabezados sobre JSON se añade si no está incluido en la lista
    if (interceptors
        .where((element) => element is HeadersApiInterceptor)
        .isEmpty) interceptors..add(HeadersApiInterceptor());
    _httpClient = InterceptedClient.build(interceptors: interceptors);
  }

  //final _httpClient = http.Client();

  Future<dynamic> get(String url) async {
    try {
      Uri uri = Uri.parse(ApiConstants.baseUrl + url);

      final response = await _httpClient.get(uri);
      var responseJson = _response(response);
      return responseJson;
    } on SocketException catch (ex) {
      throw FetchDataException('No internet connection: ${ex.message}');
    }
  }

  Future<dynamic> post(String url, [dynamic body]) async {
    try {
      Uri uri = Uri.parse(ApiConstants.baseUrl + url);

      final response = await _httpClient.post(uri, body: jsonEncode(body));
      var responseJson = _response(response);
      return responseJson;

      /*} on SocketException catch(ex) {
      throw FetchDataException('No internet connection: ${ex.message}');
    }*/
    } on Exception catch (ex) {
      throw ex;
    }
  }

  Future<dynamic> postMultiPart(
      String url, dynamic body, PlatformFile file, String token) async {
    try {
      Uri uri = Uri.parse(ApiConstants.baseUrl + url);

      Map<String, String> headers = Map();
      headers.addAll({
        'Content-Type': 'multipart/form-data',
        'Authorization': 'Bearer ${token}',
      });
      var bodyPart;
      var request = new http.MultipartRequest('POST', uri);
      final httpImage = http.MultipartFile.fromBytes('file', file.bytes!,
          contentType: MediaType('file', file.extension!), filename: file.name);
      request.files.add(httpImage);
      request.headers.addAll(headers);
      if (body != null) {
        bodyPart = http.MultipartFile.fromString('body', jsonEncode(body),
            contentType: MediaType('application', 'json'));
        request.files.add(bodyPart);
      }

      final response = await _httpClient!.send(request);
      var responseJson = response.stream.bytesToString();
      return responseJson;
    } on SocketException catch (ex) {
      throw Exception('No internet connection: ${ex.message}');
    }
  }

  Future<dynamic> putMultiPart(
      String url, dynamic body, PlatformFile file, String token) async {
    try {
      Uri uri = Uri.parse(ApiConstants.baseUrl + url);

      Map<String, String> headers = Map();
      headers.addAll({
        'Content-Type': 'multipart/form-data',
        'Authorization': 'Bearer ${token}',
      });
      var bodyPart;
      var request = new http.MultipartRequest('PUT', uri);
      final httpImage = http.MultipartFile.fromBytes('file', file.bytes!,
          contentType: MediaType('file', file.extension!), filename: file.name);
      request.files.add(httpImage);
      request.headers.addAll(headers);
      if (body != null) {
        bodyPart = http.MultipartFile.fromString('body', jsonEncode(body),
            contentType: MediaType('application', 'json'));
        request.files.add(bodyPart);
      }

      final response = await _httpClient!.send(request);
      var responseJson = response.stream.bytesToString();
      return responseJson;
    } on SocketException catch (ex) {
      throw Exception('No internet connection: ${ex.message}');
    }
  }

  Future<dynamic> put(String url, dynamic body) async {
    try {
      Uri uri = Uri.parse(ApiConstants.baseUrl + url);

      Map<String, String> headers = Map();
      headers.addAll({"Content-Type": 'application/json'});

      final response =
          await _httpClient!.put(uri, body: jsonEncode(body), headers: headers);
      var responseJson = _response(response);
      return responseJson;
    } on SocketException catch (ex) {
      throw Exception('No internet connection: ${ex.message}');
    }
  }

  Future<dynamic> delete(String url) async {
    try {
      Uri uri = Uri.parse(ApiConstants.baseUrl + url);

      final response = await _httpClient.delete(uri);
      var responseJson = _response(response);
      return responseJson;
    } on SocketException catch (ex) {
      throw Exception('No internet connection: ${ex.message}');
    }
  }

  dynamic _response(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        var responseJson = utf8.decode(response.bodyBytes);
        return responseJson;
      case 204:
        return;
      case 400:
        throw BadRequestException(utf8.decode(response.bodyBytes));
      case 401:
        throw AuthenticationException(
            "You have entered an invalid username or password");
      case 403:
        throw UnauthorizedException(utf8.decode(response.bodyBytes));
      case 404:
        throw NotFoundException(utf8.decode(response.bodyBytes));
      case 500:
      default:
        throw FetchDataException(
            'Error occurred while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}

// ignore_for_file: prefer_typing_uninitialized_variables
// ignore_for_file: annotate_overrides

class CustomException implements Exception {
  final message;
  final _prefix;

  CustomException([this.message, this._prefix]);

  String toString() {
    return "$_prefix$message";
  }
}

class FetchDataException extends CustomException {
  FetchDataException([String? message]) : super(message, "");
}

class BadRequestException extends CustomException {
  BadRequestException([message]) : super(message, "");
}

class AuthenticationException extends CustomException {
  AuthenticationException([message]) : super(message, "");
}

class UnauthorizedException extends CustomException {
  UnauthorizedException([message]) : super(message, "");
}

class NotFoundException extends CustomException {
  NotFoundException([message]) : super(message, "");
}

class AuthorizationInterceptor implements InterceptorContract {
  late LocalStorageService _localStorageService;

  AuthorizationInterceptor() {
    //_localStorageService = getIt<LocalStorageService>();
    GetIt.I
        .getAsync<LocalStorageService>()
        .then((value) => _localStorageService = value);
  }

  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    try {
      var token = await _localStorageService.getFromDisk("user_token");
      data.headers["Authorization"] = "Bearer " + token;
    } catch (e) {
      print(e);
    }

    return Future.value(data);
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    if (data.statusCode == 401 || data.statusCode == 403) {
      Future.delayed(Duration(seconds: 1), () {
        Navigator.of(GlobalContext.ctx).push<void>(MyApp.route());
      });
    }

    return Future.value(data);
  }
}

@Order(-10)
@singleton
class RestAuthenticatedClient extends RestClient {
  RestAuthenticatedClient()
      : super.withInterceptors(
            List.of(<InterceptorContract>[AuthorizationInterceptor()]));
}
