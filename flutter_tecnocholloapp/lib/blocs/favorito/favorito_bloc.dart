import 'package:bloc/bloc.dart';
import '../../services/product_service.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'favourite.dart';

var contador = 0;
const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class FavouriteBloc extends Bloc<FavouriteEvent, FavouriteState> {
  final ProductService _productService;

  FavouriteBloc(ProductService productService)
      : assert(productService != null),
        _productService = productService,
        super(const FavouriteState()) {
    on<FavouriteFetched>(
      _onFavouriteFetched,
      transformer: throttleDroppable(throttleDuration),
    );
    on<RemoveFavorite>(
      _onRemoveFavorite,
    );
  }

  Future<void> _onFavouriteFetched(
    FavouriteFetched event,
    Emitter<FavouriteState> emit,
  ) async {
    if (state.hasReachedMax) {
      return;
    }
    try {
      if (state.status == FavouriteStatus.initial) {
        contador = 0;
        final products = await _productService.getAllFavorite(contador);
        return emit(
          state.copyWith(
            status: FavouriteStatus.success,
            products: products.product,
            hasReachedMax: products.totalPages - 1 <= contador,
          ),
        );
      }
      contador++;
      final products = await _productService.getAllFavorite(contador);
      emit(state.copyWith(
        status: FavouriteStatus.success,
        products: List.of(state.products)..addAll(products.product),
        hasReachedMax: products.totalPages - 1 <= contador,
      ));
    } catch (_) {
      emit(state.copyWith(status: FavouriteStatus.failure));
    }
  }

  void _onRemoveFavorite(
    RemoveFavorite event,
    Emitter<FavouriteState> emit,
  ) async {
    try {
      await _productService.deleteFavorite(event.id);
      emit(state.copyWith(status: FavouriteStatus.deleted));
    } catch (_) {
      emit(state.copyWith(status: FavouriteStatus.failDeleted));
    }
  }
}
