import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_tecnocholloapp/services/product_service.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import '../../config/locator.dart';
import '../../models/user.dart';
import 'home_page.dart';

class EditProductBloc extends FormBloc<String, String> {
  late final ProductService _productService;
  final int id;
  final nombre = TextFieldBloc();
  final precio = TextFieldBloc();
  final descripcion = TextFieldBloc();
  // final showSuccessResponse = BooleanFieldBloc();

  EditProductBloc(this.id) {
    _productService = getIt<ProductService>();
    addFieldBlocs(
      fieldBlocs: [
        nombre,
        precio,
        descripcion,
      ],
    );
  }

  @override
  void onSubmitting() async {
    // await Future<void>.delayed(const Duration(seconds: 1));
    try {
      final result = await _productService.editProduct(
          id, nombre.value, double.parse(precio.value), descripcion.value);
      emitSuccess();
    } on Exception catch (_) {
      emitFailure();
    }
  }
}

class EditProductForm extends StatelessWidget {
  const EditProductForm({super.key, required this.id, required this.user});
  final int id;
  final User user;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditProductBloc(id),
      child: Builder(
        builder: (context) {
          final newProductBloc = context.read<EditProductBloc>();

          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(title: const Text('Editar chollo')),
            body: FormBlocListener<EditProductBloc, String, String>(
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
                          user: user,
                        )));
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
                        textFieldBloc: newProductBloc.nombre,
                        keyboardType: TextInputType.name,
                        decoration: const InputDecoration(
                          labelText: 'Nombre',
                          prefixIcon: Icon(Icons.person),
                        ),
                      ),
                      TextFieldBlocBuilder(
                        textFieldBloc: newProductBloc.precio,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: const InputDecoration(
                          labelText: 'Precio',
                          prefixIcon: Icon(Icons.price_change),
                        ),
                      ),
                      TextFieldBlocBuilder(
                        textFieldBloc: newProductBloc.descripcion,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: const InputDecoration(
                          labelText: 'Descripcion',
                          prefixIcon: Icon(Icons.password),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: newProductBloc.submit,
                        child: const Text('EDITAR'),
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

class SuccessScreen extends StatefulWidget {
  final User user;
  const SuccessScreen({super.key, required this.user});

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  @override
  void initState() {
    Timer(Duration(seconds: 1), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => HomePage(
                    user: widget.user,
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
              '¡PRODUCTO EDITADO!',
              style: TextStyle(fontSize: 24, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
