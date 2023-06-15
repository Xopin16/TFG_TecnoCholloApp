import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/blocs.dart';
import '../pages/no_products_page.dart';
import 'detail_list_item.dart';

class DetailsList extends StatefulWidget {
  const DetailsList({super.key});

  @override
  State<DetailsList> createState() => _DetailsListState();
}

class _DetailsListState extends State<DetailsList> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailsBloc, DetailState>(
      builder: (context, state) {
        switch (state.status) {
          case DetailStatus.failure:
            return const Center(
                child: Text('failed to fetch details of product'));
          case DetailStatus.success:
            if (state.details.toString().isEmpty) {
              return NoProducts();
            }
            return DetailsListItem(details: state.details!);
          case DetailStatus.initial:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
