import 'package:flutter_tecnocholloapp/models/models.dart';

class Venta {
  int? id;
  double? precio;
  List<Product>? products;
  String? fechaVenta;
  String? nombreUsuario;

  Venta(
      {this.id,
      this.precio,
      this.products,
      this.fechaVenta,
      this.nombreUsuario});

  Venta.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    precio = json['precio'];
    if (json['products'] != null) {
      products = <Product>[];
      json['products'].forEach((v) {
        products!.add(new Product.fromJson(v));
      });
    }
    fechaVenta = json['fechaVenta'];
    nombreUsuario = json['nombreUsuario'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['precio'] = this.precio;
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
    data['fechaVenta'] = this.fechaVenta;
    data['nombreUsuario'] = this.nombreUsuario;
    return data;
  }
}
