import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/favorito/favorito_bloc.dart';
import '../../blocs/favorito/favorito_event.dart';
import '../../models/models.dart';

class FavouriteListItem extends StatelessWidget {
  final Product product;
  const FavouriteListItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isMobile = MediaQuery.of(context).size.width < 600;
    final imageWidth = isMobile ? 120.0 : 200.0;
    final imageSize = Size(imageWidth, imageWidth);

    return Card(
      margin: const EdgeInsets.all(30),
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
                  BlocProvider.of<FavouriteBloc>(context)
                    ..add(RemoveFavorite(product.id));
                },
                icon: Icon(Icons.delete),
              ),
            ],
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}
