import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_tecnocholloapp/blocs/carrito/carrito_event.dart';
import 'package:flutter_tecnocholloapp/blocs/favorito/favorito_bloc.dart';
import 'package:flutter_tecnocholloapp/blocs/favorito/favorito_event.dart';
import 'package:flutter_tecnocholloapp/services/carrito_service.dart';
import 'package:flutter_tecnocholloapp/services/venta_service.dart';
import '../../blocs/carrito/carrito_bloc.dart';
import '../../config/locator.dart';
import '../../models/models.dart';
import '../../services/product_service.dart';

class DetailsListItem extends StatefulWidget {
  const DetailsListItem({Key? key, required this.details}) : super(key: key);

  final Product details;

  @override
  _DetailsListItemState createState() => _DetailsListItemState();
}

class _DetailsListItemState extends State<DetailsListItem> {
  bool inCart = false;
  bool inFav = false;

  @override
  void initState() {
    super.initState();
    // inCart = widget.details.inCart;
    inFav = widget.details.inFav;
  }

  void _toggleCart() {
    setState(() {
      inCart = !inCart;
      inFav = !inFav;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text('DETALLES'),
        backgroundColor: Color.fromARGB(211, 244, 67, 54),
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.shopping_basket),
        //     tooltip: 'Show Snackbar',
        //     onPressed: () {
        //       ScaffoldMessenger.of(context).showSnackBar(
        //           const SnackBar(content: Text('This is a snackbar')));
        //     },
        //   ),
        // ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {},
          backgroundColor: Colors.green,
          child: const Icon(Icons.favorite)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                widget.details.imagen == null
                    ? "https://m.media-amazon.com/images/I/71uwa0mHA8L._AC_SY450_.jpg"
                    : "http://10.0.2.2:8080/download/${widget.details.imagen}",
                fit: BoxFit.cover,
                // width: imageWidth,
                // height: imageWidth,
                height: 200,
              ),
            ),
            SizedBox(
              height: 16.0,
            ),
            Center(
              child: Text(
                "${utf8.decode(widget.details.nombre.codeUnits)}",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    icon: inFav
                        ? Icon(Icons.favorite, color: Colors.red)
                        : Icon(Icons.favorite, color: Colors.black),
                    onPressed: () {
                      setState(() {
                        if (inFav) {
                          final productService = getIt<ProductService>();
                          FavouriteBloc(productService)
                            ..add(RemoveFavorite(widget.details.id));
                        } else {
                          final productService = getIt<ProductService>();
                          productService.addFavourite(widget.details.id);
                        }
                        inFav = !inFav;
                      });
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
              "${utf8.decode(widget.details.descripcion.codeUnits)}",
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
              "${widget.details.precio}" + "€",
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
                child: Text(
                  inCart ? 'BORRAR DEL CARRITO' : 'AGREGAR AL CARRITO',
                  style: TextStyle(color: Colors.black),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    inCart
                        ? Color.fromARGB(211, 244, 67, 54)
                        : Color.fromARGB(210, 85, 211, 60),
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    if (inCart) {
                      final carritoService = getIt<CarritoService>();
                      final ventaService = getIt<VentaService>();
                      CarritoBloc(carritoService, ventaService)
                        ..add(RemoveCarrito(widget.details.id));
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("¡Se borró del carrito!")));
                      Timer(Duration(seconds: 1), () {});
                    } else {
                      final carritoService = getIt<CarritoService>();
                      carritoService.addProductToCart(widget.details.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("¡Se agregó del carrito!")));
                      Timer(Duration(seconds: 1), () {});
                    }
                    inCart = !inCart;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
