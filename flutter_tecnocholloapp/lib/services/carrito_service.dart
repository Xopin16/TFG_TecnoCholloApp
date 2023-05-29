import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import '../config/locator.dart';
import '../models/venta.dart';
import '../repositories/carrito_repository.dart';
import 'localstorage_service.dart';

@Order(2)
@singleton
class CarritoService {
  late CarritoRepository _carritoRepository;
  late LocalStorageService _localStorageService;

  CarritoService() {
    _carritoRepository = getIt<CarritoRepository>();
    GetIt.I
        .getAsync<LocalStorageService>()
        .then((value) => _localStorageService = value);
  }

  Future<Venta> getCarrito() async {
    String? token = _localStorageService.getFromDisk("user_token");
    Venta carrito = await _carritoRepository.showCart();
    return carrito;
  }

  Future<Venta> addProductToCart(int id) async {
    Venta carrito = await _carritoRepository.addToCart(id);
    return carrito;
  }

  Future<void> deleteProductCart(id) async {
    return _carritoRepository.deleteProductCart(id);
  }
}
