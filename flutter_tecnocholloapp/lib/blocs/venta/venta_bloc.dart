import 'package:bloc/bloc.dart';
import 'package:flutter_tecnocholloapp/blocs/venta/venta_event.dart';
import 'package:flutter_tecnocholloapp/blocs/venta/venta_state.dart';
import 'package:flutter_tecnocholloapp/services/venta_service.dart';

class VentaBloc extends Bloc<VentaEvent, VentaState> {
  final VentaService _ventaService;

  VentaBloc(VentaService ventaService)
      : assert(ventaService != null),
        _ventaService = ventaService,
        super(const VentaState()) {
    on<VentaFetched>(
      _onVentaFetched,
    );
  }

  Future<void> _onVentaFetched(
    VentaFetched event,
    Emitter<VentaState> emit,
  ) async {
    try {
      if (state.status == VentaStatus.initial) {
        var ventas = await _ventaService.getVentasUsuario();
        return emit(
          state.copyWith(status: VentaStatus.success, ventas: ventas),
        );
      }
    } catch (_) {
      emit(state.copyWith(status: VentaStatus.failure, ventas: []));
    }
  }
}
