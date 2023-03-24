import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tecnocholloapp/blocs/category/category.dart';
import '../../models/category.dart';
import '../../models/user.dart';
import '../pages/edit_category_page.dart';
import '../pages/new_product_page.dart';
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
    final imageWidth = isMobile ? 120.0 : 200.0;
    final imageSize = Size(imageWidth, imageWidth);

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: 600.0,
      ),
      child: Card(
        margin: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(4.0),
              child: SizedBox(
                width: imageWidth,
                height: imageWidth,
                child: Image.network(
                  "https://img.salamancartvaldia.es/simg/imgf/2016/09/fichero_160070_20160906.jpg",
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
                "${utf8.decode(category.nombre.codeUnits)}",
                style: textTheme.titleLarge,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
            SizedBox(height: 16),
            isMobile
                ? Wrap(
                    direction: Axis.horizontal,
                    alignment: WrapAlignment.end,
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  CategoryProductPage(id: category.id),
                            ),
                          );
                        },
                        icon: Icon(Icons.visibility),
                      ),
                      if (user.role == "ADMIN")
                        IconButton(
                          onPressed: () {
                            // onPressed: () {
                            dialog(context, category);
                            // }
                          },
                          icon: Icon(Icons.delete),
                        ),
                      if (user.role == "ADMIN")
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EditCategoryForm(
                                  id: category.id,
                                  user: user,
                                ),
                              ),
                            );
                          },
                          icon: Icon(Icons.edit),
                        ),
                      if (user.role == "ADMIN")
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => NewProductForm(
                                  id: category.id,
                                ),
                              ),
                            );
                          },
                          icon: Icon(Icons.add),
                        ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  CategoryProductPage(id: category.id),
                            ),
                          );
                        },
                        icon: Icon(Icons.visibility),
                      ),
                      if (user.role == "ADMIN")
                        IconButton(
                          onPressed: () {
                            // onPressed: () {
                            dialog(context, category);
                            // }
                          },
                          icon: Icon(Icons.delete),
                        ),
                      if (user.role == "ADMIN")
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EditCategoryForm(
                                  id: category.id,
                                  user: user,
                                ),
                              ),
                            );
                          },
                          icon: Icon(Icons.edit),
                        ),
                      if (user.role == "ADMIN")
                        IconButton(
                          onPressed: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (_) => NewCategoryForm(),
                            //   ),
                            // );
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => NewProductForm(
                                  id: category.id,
                                ),
                              ),
                            );
                          },
                          icon: Icon(Icons.add),
                        ),
                    ],
                  ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Future<void> dialog(BuildContext contexto, Category category) {
    return showDialog<void>(
      context: contexto,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("¿Estás seguro de querer eliminar la categoría?"),
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
                BlocProvider.of<CategoryBloc>(contexto)
                  ..add(RemoveCategory(category.id));
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
