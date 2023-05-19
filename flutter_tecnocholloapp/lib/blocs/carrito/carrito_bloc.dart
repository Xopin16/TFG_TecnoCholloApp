import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_tecnocholloapp/blocs/carrito/carrito_event.dart';
import 'package:flutter_tecnocholloapp/services/carrito_service.dart';
import 'package:stream_transform/stream_transform.dart';

import 'carrito_state.dart';

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class CarritoBloc extends Bloc<CarritoEvent, CarritoState> {
  final CarritoService _carritoService;
  CarritoBloc(CarritoService carritoService)
      : assert(carritoService != null),
        _carritoService = carritoService,
        super(const CarritoState()) {
    on<CarritoFetched>(
      _onCarritoFetched,
    );
  }

  Future<void> _onCarritoFetched(
    CarritoFetched event,
    Emitter<CarritoState> emit,
  ) async {
    if (state.props.isEmpty) return;
    try {
      if (state.status == CarritoStatus.initial) {
        final carrito = await _carritoService.getCarrito();
        return emit(
            state.copyWith(carrito: carrito, status: CarritoStatus.success));
      }
    } catch (_) {
      emit(state.copyWith(status: CarritoStatus.failure));
    }
  }
}
