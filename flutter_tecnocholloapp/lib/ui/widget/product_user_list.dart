import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/productUser/product_user.dart';
import '../../models/models.dart';
import '../pages/no_products_page.dart';
import '../pages/pages.dart';
import 'widget.dart';

class ProductUserList extends StatefulWidget {
  ProductUserList({super.key, required this.user});
  final User user;

  @override
  State<ProductUserList> createState() => _ProductUserListState();
}

class _ProductUserListState extends State<ProductUserList> {
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
        title: Text("MIS PRODUCTOS"),
        backgroundColor: Color.fromARGB(211, 244, 67, 54),
      ),
      body: BlocBuilder<ProductUserBloc, ProductUserState>(
          builder: (context, state) {
        switch (state.status) {
          case ProductUserStatus.failure:
            return const Center(child: Text('failed to fetch products'));
          // return const CircularProgressIndicator();
          case ProductUserStatus.success:
            if (state.products.isEmpty) {
              return NoProducts();
            }
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  return index >= state.products.length
                      ? Text("")
                      : ProductUserListItem(
                          product: state.products[index],
                          user: widget.user,
                        );
                },
                itemCount: state.hasReachedMax
                    ? state.products.length
                    : state.products.length + 1,
                controller: _scrollController,
              ),
            );
          case ProductUserStatus.initial:
            return const Center(child: CircularProgressIndicator());

          case ProductUserStatus.deleted:
            return DeletedProductPage(
              user: widget.user,
            );

          case ProductUserStatus.failDeteled:
            return Text("Fallo al borrar");

          // case ProductUserStatus.edited:
          //   return const EditProductPage()
          // case ProductUserStatus.failEdited:
          //   return Text("Fallo al editar");
        }
      }),
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
    if (_isBottom) context.read<ProductUserBloc>().add(ProductUserFetched());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
