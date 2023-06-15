import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tecnocholloapp/models/createproduct.dart';
import 'package:flutter_tecnocholloapp/services/category_service.dart';
import 'package:flutter_tecnocholloapp/services/product_service.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../config/locator.dart';
import '../../models/category.dart';

class NewProductBloc extends FormBloc<String, String> {
  late final ProductService _productService;
  final id = InputFieldBloc<int, Object>(
      initialValue: 1, validators: [FieldBlocValidators.required]);
  final nombre = TextFieldBloc(validators: [FieldBlocValidators.required]);
  final precio = TextFieldBloc(validators: [FieldBlocValidators.required]);
  final descripcion = TextFieldBloc(validators: [FieldBlocValidators.required]);
  final cantidad = TextFieldBloc(validators: [FieldBlocValidators.required]);
  final categoria = TextFieldBloc(validators: [FieldBlocValidators.required]);
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

  NewProductBloc() {
    _productService = getIt<ProductService>();
    addFieldBlocs(
      fieldBlocs: [nombre, precio, descripcion, cantidad, categoria],
    );

    precio..addValidators([_minValue(precio)]);
    cantidad..addValidators([_minValue(cantidad)]);
  }

  @override
  void onSubmitting() async {
    // await Future<void>.delayed(const Duration(seconds: 1));
    try {
      final result = await _productService.newProduct(
          CreateProduct(
              nombre: nombre.value,
              precio: double.parse(precio.value),
              descripcion: descripcion.value,
              categoria: categoria.value,
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

class NewProductForm extends StatefulWidget {
  NewProductForm({Key? key, required this.id}) : super(key: key);
  late final int id;

  @override
  _NewProductFormState createState() => _NewProductFormState();
}

class _NewProductFormState extends State<NewProductForm> {
  late NewProductBloc _newFormBloc = NewProductBloc();
  final categoryService = getIt<CategoryService>();
  CategoryResponse _categories = CategoryResponse(
      category: [],
      currentPage: 0,
      last: false,
      first: false,
      totalPages: 0,
      totalElements: 0);
  String selectedCategoryNombre = '';
  final picker = ImagePicker();
  FilePickerResult? result;
  bool imagen = false;

  @override
  void initState() {
    super.initState();
    _newFormBloc = NewProductBloc();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      _categories = await categoryService.getAllCategories(0);
      setState(() {
        selectedCategoryNombre = (_categories.category.isNotEmpty
            ? _categories.category[0].nombre
            : null)!;
      });
    } catch (e) {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _newFormBloc,
      child: Builder(builder: (context) {
        final newProductBloc = context.read<NewProductBloc>();
        return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              title: const Text('CREAR CHOLLO'),
              backgroundColor: Color.fromARGB(211, 244, 67, 54),
            ),
            body: FormBlocListener<NewProductBloc, String, String>(
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(32, 20, 2, 0),
                      child: Text(
                        'Nombre',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    SizedBox(height: 4),
                    Container(
                      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: TextFieldBlocBuilder(
                        textFieldBloc: newProductBloc.nombre,
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
                    Padding(
                      padding: const EdgeInsets.fromLTRB(32, 2, 2, 0),
                      child: Text(
                        'Precio',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    SizedBox(height: 4),
                    Container(
                      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: TextFieldBlocBuilder(
                        textFieldBloc: newProductBloc.precio,
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
                    Padding(
                      padding: const EdgeInsets.fromLTRB(32, 2, 2, 0),
                      child: Text(
                        'Descripción',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: TextFieldBlocBuilder(
                        textFieldBloc: newProductBloc.descripcion,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
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
                      padding: const EdgeInsets.fromLTRB(32, 2, 2, 0),
                      child: Text(
                        'Cantidad',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    SizedBox(height: 4),
                    Container(
                      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: TextFieldBlocBuilder(
                        textFieldBloc: newProductBloc.cantidad,
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
                    Padding(
                      padding: const EdgeInsets.fromLTRB(32, 2, 2, 0),
                      child: Text(
                        'Categoría',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    SizedBox(height: 4),
                    Container(
                      padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
                      child: DropdownButtonFormField<String>(
                        value: selectedCategoryNombre,
                        items: _categories.category.map((category) {
                          return DropdownMenuItem<String>(
                            value: category.nombre,
                            child: Text(category.nombre),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedCategoryNombre = value!;
                            newProductBloc.categoria.updateValue(value);
                          });
                        },
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
                    Center(
                      child: ElevatedButton(
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
                              newProductBloc.saveImage(result!.files[0]);
                          },
                          child: Text("Seleccione una imagen")),
                    ),
                    if (imagen) Center(child: Text(newProductBloc.file.name)),
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: ElevatedButton(
                        onPressed: imagen ? newProductBloc.submit : null,
                        child: const Text('AGREGAR'),
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
                    ),
                  ],
                ),
              ),
            ));
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
              child: Text("Volver"),
            ),
          ],
        ),
      ),
    );
  }
}
