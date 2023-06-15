import 'package:bloc/bloc.dart';
import '../../services/product_service.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import '../categoryProducts/category_products.dart';

var counter = 0;
const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throtleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class CategoryProductBloc
    extends Bloc<CategoryProductEvent, CategoryProductState> {
  final ProductService _productService;
  final int id;
  CategoryProductBloc(ProductService productService, this.id)
      : assert(productService != null),
        _productService = productService,
        super(const CategoryProductState()) {
    on<CategoryProductFetched>(
      _onCategoryProductFetched,
      transformer: throtleDroppable(throttleDuration),
    );
  }

  Future<void> _onCategoryProductFetched(
    CategoryProductFetched event,
    Emitter<CategoryProductState> emit,
  ) async {
    if (state.hasReachedMax) return;
    // counter = 1;
    try {
      if (state.status == CategoryProductStatus.initial) {
        counter = 0;
        final products =
            await _productService.getAllCategoryProducts(id, counter);
        return emit(
          state.copyWith(
            status: CategoryProductStatus.success,
            products: products.product,
            hasReachedMax: products.totalPages - 1 <= counter,
          ),
        );
      }
      counter++;
      final products =
          await _productService.getAllCategoryProducts(id, counter);
      emit(
        state.copyWith(
          status: CategoryProductStatus.success,
          products: List.of(state.products)..addAll(products.product),
          hasReachedMax: products.totalPages - 1 <= counter,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: CategoryProductStatus.failure));
    }
  }
}
