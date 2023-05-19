import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import '../config/locator.dart';
import '../models/venta.dart';
import '../repositories/venta_repository.dart';
import 'localstorage_service.dart';

@Order(2)
@singleton
class VentaService {
  late VentaRepository _ventaRepository;
  late LocalStorageService _localStorageService;

  VentaService() {
    _ventaRepository = getIt<VentaRepository>();
    GetIt.I
        .getAsync<LocalStorageService>()
        .then((value) => _localStorageService = value);
  }

  Future<Venta> checkout() async {
    Venta venta = await _ventaRepository.checkout();
    return venta;
  }
}
