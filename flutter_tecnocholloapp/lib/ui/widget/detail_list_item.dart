import 'dart:convert';
import 'package:flutter/material.dart';
import '../../models/models.dart';


class DetailsListItem extends StatelessWidget {
  const DetailsListItem({super.key, required this.details});
  final Product details;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles del Producto'),
        backgroundColor: Color.fromARGB(104, 86, 159, 192),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 16.0,
            ),
            Center(
              child: Text(
                "${utf8.decode(details.nombre.codeUnits)}",
                style: textTheme.headlineMedium,
              ),
            ),
            SizedBox(
              height: 16.0,
            ),
            Text(
              "Descripción:",
              style: textTheme.titleLarge,
            ),
            SizedBox(
              height: 8.0,
            ),
            Text(
              "${utf8.decode(details.descripcion.codeUnits)}",
              style: textTheme.bodyLarge,
            ),
            SizedBox(
              height: 16.0,
            ),
            Text(
              "Precio:",
              style: textTheme.titleLarge,
            ),
            SizedBox(
              height: 8.0,
            ),
            Text(
              "${details.precio}" + "€",
              style: textTheme.bodyLarge,
            ),
            SizedBox(
              height: 16.0,
            ),
            Text(
              "Fecha de publicación:",
              style: textTheme.titleLarge,
            ),
            SizedBox(
              height: 8.0,
            ),
            Text(
              "${details.fechaPublicacion}",
              style: textTheme.bodyLarge,
            ),
            SizedBox(
              height: 16.0,
            ),
            // ElevatedButton(
            //   onPressed: () {
            //     final productService = getIt<ProductService>();
            //     productService.addFavourite(details.id);
            //   },
            //   child: Text("Agregar favorito"),
            // )
          ],
        ),
      ),
    );
  }
}
