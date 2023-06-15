import 'dart:convert';
import 'package:flutter/material.dart';
import '../../models/category.dart';
import '../../models/user.dart';
import '../pages/products_category_page.dart';

class CategoryListItem extends StatelessWidget {
  final Category category;
  final User user;
  const CategoryListItem(
      {super.key, required this.category, required this.user});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isMobile = MediaQuery.of(context).size.width < 600;
    final imageWidth = isMobile ? 80.0 : 120.0;
    final imageSize = Size(imageWidth, imageWidth);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CategoryProductPage(id: category.id),
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
                  "https://img.salamancartvaldia.es/simg/imgf/2016/09/fichero_160070_20160906.jpg",
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
                    "${utf8.decode(category.nombre.codeUnits)}",
                    style: textTheme.titleLarge,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
