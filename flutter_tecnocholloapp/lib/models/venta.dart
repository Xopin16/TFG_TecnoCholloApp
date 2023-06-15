import 'package:flutter_tecnocholloapp/models/product.dart';

class Venta {
  int? id;
  double? precio;
  List<LineaVenta>? lineasVenta = [];
  String? fechaVenta;

  Venta({this.id, this.precio, this.lineasVenta, this.fechaVenta});

  Venta.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    precio = json['precio'];
    if (json['lineasVenta'] != null) {
      json['lineasVenta'].forEach((v) {
        lineasVenta!.add(new LineaVenta.fromJson(v));
      });
    }
    fechaVenta = json['fechaVenta'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['precio'] = this.precio;
    if (this.lineasVenta != null) {
      data['lineasVenta'] = this.lineasVenta!.map((v) => v.toJson()).toList();
    }
    data['fechaVenta'] = this.fechaVenta;
    return data;
  }
}

class LineaVenta {
  int? id;
  int? cantidad;
  Product? producto;

  LineaVenta({this.id, this.cantidad, this.producto});

  LineaVenta.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cantidad = json['cantidad'];
    producto = json['producto'] != null
        ? new Product.fromJson(json['producto'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['cantidad'] = this.cantidad;
    if (this.producto != null) {
      data['producto'] = this.producto!.toJson();
    }
    return data;
  }
}
