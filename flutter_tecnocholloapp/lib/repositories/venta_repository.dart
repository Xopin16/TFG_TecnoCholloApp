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

  Future<Venta> checkout() async {
    String url = "/usuario/checkout/";
    var jsonResponse = await _client.get(url);
    var venta = Venta.fromJson(jsonDecode(jsonResponse));
    return venta;
  }
}
