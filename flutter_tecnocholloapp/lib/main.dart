import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tecnocholloapp/services/authentication_service.dart';
import 'package:flutter_tecnocholloapp/ui/pages/home_page.dart';
import 'package:flutter_tecnocholloapp/ui/pages/login_page.dart';
import 'blocs/authentication/authentication.dart';
import 'config/locator.dart';

void main() {
  //WidgetsFlutterBinding.ensureInitialized();
  //await SharedPreferences.getInstance();
  setupAsyncDependencies();
  configureDependencies();
  //await getIt.allReady();
  // Bloc.observer = SimpleBlocObserver();

  runApp(BlocProvider<AuthenticationBloc>(
    create: (context) {
      //GlobalContext.ctx = context;
      final authService = getIt<JwtAuthenticationService>();
      return AuthenticationBloc(authService)..add(AppLoaded());
    },
    child: MyApp(),
  ));
}

class GlobalContext {
  static late BuildContext ctx;
}

class MyApp extends StatelessWidget {
  //static late  AuthenticationBloc _authBloc;

  static late MyApp _instance;

  static Route route() {
    print("Enrutando al login");
    return MaterialPageRoute<void>(builder: (context) {
      var authBloc = BlocProvider.of<AuthenticationBloc>(context);
      authBloc..add(SessionExpiredEvent());
      return _instance;
    });
  }

  MyApp() {
    _instance = this;
  }

  @override
  Widget build(BuildContext context) {
    //GlobalContext.ctx = context;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TecnocholloApp',
      // color: Color.fromRGBO(222, 32, 32, 0.726),
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          GlobalContext.ctx = context;
          if (state is AuthenticationAuthenticated) {
            // show home page
            return HomePage(
              user: state.user,
            );
          }
          // otherwise show login page
          return LoginPage();
        },
      ),
    );
  }
}
