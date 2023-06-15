import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tecnocholloapp/models/models.dart';
import 'package:flutter_tecnocholloapp/services/product_service.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../config/locator.dart';
import 'home_page.dart';

class EditProductBloc extends FormBloc<String, String> {
  late final ProductService _productService;
  final int id;
  final nombre = TextFieldBloc(validators: [FieldBlocValidators.required]);
  final precio = TextFieldBloc(validators: [FieldBlocValidators.required]);
  final descripcion = TextFieldBloc(validators: [FieldBlocValidators.required]);
  final cantidad = TextFieldBloc();
  late PlatformFile file;

  Validator<String> _minValue(
    TextFieldBloc newProductBloc,
  ) {
    return (String? precio) {
      if (double.parse(precio!) >= 0) {
        return null;
      }
      return 'La cantidad y el precio deben ser mayor que 0';
    };
  }

  EditProductBloc(this.id, Product product) {
    _productService = getIt<ProductService>();
    nombre.updateValue(product.nombre);
    precio.updateValue(product.precio.toString());
    descripcion.updateValue(product.descripcion);
    cantidad.updateValue(product.cantidad.toString());
    addFieldBlocs(
      fieldBlocs: [
        nombre,
        precio,
        descripcion,
        cantidad,
      ],
    );

    precio..addValidators([_minValue(precio)]);
    cantidad..addValidators([_minValue(cantidad)]);
  }

  @override
  void onSubmitting() async {
    // await Future<void>.delayed(const Duration(seconds: 1));
    try {
      final result = await _productService.editProduct(
          this.id,
          CreateProduct(
              nombre: nombre.value,
              precio: double.parse(precio.value),
              descripcion: descripcion.value,
              cantidad: int.parse(cantidad.value)),
          file);
      emitSuccess();
    } on Exception catch (_) {
      emitFailure();
    }
  }

  void saveImage(PlatformFile newFile) {
    file = newFile;
  }
}

class EditProductForm extends StatefulWidget {
  EditProductForm(
      {Key? key, required this.id, required this.user, required this.product})
      : super(key: key);
  late final int id;
  late final User user;
  late final Product product;

  @override
  _EditProductFormState createState() => _EditProductFormState();
}

class _EditProductFormState extends State<EditProductForm> {
  final picker = ImagePicker();
  FilePickerResult? result;
  bool imagen = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditProductBloc(widget.id, widget.product),
      child: Builder(
        builder: (context) {
          final editProductBloc = context.read<EditProductBloc>();

          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              title: const Text('EDITAR CHOLLO'),
              backgroundColor: Color.fromARGB(211, 244, 67, 54),
            ),
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
                    user: widget.user,
                  ),
                ));
              },
              onFailure: (context, state) {
                LoadingDialog.hide(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.failureResponse!)),
                );
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
                              "Nombre",
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          SizedBox(height: 4),
                          Container(
                            padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                            child: TextFieldBlocBuilder(
                              textFieldBloc: editProductBloc.nombre,
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
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(32, 2, 2, 0),
                            child: Text(
                              "Precio",
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          SizedBox(height: 4),
                          Container(
                            padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                            child: TextFieldBlocBuilder(
                              textFieldBloc: editProductBloc.precio,
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly,
                              ],
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
                              "Descripción",
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          SizedBox(height: 4),
                          Container(
                            padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
                            child: TextFieldBlocBuilder(
                              textFieldBloc: editProductBloc.descripcion,
                              keyboardType: TextInputType.text,
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
                              "Cantidad",
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          SizedBox(height: 4),
                          Container(
                            padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                            child: TextFieldBlocBuilder(
                              textFieldBloc: editProductBloc.cantidad,
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly,
                              ],
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
                          onPressed: () async {
                            result = await FilePicker.platform.pickFiles(
                              withData: true,
                              allowMultiple: false,
                              type: FileType.custom,
                              allowedExtensions: ['jpg', 'png'],
                            );
                            setState(() {
                              imagen = result != null;
                            });
                            if (imagen)
                              editProductBloc.saveImage(result!.files[0]);
                          },
                          child: Text("Seleccione una imagen")),
                      if (imagen) Text(editProductBloc.file.name),
                      SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: ElevatedButton(
                          onPressed: imagen ? editProductBloc.submit : null,
                          child: const Text('EDITAR'),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              Color.fromARGB(211, 244, 67, 54),
                            ),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
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
