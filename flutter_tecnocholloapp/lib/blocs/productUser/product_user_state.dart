import 'package:equatable/equatable.dart';

import '../../models/product.dart';

enum ProductUserStatus {
  initial,
  success,
  failure,
  deleted,
  failDeteled,
}

class ProductUserState extends Equatable {
  const ProductUserState({
    this.status = ProductUserStatus.initial,
    this.products = const <Product>[],
    this.hasReachedMax = false,
  });

  final ProductUserStatus status;
  final List<Product> products;
  final bool hasReachedMax;

  ProductUserState copyWith({
    ProductUserStatus? status,
    List<Product>? products,
    bool? hasReachedMax,
  }) {
    return ProductUserState(
      status: status ?? this.status,
      products: products ?? this.products,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  String toString() {
    return '''ProductUserState { status: $status, hasReachedMax: $hasReachedMax, products: ${products.length} }''';
  }

  @override
  List<Object> get props => [status, products, hasReachedMax];
}
