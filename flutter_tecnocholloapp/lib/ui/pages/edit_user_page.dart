import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_tecnocholloapp/blocs/authentication/authentication.dart';
import 'package:flutter_tecnocholloapp/config/locator.dart';
import 'package:flutter_tecnocholloapp/ui/pages/login_page.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/edit_user.dart';
import '../../models/user.dart';
import '../../services/authentication_service.dart';
import 'home_page.dart';

class EditUserBloc extends FormBloc<String, String> {
  late final AuthenticationService _authService;
  final email = TextFieldBloc();
  final verifyEmail = TextFieldBloc();
  late PlatformFile file;

  EditUserBloc() {
    _authService = getIt<JwtAuthenticationService>();
    addFieldBlocs(
      fieldBlocs: [email, verifyEmail],
    );
  }

  @override
  FutureOr<void> onSubmitting() async {
    try {
      final result = _authService.editUser(
          EditUser(email: email.value, verifyEmail: verifyEmail.value), file);
      // AuthenticationBloc(_authService)..add(AppLoaded());
      emitSuccess();
    } on Exception catch (_) {
      emitFailure();
    }
  }

  void saveImage(PlatformFile newFile) {
    file = newFile;
  }
}

class EditUserForm extends StatefulWidget {
  const EditUserForm({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  State<StatefulWidget> createState() => _EditUserFormState();
}

class _EditUserFormState extends State<EditUserForm> {
  late EditUserBloc _editUserBloc = EditUserBloc();
  final picker = ImagePicker();
  late File _image;
  FilePickerResult? result;
  bool imgSelected = false;

  @override
  void initState() {
    super.initState();
    _editUserBloc = EditUserBloc();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _editUserBloc,
      child: Builder(builder: (context) {
        final editUserBloc = context.read<EditUserBloc>();
        return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              title: const Text('EDITAR PERFIL'),
              backgroundColor: Color.fromARGB(211, 244, 67, 54),
            ),
            body: FormBlocListener<EditUserBloc, String, String>(
                onSubmitting: (context, state) {
                  LoadingDialog.show(context);
                },
                onSubmissionFailed: (context, state) {
                  LoadingDialog.hide(context);
                },
                onSuccess: (context, state) {
                  LoadingDialog.hide(context);

                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (_) => SuccessScreen(
                            user: widget.user,
                          )));
                },
                onFailure: (context, state) {
                  LoadingDialog.hide(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.failureResponse!)));
                },
                child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(32, 20, 2, 0),
                            child: Text(
                              'Email',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          SizedBox(height: 4),
                          Container(
                            padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                            child: TextFieldBlocBuilder(
                              textFieldBloc: editUserBloc.email,
                              keyboardType: TextInputType.name,
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
                          SizedBox(height: 4),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(32, 20, 2, 0),
                            child: Text(
                              'Re-Email',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          SizedBox(height: 4),
                          Container(
                            padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                            child: TextFieldBlocBuilder(
                              textFieldBloc: editUserBloc.verifyEmail,
                              keyboardType: TextInputType.name,
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
                          ElevatedButton(
                              onPressed: () async {
                                result = await FilePicker.platform.pickFiles(
                                  withData: true,
                                  allowMultiple: false,
                                  allowedExtensions: ['jpg', 'png'],
                                );
                                setState(() {
                                  imgSelected = result != null;
                                });
                                if (imgSelected)
                                  editUserBloc.saveImage(result!.files[0]);
                              },
                              child: Text("Seleccione una imagen")),
                          SizedBox(
                            height: 10,
                          ),
                          Center(
                            child: ElevatedButton(
                              onPressed: editUserBloc.submit,
                              child: const Text('GUARDAR'),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Color.fromARGB(211, 244, 67, 54)),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ]))));
      }),
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

class SuccessScreen extends StatefulWidget {
  final User user;
  const SuccessScreen({super.key, required this.user});

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  @override
  void initState() {
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => LoginPage(
                  // user: widget.user,
                  )));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(
              Icons.check_circle_outline_rounded,
              size: 100,
              color: Colors.green,
            ),
            const SizedBox(height: 10),
            const Text(
              '¡USUARIO EDITADO! Se redirigirá al login por motivos de seguridad.',
              style: TextStyle(fontSize: 20, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
