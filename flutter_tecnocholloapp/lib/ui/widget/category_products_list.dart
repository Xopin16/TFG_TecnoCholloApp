import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tecnocholloapp/blocs/categoryProducts/category_products_bloc.dart';
import 'package:flutter_tecnocholloapp/blocs/categoryProducts/category_products_event.dart';
import '../../blocs/categoryProducts/category_products_state.dart';
import '../pages/no_products_page.dart';
import 'bottom_loader.dart';
import 'category_product_item.dart';

class CategoryProductList extends StatefulWidget {
  const CategoryProductList({super.key});

  @override
  State<CategoryProductList> createState() => _CategoryProductListState();
}

class _CategoryProductListState extends State<CategoryProductList> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CATEGORÍAS'),
        backgroundColor: Color.fromARGB(211, 244, 67, 54),
      ),
      body: BlocBuilder<CategoryProductBloc, CategoryProductState>(
        builder: (context, state) {
          switch (state.status) {
            case CategoryProductStatus.failure:
              return const Center(child: Text('failed to fetch products'));
            // return const CircularProgressIndicator();
            case CategoryProductStatus.success:
              if (state.products.isEmpty) {
                return NoProducts();
              }
              return ConstrainedBox(
                constraints: BoxConstraints(
                    minHeight: 0,
                    maxHeight: MediaQuery.of(context).size.height),
                child: ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    return index >= state.products.length
                        ? const BottomLoader()
                        : CategoryProductItem(product: state.products[index]);
                  },
                  itemCount: state.hasReachedMax
                      ? state.products.length
                      : state.products.length + 1,
                  controller: _scrollController,
                ),
              );
            case CategoryProductStatus.initial:
              return const Center(child: CircularProgressIndicator());
          }
        },
      ),
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
    if (_isBottom)
      context.read<CategoryProductBloc>().add(CategoryProductFetched());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
