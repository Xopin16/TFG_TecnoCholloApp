import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tecnocholloapp/ui/widget/product_list_item.dart';
import '../../blocs/blocs.dart';
import 'bottom_loader.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        switch (state.status) {
          case ProductStatus.failure:
            return const Center(child: Text('failed to fetch products'));
          // return const CircularProgressIndicator();
          case ProductStatus.success:
            if (state.products.isEmpty) {
              return const Center(child: Text('no products'));
            }
            return Column(
              children: [
                Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 12)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        // Lógica para abrir el filtro
                      },
                      icon: Icon(Icons.filter_list),
                    ),
                    Expanded(
                      child: TextField(
                        onChanged: (value) {
                          // Lógica para buscar
                        },
                        decoration: InputDecoration(
                            hintText: 'Buscar...',
                            prefixIcon: Icon(Icons.search),
                            border: UnderlineInputBorder()),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      return index >= state.products.length
                          ? const BottomLoader()
                          : ProductListItem(product: state.products[index]);
                    },
                    itemCount: state.hasReachedMax
                        ? state.products.length
                        : state.products.length + 1,
                    controller: _scrollController,
                  ),
                ),
              ],
            );
          case ProductStatus.initial:
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
    if (_isBottom) context.read<ProductBloc>().add(ProductFetched());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
