import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/details/detail_bloc.dart';
import '../../blocs/details/detail_event.dart';
import '../../config/locator.dart';
import '../../services/product_service.dart';
import '../widget/widget.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({required this.id, super.key});
  final int id;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final productService = getIt<ProductService>();
        return DetailsBloc(productService)..add(DetailFetched(id));
      },
      child: const DetailsList(),
    );
  }
}
