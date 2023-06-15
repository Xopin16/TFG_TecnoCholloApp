import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_tecnocholloapp/blocs/carrito/carrito_event.dart';
import 'package:flutter_tecnocholloapp/services/carrito_service.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../services/venta_service.dart';
import 'carrito_state.dart';

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class CarritoBloc extends Bloc<CarritoEvent, CarritoState> {
  final CarritoService _carritoService;
  final VentaService _ventaService;
  CarritoBloc(CarritoService carritoService, VentaService ventaService)
      : // : assert(carritoService != null && ventaService != null),
        _carritoService = carritoService,
        _ventaService = ventaService,
        super(const CarritoState()) {
    on<CarritoFetched>(
      _onCarritoFetched,
    );
    on<RemoveCarrito>(
      _onRemoveCarrito,
    );

    on<CarritoSold>(
      _onCarritoSold,
    );
  }

  Future<void> _onCarritoFetched(
    CarritoFetched event,
    Emitter<CarritoState> emit,
  ) async {
    if (state.props.isEmpty) return;
    try {
      final carrito = await _carritoService.getCarrito();
      return emit(
          state.copyWith(carrito: carrito, status: CarritoStatus.success));
    } catch (_) {
      emit(state.copyWith(status: CarritoStatus.failure));
    }
  }

  void _onRemoveCarrito(
    RemoveCarrito event,
    Emitter<CarritoState> emit,
  ) async {
    try {
      await _carritoService.deleteProductCart(event.id);
      emit(state.copyWith(status: CarritoStatus.deleted));
    } catch (_) {
      emit(state.copyWith(status: CarritoStatus.failDeleted));
    }
  }

  Future<void> _onCarritoSold(
    CarritoSold event,
    Emitter<CarritoState> emit,
  ) async {
    try {
      await _ventaService.checkout();
      emit(state.copyWith(status: CarritoStatus.sold));
    } catch (_) {
      emit(state.copyWith(status: CarritoStatus.failure));
    }
  }
}
