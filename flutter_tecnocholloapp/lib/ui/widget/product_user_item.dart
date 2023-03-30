import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tecnocholloapp/blocs/productUser/product_user_event.dart';
import '../../blocs/productUser/product_user.dart';
import '../../models/models.dart';
import '../pages/details_page.dart';


class ProductUserListItem extends StatelessWidget {
  final Product product;
  final User user;
  const ProductUserListItem(
      {super.key, required this.product, required this.user});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isMobile = MediaQuery.of(context).size.width < 600;
    final imageWidth = isMobile ? 120.0 : 200.0;
    final imageSize = Size(imageWidth, imageWidth);

    return Card(
      margin: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4.0),
            child: SizedBox(
              width: imageWidth,
              height: imageWidth,
              child: Image.network(
                product.imagen == null
                    ? "https://m.media-amazon.com/images/I/71uwa0mHA8L._AC_SY450_.jpg"
                    : "http://localhost:8080/download/${product.imagen}",
                fit: BoxFit.cover,
                width: imageWidth,
                height: imageWidth,
              ),
            ),
          ),
          SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(
              "${utf8.decode(product.nombre.codeUnits)}",
              style: textTheme.titleLarge,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
          SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(
              "${product.precio}€",
              style: textTheme.titleMedium,
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () {
                  //                       onPressed: () {
                  dialog(context, product);
                  //                       }
                },
                icon: Icon(Icons.delete),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DetailPage(id: product.id),
                    ),
                  );
                },
                icon: Icon(Icons.visibility),
              ),
              // IconButton(
              //   onPressed: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (_) => EditProductForm(
              //           id: product.id,
              //           user: user,
              //         ),
              //       ),
              //     );
              //   },
              //   icon: Icon(Icons.edit),
              // ),
            ],
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  Future<void> dialog(BuildContext contexto, Product product) {
    return showDialog<void>(
      context: contexto,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("¿Estás seguro de querer eliminar el producto?"),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            ElevatedButton(
              child: const Text('Borrar'),
              onPressed: () {
                BlocProvider.of<ProductUserBloc>(contexto)
                  ..add(RemoveProduct(product.id));
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}