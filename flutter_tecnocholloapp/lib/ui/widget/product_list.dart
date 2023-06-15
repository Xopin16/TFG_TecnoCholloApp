import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tecnocholloapp/ui/pages/home_page.dart';
import 'package:flutter_tecnocholloapp/ui/pages/no_products_page.dart';
import 'package:flutter_tecnocholloapp/ui/pages/product_user_page.dart';
import 'package:flutter_tecnocholloapp/ui/widget/favourite_list.dart';
import 'package:flutter_tecnocholloapp/ui/widget/product_list_item.dart';
import '../../blocs/blocs.dart';
import '../pages/new_product_page.dart';
import 'bottom_loader.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key, required this.homePage});
  final HomePage homePage;

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  final _scrollController = ScrollController();
  int id = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  final TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 12)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PopupMenuButton<int>(
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem<int>(
                      value: 2,
                      child: Row(
                        children: [
                          Icon(Icons.local_mall),
                          SizedBox(width: 8),
                          Text('Mis chollos'),
                        ],
                      ),
                    ),
                    PopupMenuItem<int>(
                      value: 0,
                      child: Row(
                        children: [
                          Icon(Icons.favorite),
                          SizedBox(width: 8),
                          Text('Mostrar favoritos'),
                        ],
                      ),
                    ),
                    PopupMenuItem<int>(
                      value: 1,
                      child: Row(
                        children: [
                          Icon(Icons.add),
                          SizedBox(width: 8),
                          Text('Agregar producto'),
                        ],
                      ),
                    ),
                  ];
                },
                onSelected: (value) {
                  if (value == 0) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => FavouriteScreen(
                                user: widget.homePage.user,
                              )),
                    );
                  } else if (value == 1) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => NewProductForm(
                          id: id,
                        ),
                      ),
                    );
                  } else if (value == 2) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                ProductUserPage(homePage: widget.homePage)));
                  }
                },
                icon: Icon(Icons.menu),
              ),
              Expanded(
                child: TextField(
                  controller: textEditingController,
                  onChanged: (value) {
                    context
                        .read<ProductBloc>()
                        .add(ProductFiltered(textEditingController.text));
                  },
                  decoration: InputDecoration(
                    hintText: 'Buscar...',
                    prefixIcon: Icon(Icons.search),
                    border: UnderlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                switch (state.status) {
                  case ProductStatus.failure:
                    return NoProducts();
                  // return const CircularProgressIndicator();
                  case ProductStatus.success:
                    if (state.products.isEmpty) {
                      return const Center(child: Text('no products'));
                    }
                    return ListView.builder(
                      itemBuilder: (BuildContext context, int index) {
                        return index >= state.products.length
                            ? const BottomLoader()
                            : ProductListItem(product: state.products[index]);
                      },
                      itemCount: state.hasReachedMax
                          ? state.products.length
                          : state.products.length + 1,
                      controller: _scrollController,
                    );
                  case ProductStatus.initial:
                    return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
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
    if (_isBottom) context.read<ProductBloc>().add(ProductFetched());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
