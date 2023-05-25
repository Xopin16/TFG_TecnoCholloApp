import 'dart:convert';

import 'package:injectable/injectable.dart';

import '../config/locator.dart';
import '../models/venta.dart';
import '../rest/rest_client.dart';

@Order(-1)
@singleton
class VentaRepository {
  late RestAuthenticatedClient _client;
  VentaRepository() {
    _client = getIt<RestAuthenticatedClient>();
  }

  Future<List<Venta>> getVentasUsuario() async {
    String url = "/usuario/historico/";
    var jsonResponse = await _client.get(url);
    var ventasData = jsonDecode(jsonResponse) as List<dynamic>;

    List<Venta> ventas =
        ventasData.map((data) => Venta.fromJson(data)).toList();
    return ventas;
  }

  Future<Venta> checkout() async {
    String url = "/usuario/checkout/";
    var jsonResponse = await _client.post(url);
    var venta = Venta.fromJson(jsonDecode(jsonResponse));
    return venta;
  }
}
