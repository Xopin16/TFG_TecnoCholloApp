import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

import '../../config/locator.dart';
import '../../services/authentication_service.dart';

class LoginFormBloc extends FormBloc<String, String> {
  late final AuthenticationService _authenticationService;
  final username = TextFieldBloc(validators: [FieldBlocValidators.required]);
  final password = TextFieldBloc(validators: [FieldBlocValidators.required]);
  final verifyPassword =
      TextFieldBloc(validators: [FieldBlocValidators.required]);
  final email = TextFieldBloc(validators: [FieldBlocValidators.required]);
  final verifyEmail = TextFieldBloc(validators: [FieldBlocValidators.required]);
  final fullName = TextFieldBloc(validators: [FieldBlocValidators.required]);
  // final showSuccessResponse = BooleanFieldBloc();

  Validator<String> _equalsPasswordsEmail(
    TextFieldBloc registerFormBloc,
  ) {
    return (String? password) {
      if (password == registerFormBloc.value) {
        return null;
      }
      return 'Las contraseñas y emails deben ser iguales';
    };
  }

  LoginFormBloc() {
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

    password
      ..addValidators([_equalsPasswordsEmail(verifyPassword)])
      ..subscribeToFieldBlocs([verifyPassword]);
    email
      ..addValidators([_equalsPasswordsEmail(verifyEmail)])
      ..subscribeToFieldBlocs([verifyEmail]);
  }

  @override
  void onSubmitting() async {
    // await Future<void>.delayed(const Duration(seconds: 1));
    try {
      final result = await _authenticationService.register(
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

class RegisterForm extends StatelessWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginFormBloc(),
      child: Builder(
        builder: (context) {
          final registerFormBloc = context.read<LoginFormBloc>();

          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              title: const Text('REGISTRARSE'),
              backgroundColor: Color.fromARGB(211, 244, 67, 54),
            ),
            body: FormBlocListener<LoginFormBloc, String, String>(
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(32, 20, 2, 0),
                            child: Text(
                              "Username",
                              style: TextStyle(
                                color: Colors.grey,
                                // fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                            child: TextFieldBlocBuilder(
                              textFieldBloc: registerFormBloc.username,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(36),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(32, 2, 2, 0),
                            child: Text(
                              "Password",
                              style: TextStyle(
                                color: Colors.grey,
                                // fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                            child: TextFieldBlocBuilder(
                              textFieldBloc: registerFormBloc.password,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(36),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(32, 2, 2, 0),
                            child: Text(
                              "Re-Password",
                              style: TextStyle(
                                color: Colors.grey,
                                // fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                            child: TextFieldBlocBuilder(
                              textFieldBloc: registerFormBloc.verifyPassword,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(36),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(32, 2, 2, 0),
                            child: Text(
                              "Email",
                              style: TextStyle(
                                color: Colors.grey,
                                // fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                            child: TextFieldBlocBuilder(
                              textFieldBloc: registerFormBloc.email,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(36),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(32, 2, 2, 0),
                            child: Text(
                              "Re-Email",
                              style: TextStyle(
                                color: Colors.grey,
                                // fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                            child: TextFieldBlocBuilder(
                              textFieldBloc: registerFormBloc.verifyEmail,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(36),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(32, 2, 2, 0),
                            child: Text(
                              "Fullname",
                              style: TextStyle(
                                color: Colors.grey,
                                // fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
                            child: TextFieldBlocBuilder(
                              textFieldBloc: registerFormBloc.fullName,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(36),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: registerFormBloc.submit,
                        child: const Text('Registrarse'),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color.fromARGB(211, 244, 67, 54)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
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
                  MaterialPageRoute(builder: (_) => const RegisterForm())),
              icon: const Icon(Icons.replay),
              label: const Text('AGAIN'),
            ),
          ],
        ),
      ),
    );
  }
}
