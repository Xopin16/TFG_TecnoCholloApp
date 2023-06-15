import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/category/category.dart';
import '../../models/user.dart';
import '../pages/no_products_page.dart';
import '../pages/pages.dart';
import 'bottom_loader.dart';
import 'category_list_item.dart';

class CategoryList extends StatefulWidget {
  const CategoryList({super.key, required this.user});
  final User user;

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        switch (state.status) {
          case CategoryStatus.failure:
            return const Center(child: Text('failed to fetch categories'));
          // return const CircularProgressIndicator();
          case CategoryStatus.success:
            if (state.categories.isEmpty) {
              return NoProducts();
            }
            return ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return index >= state.categories.length
                    ? const BottomLoader()
                    : CategoryListItem(
                        category: state.categories[index],
                        user: widget.user,
                      );
              },
              itemCount: state.hasReachedMax
                  ? state.categories.length
                  : state.categories.length + 1,
              controller: _scrollController,
            );
          case CategoryStatus.initial:
            return const Center(child: CircularProgressIndicator());
          case CategoryStatus.deleted:
            return DeletedCategoryPage(user: widget.user);
          case CategoryStatus.failDeleted:
            return Text("Fallo al borrar");
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
