import 'package:equatable/equatable.dart';
import '../../models/product.dart';

enum CategoryProductStatus { initial, success, failure }

class CategoryProductState extends Equatable {
  const CategoryProductState({
    this.status = CategoryProductStatus.initial,
    this.products = const <Product>[],
    this.hasReachedMax = false,
  });

  final CategoryProductStatus status;
  final List<Product> products;
  final bool hasReachedMax;

  CategoryProductState copyWith({
    CategoryProductStatus? status,
    List<Product>? products,
    bool? hasReachedMax,
  }) {
    return CategoryProductState(
      status: status ?? this.status,
      products: products ?? this.products,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  String toString() {
    return '''productState { status: $status, hasReachedMax: $hasReachedMax, products: ${products.length} }''';
  }

  @override
  List<Object> get props => [status, products, hasReachedMax];
}
