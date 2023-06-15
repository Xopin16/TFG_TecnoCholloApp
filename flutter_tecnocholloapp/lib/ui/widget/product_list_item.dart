import 'dart:convert';
import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../pages/details_page.dart';

class ProductListItem extends StatelessWidget {
  final Product product;
  const ProductListItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isMobile = MediaQuery.of(context).size.width < 600;
    final imageWidth = isMobile ? 60.0 : 100.0;
    final imageSize = Size(imageWidth, imageWidth);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetailPage(id: product.id),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(4.0),
              child: SizedBox(
                width: imageWidth,
                height: imageWidth,
                child: Image.network(
                  product.imagen == null
                      ? "https://m.media-amazon.com/images/I/71uwa0mHA8L._AC_SY450_.jpg"
                      : "http://10.0.2.2:8080/download/${product.imagen}",
                  // : "http://localhost:8080/download/${product.imagen}",
                  fit: BoxFit.cover,
                  // width: imageWidth,
                  // height: imageWidth,
                ),
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${utf8.decode(product.nombre.codeUnits)}",
                    style: textTheme.titleLarge,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  SizedBox(height: 4),
                  Text(
                    "${product.precio}€",
                    style: textTheme.titleMedium,
                  ),
                  // SizedBox(height: 8),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.end,
                  //   children: [
                  //     IconButton(
                  //       onPressed: () {
                  //         Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //             builder: (_) => DetailPage(id: product.id),
                  //           ),
                  //         );
                  //       },
                  //       icon: Icon(Icons.visibility),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
