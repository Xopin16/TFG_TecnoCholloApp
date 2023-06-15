import 'package:bloc/bloc.dart';
import '../../services/product_service.dart';
import '../productUser/product_user.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';

var contador = 0;
const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class ProductUserBloc extends Bloc<ProductUserEvent, ProductUserState> {
  final ProductService _productService;
  // final int id;
  ProductUserBloc(ProductService productService)
      : assert(productService != null),
        _productService = productService,
        super(const ProductUserState()) {
    on<ProductUserFetched>(
      _onProductUserFetched,
      transformer: throttleDroppable(throttleDuration),
    );
    on<RemoveProduct>(
      _onRemoveProduct,
    );
    // on<EditProduct>(
    //   _onEditProduct,
    // );
  }

  Future<void> _onProductUserFetched(
    ProductUserFetched event,
    Emitter<ProductUserState> emit,
  ) async {
    if (state.hasReachedMax) return;
    try {
      if (state.status == ProductUserStatus.initial) {
        contador = 0;
        final products = await _productService.getAllProductsUser(contador);
        return emit(
          state.copyWith(
            status: ProductUserStatus.success,
            products: products.product,
            hasReachedMax: products.totalPages - 1 <= contador,
          ),
        );
      }
      contador++;
      final products = await _productService.getAllProductsUser(contador);
      emit(
        state.copyWith(
          status: ProductUserStatus.success,
          products: List.of(state.products)..addAll(products.product),
          hasReachedMax: products.totalPages - 1 <= contador,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: ProductUserStatus.failure));
    }
  }

  void _onRemoveProduct(
    RemoveProduct event,
    Emitter<ProductUserState> emit,
  ) async {
    try {
      await _productService.deteleProduct(event.id);
      emit(state.copyWith(status: ProductUserStatus.deleted));
    } catch (_) {
      emit(state.copyWith(status: ProductUserStatus.failDeteled));
    }
  }

  // Future<void> _onEditProduct(
  //   EditProduct event,
  //   Emitter<ProductUserState> emit,
  // ) async {
  //   try {
  //     await _productService.editProduct(
  //         event.id, event.nombre, event.precio, event.descripcion);
  //     emit(state.copyWith(status: ProductUserStatus.edited));
  //   } catch (_) {
  //     emit(state.copyWith(status: ProductUserStatus.failEdited));
  //   }
  // }
}
