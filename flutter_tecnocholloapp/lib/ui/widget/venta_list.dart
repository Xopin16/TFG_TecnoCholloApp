import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tecnocholloapp/blocs/venta/venta_bloc.dart';
import 'package:flutter_tecnocholloapp/blocs/venta/venta_state.dart';
import 'package:flutter_tecnocholloapp/ui/pages/no_ventas_page.dart';
import 'package:flutter_tecnocholloapp/ui/widget/venta_list_item.dart';
import '../../blocs/category/category.dart';

class VentaList extends StatefulWidget {
  const VentaList({super.key});

  @override
  State<VentaList> createState() => _VentaListState();
}

class _VentaListState extends State<VentaList> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VentaBloc, VentaState>(
      builder: (context, state) {
        switch (state.status) {
          case VentaStatus.failure:
            return const Center(child: Text('failed to fetch ventas'));
          // return const CircularProgressIndicator();
          case VentaStatus.success:
            if (state.ventas.isEmpty) {
              return NoVentas();
            }
            return ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return index >= state.ventas.length
                    ? Text("")
                    : VentaListItem(
                        venta: state.ventas[index],
                      );
              },
            );
          case VentaStatus.initial:
            return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) context.read<CategoryBloc>().add(CategoryFetched());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
