import 'package:flutter_tecnocholloapp/services/localstorage_service.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import '../config/locator.dart';
import '../models/models.dart';
import '../repositories/repositories.dart';

abstract class AuthenticationService {
  Future<User?> getCurrentUser();
  Future<User> signInWithEmailAndPassword(String email, String password);
  Future<void> signOut();
  Future<LoginResponse> register(String username, String password,
      String verifyPassword, String email, String verifyEmail, String fullName);
  Future<LoginResponse> registerAdmin(String username, String password,
      String verifyPassword, String email, String verifyEmail, String fullName);
  Future<LoginResponse> changePassWord(UserPassword userPassword);
  Future<void> deleteUser();
}

@Order(2)
//@Singleton(as: AuthenticationService)
@singleton
class JwtAuthenticationService extends AuthenticationService {
  late AuthenticationRepository _authenticationRepository;
  late LocalStorageService _localStorageService;
  late UserRepository _userRepository;

  JwtAuthenticationService() {
    _authenticationRepository = getIt<AuthenticationRepository>();
    _userRepository = getIt<UserRepository>();
    GetIt.I
        .getAsync<LocalStorageService>()
        .then((value) => _localStorageService = value);
  }

  @override
  Future<User?> getCurrentUser() async {
    //String? loggedUser = _localStorageService.getFromDisk("user");
    String? token = _localStorageService.getFromDisk("user_token");
    if (token != null) {
      UserResponse response = await _userRepository.me();
      return response;
    }
    return null;
  }

  @override
  Future<User> signInWithEmailAndPassword(String email, String password) async {
    LoginResponse response =
        await _authenticationRepository.doLogin(email, password);
    //await _localStorageService.saveToDisk('user', jsonEncode(response.toJson()));
    await _localStorageService.saveToDisk('user_token', response.token);
    return User.fromLoginResponse(response);
  }

  @override
  Future<LoginResponse> register(
      String username,
      String password,
      String verifyPassword,
      String email,
      String verifyEmail,
      String fullName) async {
    LoginResponse response = await _authenticationRepository.doRegister(
        username, password, verifyPassword, email, verifyEmail, fullName);
    return response;
  }

  @override
  Future<LoginResponse> registerAdmin(
      String username,
      String password,
      String verifyPassword,
      String email,
      String verifyEmail,
      String fullName) async {
    LoginResponse response = await _authenticationRepository.doRegisterAdmin(
        username, password, verifyPassword, email, verifyEmail, fullName);
    return response;
  }

  @override
  Future<void> signOut() async {
    print("borrando token");
    await _localStorageService.deleteFromDisk("user_token");
  }

  @override
  Future<LoginResponse> changePassWord(UserPassword userPassword) async {
    LoginResponse response =
        await _authenticationRepository.changePassword(userPassword);
    return response;
  }

  @override
  Future<void> deleteUser() async {
    // await _localStorageService.deleteFromDisk("user_token");
    return _userRepository.deleteUser();
  }
}
