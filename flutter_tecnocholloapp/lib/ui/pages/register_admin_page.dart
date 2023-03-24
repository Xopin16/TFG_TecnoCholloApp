import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_tecnocholloapp/services/authentication_service.dart';

import '../../config/locator.dart';

class RegisterAdminBloc extends FormBloc<String, String> {
  late final AuthenticationService _authenticationService;
  final username = TextFieldBloc();
  final password = TextFieldBloc();
  final verifyPassword = TextFieldBloc();
  final email = TextFieldBloc();
  final verifyEmail = TextFieldBloc();
  final fullName = TextFieldBloc();
  // final showSuccessResponse = BooleanFieldBloc();

  RegisterAdminBloc() {
    _authenticationService = getIt<JwtAuthenticationService>();
    addFieldBlocs(
      fieldBlocs: [
        username,
        password,
        verifyPassword,
        email,
        verifyEmail,
        fullName,
      ],
    );
  }

  @override
  void onSubmitting() async {
    // await Future<void>.delayed(const Duration(seconds: 1));
    try {
      final result = await _authenticationService.registerAdmin(
          username.value,
          password.value,
          verifyPassword.value,
          email.value,
          verifyEmail.value,
          fullName.value);
      emitSuccess();
    } on Exception catch (_) {
      emitFailure();
    }
  }
}

class RegisterAdminForm extends StatelessWidget {
  const RegisterAdminForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterAdminBloc(),
      child: Builder(
        builder: (context) {
          final loginFormBloc = context.read<RegisterAdminBloc>();

          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(title: const Text('Registrar admin')),
            body: FormBlocListener<RegisterAdminBloc, String, String>(
              onSubmitting: (context, state) {
                LoadingDialog.show(context);
              },
              onSubmissionFailed: (context, state) {
                LoadingDialog.hide(context);
              },
              onSuccess: (context, state) {
                LoadingDialog.hide(context);

                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const SuccessScreen()));
              },
              onFailure: (context, state) {
                LoadingDialog.hide(context);

                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.failureResponse!)));
              },
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: AutofillGroup(
                  child: Column(
                    children: <Widget>[
                      TextFieldBlocBuilder(
                        textFieldBloc: loginFormBloc.username,
                        keyboardType: TextInputType.name,
                        decoration: const InputDecoration(
                          labelText: 'Username',
                          prefixIcon: Icon(Icons.person),
                        ),
                      ),
                      TextFieldBlocBuilder(
                        textFieldBloc: loginFormBloc.password,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: const InputDecoration(
                          labelText: 'Contraseña',
                          prefixIcon: Icon(Icons.password),
                        ),
                      ),
                      TextFieldBlocBuilder(
                        textFieldBloc: loginFormBloc.verifyPassword,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: const InputDecoration(
                          labelText: 'Verificación de contraseña',
                          prefixIcon: Icon(Icons.password),
                        ),
                      ),
                      TextFieldBlocBuilder(
                        textFieldBloc: loginFormBloc.email,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email),
                        ),
                      ),
                      TextFieldBlocBuilder(
                        textFieldBloc: loginFormBloc.verifyEmail,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Verificación de email',
                          prefixIcon: Icon(Icons.email),
                        ),
                      ),
                      TextFieldBlocBuilder(
                        textStyle: TextStyle(color: Colors.white),
                        cursorColor: Colors.white,
                        textFieldBloc: loginFormBloc.fullName,
                        keyboardType: TextInputType.name,
                        decoration: const InputDecoration(
                          focusColor: Colors.white,
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 2.0)),
                          labelText: 'Nombre completo',
                          prefixIcon: Icon(Icons.person_2_outlined),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: loginFormBloc.submit,
                        child: const Text('Registrarse'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class LoadingDialog extends StatelessWidget {
  static void show(BuildContext context, {Key? key}) => showDialog<void>(
        context: context,
        useRootNavigator: false,
        barrierDismissible: false,
        builder: (_) => LoadingDialog(key: key),
      ).then((_) => FocusScope.of(context).requestFocus(FocusNode()));

  static void hide(BuildContext context) => Navigator.pop(context);

  const LoadingDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Center(
        child: Card(
          child: Container(
            width: 80,
            height: 80,
            padding: const EdgeInsets.all(12.0),
            child: const CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(Icons.tag_faces, size: 100),
            const SizedBox(height: 10),
            const Text(
              'Success',
              style: TextStyle(fontSize: 54, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const RegisterAdminForm())),
              icon: const Icon(Icons.replay),
              label: const Text('AGAIN'),
            ),
          ],
        ),
      ),
    );
  }
}
