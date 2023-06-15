import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tecnocholloapp/ui/pages/delete_category_page.dart';
import '../../blocs/favorito/favourite.dart';
import '../../config/locator.dart';
import '../../models/user.dart';
import '../../services/product_service.dart';
import '../pages/no_products_page.dart';
import 'bottom_loader.dart';
import 'favourite_list_item.dart';

class FavouriteScreen extends StatelessWidget {
  final User user;

  const FavouriteScreen({super.key, required this.user});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FAVORITOS'),
        backgroundColor: Color.fromARGB(211, 244, 67, 54),
      ),
      body: BlocProvider(
        create: (context) {
          final productService = getIt<ProductService>();
          return FavouriteBloc(productService)..add(FavouriteFetched());
        },
        child: FavouriteList(
          user: this.user,
        ),
      ),
    );
  }
}

class FavouriteList extends StatefulWidget {
  final User user;
  const FavouriteList({super.key, required this.user});

  @override
  State<FavouriteList> createState() => _FavouriteListState();
}

class _FavouriteListState extends State<FavouriteList> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavouriteBloc, FavouriteState>(
      builder: (context, state) {
        switch (state.status) {
          case FavouriteStatus.failure:
            return const Center(child: Text('failed to fetch products'));
          // return const CircularProgressIndicator();
          case FavouriteStatus.success:
            if (state.products.isEmpty) {
              return NoProducts();
            }
            return ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return index >= state.products.length
                    ? const BottomLoader()
                    : FavouriteListItem(product: state.products[index]);
              },
              itemCount: state.hasReachedMax
                  ? state.products.length
                  : state.products.length + 1,
              controller: _scrollController,
            );
          case FavouriteStatus.initial:
            return const Center(child: CircularProgressIndicator());
          case FavouriteStatus.deleted:
            return DeletedCategoryPage(user: widget.user);
          case FavouriteStatus.failDeleted:
            return const Text("Fallo al eliminar favorito");
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
    if (_isBottom) context.read<FavouriteBloc>().add(FavouriteFetched());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
