import 'dart:convert';
import 'package:injectable/injectable.dart';
import '../config/locator.dart';
import '../models/carrito.dart';
import '../rest/rest_client.dart';

@Order(-1)
@singleton
class CarritoRepository {
  late RestAuthenticatedClient _client;

  CarritoRepository() {
    _client = getIt<RestAuthenticatedClient>();
  }

  Future<Carrito> showCart() async {
    String url = "/usuario/cesta/";
    var jsonResponse = await _client.get(url);
    var carrito = Carrito.fromJson(jsonDecode(jsonResponse));
    return carrito;
  }

  Future<Carrito> addToCart(int id) async {
    String url = "/usuario/cesta/producto/$id";
    var jsonResponse = await _client.post(url);
    return Carrito.fromJson(jsonDecode(jsonResponse));
  }

  void deleteProductCart(int id) async {
    String url = "/usuario/cesta/$id";
    await _client.delete(url);
  }
}
