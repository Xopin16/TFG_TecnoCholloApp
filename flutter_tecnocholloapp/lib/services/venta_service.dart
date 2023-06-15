import 'package:injectable/injectable.dart';

import '../config/locator.dart';
import '../models/venta.dart';
import '../repositories/venta_repository.dart';

@Order(2)
@singleton
class VentaService {
  late VentaRepository _ventaRepository;

  VentaService() {
    _ventaRepository = getIt<VentaRepository>();
  }

  Future<List<dynamic>> getVentasUsuario() async {
    var ventas = await _ventaRepository.getVentasUsuario();
    return ventas;
  }

  Future<Venta> checkout() async {
    Venta venta = await _ventaRepository.checkout();
    return venta;
  }
}
