import 'package:equatable/equatable.dart';

import '../../models/product.dart';

enum FavouriteStatus { initial, success, failure, deleted, failDeleted }

class FavouriteState extends Equatable {
  const FavouriteState({
    this.status = FavouriteStatus.initial,
    this.products = const <Product>[],
    this.hasReachedMax = false,
  });

  final FavouriteStatus status;
  final List<Product> products;
  final bool hasReachedMax;

  FavouriteState copyWith({
    FavouriteStatus? status,
    List<Product>? products,
    bool? hasReachedMax,
  }) {
    return FavouriteState(
      status: status ?? this.status,
      products: products ?? this.products,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  String toString() {
    return '''FavouriteState { status: $status, hasReachedMax: $hasReachedMax, products: ${products.length} }''';
  }

  @override
  List<Object> get props => [status, products, hasReachedMax];
}
