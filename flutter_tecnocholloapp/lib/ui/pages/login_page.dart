import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tecnocholloapp/config/locator.dart';
import 'package:flutter_tecnocholloapp/ui/pages/register_page.dart';

import '../../blocs/authentication/authentication.dart';
import '../../blocs/blocs.dart';
import '../../blocs/login/login_bloc.dart';
import '../../services/authentication_service.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color.fromRGBO(30, 11, 204, 0),
      appBar: AppBar(
        title: Text('LOGIN'),
        backgroundColor: Colors.orangeAccent,
      ),
      body: SafeArea(
          minimum: const EdgeInsets.all(16),
          child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, state) {
              final authBloc = BlocProvider.of<AuthenticationBloc>(context);
              if (state is AuthenticationNotAuthenticated) {
                return _AuthForm();
              }
              if (state is AuthenticationFailure ||
                  state is SessionExpiredState) {
                var msg = (state as AuthenticationFailure).message;
                return Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(msg),
                    TextButton(
                      //textColor: Theme.of(context).primaryColor,
                      child: Text('Retry'),
                      onPressed: () {
                        authBloc.add(AppLoaded());
                      },
                    )
                  ],
                ));
              }
              // return splash screen
              return Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              );
            },
          )),
    );
  }
}

class _AuthForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //final authService = RepositoryProvider.of<AuthenticationService>(context);
    final authService = getIt<JwtAuthenticationService>();
    final authBloc = BlocProvider.of<AuthenticationBloc>(context);

    return Container(
      alignment: Alignment.center,
      child: BlocProvider<LoginBloc>(
        create: (context) => LoginBloc(authBloc, authService),
        child: _SignInForm(),
      ),
    );
  }
}

class _SignInForm extends StatefulWidget {
  @override
  __SignInFormState createState() => __SignInFormState();
}

class __SignInFormState extends State<_SignInForm> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  bool _autoValidate = false;

  @override
  Widget build(BuildContext context) {
    final _loginBloc = BlocProvider.of<LoginBloc>(context);

    _onLoginButtonPressed() {
      if (_key.currentState!.validate()) {
        _loginBloc.add(LoginInWithEmailButtonPressed(
            email: _emailController.text, password: _passwordController.text));
      } else {
        setState(() {
          _autoValidate = true;
        });
      }
    }

    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginFailure) {
          _showError(state.error);
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          if (state is LoginLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Form(
            key: _key,
            autovalidateMode: _autoValidate
                ? AutovalidateMode.always
                : AutovalidateMode.disabled,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Image.network(
                    'https://atodochollo.com/logo.png',
                    height: 200,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Nombre de usuario',
                      filled: true,
                      isDense: true,
                    ),
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'El nombre de usuario es obligatorio.';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      filled: true,
                      isDense: true,
                    ),
                    obscureText: true,
                    controller: _passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'La contraseña es obligatoria.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.orangeAccent),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        'Iniciar sesión',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    onPressed:
                        state is LoginLoading ? () {} : _onLoginButtonPressed,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => RegisterForm(),
                        ),
                      );
                    },
                    child: Text(
                      'Regístrate como usuario.',
                      style: TextStyle(
                        color: Colors.grey[800],
                      ),
                    ),
                  ),
                  // TextButton(
                  //   onPressed: () {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //         builder: (_) => RegisterAdminForm(),
                  //       ),
                  //     );
                  //   },
                  //   child: Text(
                  //     'Regístrate como administrador.',
                  //     style: TextStyle(
                  //       color: Colors.grey[800],
                  //     ),
                  //   ),
                  // )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showError(String error) {
    /*Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(error),
      backgroundColor: Theme.of(context).errorColor,
    ));*/

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
  }
}
