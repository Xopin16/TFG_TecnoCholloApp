import 'package:flutter/material.dart';
import '../../config/locator.dart';
import '../../models/user_password.dart';
import '../../services/authentication_service.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

class PasswordBloc extends FormBloc<String, String> {
  late final AuthenticationService _authenticationService;
  final oldPassword = TextFieldBloc(
    validators: [FieldBlocValidators.required],
  );
  final newPassword = TextFieldBloc(
    validators: [FieldBlocValidators.required],
  );
  final verifyNewPassword = TextFieldBloc(
    validators: [FieldBlocValidators.required],
  );

  PasswordBloc() {
    _authenticationService = getIt<JwtAuthenticationService>();
    addFieldBlocs(
      fieldBlocs: [
        oldPassword,
        newPassword,
        verifyNewPassword,
      ],
    );
  }

  @override
  void onSubmitting() async {
    // await Future<void>.delayed(const Duration(seconds: 1));
    try {
      final result = await _authenticationService.changePassWord(UserPassword(
          oldPassword.value, newPassword.value, verifyNewPassword.value));
      emitSuccess();
    } on Exception catch (_) {
      emitFailure();
    }
  }
}

class PasswordPage extends StatelessWidget {
  const PasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PasswordBloc(),
      child: Builder(
        builder: (context) {
          final changePasswordBloc = context.read<PasswordBloc>();

          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(title: const Text('Login')),
            body: FormBlocListener<PasswordBloc, String, String>(
              onSubmitting: (context, state) {
                LoadingDialog.show(context);
              },
              onSubmissionFailed: (context, state) {
                LoadingDialog.hide(context);
              },
              onSuccess: (context, state) {
                LoadingDialog.hide(context);
                Navigator.of(context).pop();
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
                        textFieldBloc: changePasswordBloc.oldPassword,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: const InputDecoration(
                          labelText: 'Contraseña',
                          prefixIcon: Icon(Icons.password),
                        ),
                      ),
                      TextFieldBlocBuilder(
                        textFieldBloc: changePasswordBloc.newPassword,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: const InputDecoration(
                          labelText: 'Contraseña',
                          prefixIcon: Icon(Icons.password),
                        ),
                      ),
                      TextFieldBlocBuilder(
                        textFieldBloc: changePasswordBloc.verifyNewPassword,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: const InputDecoration(
                          labelText: 'Verificación de contraseña',
                          prefixIcon: Icon(Icons.password),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: changePasswordBloc.submit,
                        child: const Text('EDITA'),
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
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                  "Volver") /*.pushReplacement(
                  MaterialPageRoute(builder: (_) => const CategoryForm())),
              icon: const Icon(Icons.replay),
              label: const Text('AGAIN')*/
              ,
            ),
          ],
        ),
      ),
    );
  }
}
