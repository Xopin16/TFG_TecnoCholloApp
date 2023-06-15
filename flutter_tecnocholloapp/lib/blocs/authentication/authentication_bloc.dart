import 'package:bloc/bloc.dart';
import 'package:flutter_tecnocholloapp/rest/rest_client.dart';
import '../../services/authentication_service.dart';
import 'authentication_event.dart';
import 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationService _authenticationService;

  AuthenticationBloc(AuthenticationService authenticationService)
      : assert(authenticationService != null),
        _authenticationService = authenticationService,
        super(AuthenticationInitial()) {
    on<AppLoaded>(_onAppLoaded);
    on<UserLoggedIn>(_onUserLoggedIn);
    on<UserLoggedOut>(_onUserLoggedOut);
    on<SessionExpiredEvent>(_onSessionExpired);
    on<DeleteAccount>(_onDeleteAccount);
    on<UserEdited>(_onUserEdited);
  }

  _onAppLoaded(
    AppLoaded event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(AuthenticationLoading());
    try {
      await Future.delayed(Duration(milliseconds: 500)); // a simulated delay
      final currentUser = await _authenticationService.getCurrentUser();
      if (currentUser != null) {
        emit(AuthenticationAuthenticated(user: currentUser));
      } else {
        emit(AuthenticationNotAuthenticated());
      }
    } on UnauthorizedException catch (e) {
      print(e);
      emit(AuthenticationNotAuthenticated());
    } on Exception catch (e) {
      emit(AuthenticationFailure(
          message: 'An unknown error occurred: ${e.toString()}'));
    }
  }

  _onUserEdited(
    UserEdited event,
    Emitter<AuthenticationState> emit,
  ) async {
    // try {
    await Future.delayed(Duration(milliseconds: 500)); // a simulated delay
    final currentUser = await _authenticationService.getCurrentUser();
    emit(UserEditedState(user: currentUser!));
    // } catch (e) {

    // }
  }

  _onUserLoggedIn(
    UserLoggedIn event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(AuthenticationAuthenticated(user: event.user));
  }

  _onUserLoggedOut(
    UserLoggedOut event,
    Emitter<AuthenticationState> emit,
  ) async {
    await _authenticationService.signOut();
    emit(AuthenticationNotAuthenticated());
  }

  _onSessionExpired(
    SessionExpiredEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    //emit(AuthenticationFailure(message: 'An unknown error occurred: ${e.toString()}'));
    print("sesión expirada");
    await _authenticationService.signOut();
    emit(SessionExpiredState());
  }

  _onDeleteAccount(
    DeleteAccount event,
    Emitter<AuthenticationState> emit,
  ) async {
    try {
      await _authenticationService.deleteUser();
      emit(UserDeletedState());
    } catch (_) {
      emit(UserFailDeleteState());
    }
  }
}
