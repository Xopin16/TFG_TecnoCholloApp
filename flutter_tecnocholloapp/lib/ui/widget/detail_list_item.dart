import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_tecnocholloapp/services/carrito_service.dart';
import '../../config/locator.dart';
import '../../models/models.dart';
import '../../services/product_service.dart';

class DetailsListItem extends StatelessWidget {
  const DetailsListItem({super.key, required this.details});
  final Product details;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles'),
        backgroundColor: Color.fromARGB(211, 244, 67, 54),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                details.imagen == null
                    ? "https://m.media-amazon.com/images/I/71uwa0mHA8L._AC_SY450_.jpg"
                    : "http://localhost:8080/download/${details.imagen}",
                fit: BoxFit.cover,
                // width: imageWidth,
                // height: imageWidth,
              ),
            ),
            SizedBox(
              height: 16.0,
            ),
            Center(
              child: Text(
                "${utf8.decode(details.nombre.codeUnits)}",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    icon: Icon(Icons.favorite, color: Colors.red),
                    onPressed: () {
                      final productService = getIt<ProductService>();
                      productService.addFavourite(details.id);
                    },
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 16.0,
            ),
            Text(
              "Descripción:",
              style: textTheme.titleSmall,
            ),
            SizedBox(
              height: 8.0,
            ),
            Text(
              "${utf8.decode(details.descripcion.codeUnits)}",
              style: textTheme.bodySmall,
            ),
            SizedBox(
              height: 16.0,
            ),
            Text(
              "Precio:",
              style: textTheme.titleSmall,
            ),
            SizedBox(
              height: 8.0,
            ),
            Text(
              "${details.precio}" + "€",
              style: textTheme.bodySmall,
            ),
            // SizedBox(
            //   height: 16.0,
            // ),
            // Text(
            //   "Fecha de publicación:",
            //   style: textTheme.titleSmall,
            // ),
            // SizedBox(
            //   height: 8.0,
            // ),
            // Text(
            //   "${details.fechaPublicacion}",
            //   style: textTheme.bodySmall,
            // ),
            SizedBox(
              height: 16.0,
            ),
            Center(
              child: ElevatedButton(
                // onPressed: registerFormBloc.submit,
                child: const Text(
                  'AGREGAR AL CARRITO',
                  style: TextStyle(color: Colors.black),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Color.fromARGB(211, 244, 67, 54)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                onPressed: () {
                  final carritoService = getIt<CarritoService>();
                  carritoService.addProductToCart(details.id);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
