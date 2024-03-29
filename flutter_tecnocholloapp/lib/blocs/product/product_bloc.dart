import 'package:bloc/bloc.dart';
import '../../services/product_service.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import '../product/product.dart';

var contador = 0;
const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductService _productService;
  // final TextEditingController textEditingController;

  ProductBloc(ProductService productService)
      : assert(productService != null),
        _productService = productService,
        super(const ProductState()) {
    on<ProductFetched>(
      _onProductFetched,
      transformer: throttleDroppable(throttleDuration),
    );
    on<ProductFiltered>(
      (event, emit) async {
        await _onProductFiltered(event, emit, event.nombre);
      },
    );
  }

  Future<void> _onProductFetched(
    ProductFetched event,
    Emitter<ProductState> emit,
  ) async {
    if (state.hasReachedMax) {
      return;
    }
    try {
      if (state.status == ProductStatus.initial) {
        contador = 0;
        final products = await _productService.getAllProducts(contador);
        return emit(
          state.copyWith(
            status: ProductStatus.success,
            products: products.product,
            hasReachedMax: products.totalPages - 1 <= contador,
          ),
        );
      }
      contador++;
      final products = await _productService.getAllProducts(contador);
      emit(state.copyWith(
        status: ProductStatus.success,
        products: List.of(state.products)..addAll(products.product),
        hasReachedMax: products.totalPages - 1 <= contador,
      ));
    } catch (_) {
      emit(state.copyWith(status: ProductStatus.failure));
    }
  }

  Future<void> _onProductFiltered(
      ProductFiltered event, Emitter<ProductState> emit, String nombre) async {
    try {
      final products = await _productService.getAllProducts(0, nombre);
      emit(state.copyWith(
        status: ProductStatus.success,
        products: products.product,
        // hasReachedMax: products.totalPages - 1 <= contador,
      ));
    } catch (_) {
      emit(state.copyWith(status: ProductStatus.failure));
    }
  }
}
