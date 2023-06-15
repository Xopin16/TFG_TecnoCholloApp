import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/productUser/product_user_bloc.dart';
import '../../blocs/productUser/product_user_event.dart';
import '../../config/locator.dart';
import '../../services/product_service.dart';
import '../widget/product_user_list.dart';
import 'home_page.dart';

class ProductUserPage extends StatelessWidget {
  final HomePage homePage;
  ProductUserPage({super.key, required this.homePage});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return BlocProvider(
          create: (context) {
            final productService = getIt<ProductService>();
            return ProductUserBloc(productService)..add(ProductUserFetched());
          },
          child: ProductUserList(
            user: homePage.user,
          ),
        );
      },
    );
  }
}
