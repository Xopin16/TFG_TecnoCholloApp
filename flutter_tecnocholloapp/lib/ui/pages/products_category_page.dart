import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/categoryProducts/category_products_bloc.dart';
import '../../blocs/categoryProducts/category_products_event.dart';
import '../../config/locator.dart';
import '../../services/product_service.dart';
import '../widget/category_products_list.dart';

class CategoryProductPage extends StatelessWidget {
  const CategoryProductPage({required this.id, super.key});
  final int id;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final productService = getIt<ProductService>();
        return CategoryProductBloc(productService, id)
          ..add(CategoryProductFetched());
      },
      child: const CategoryProductList(),
    );
  }
}
