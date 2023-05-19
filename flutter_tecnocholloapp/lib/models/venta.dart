import 'package:flutter_tecnocholloapp/models/models.dart';

class Venta {
  int? id;
  int? precio;
  List<Product>? product;
  String? fechaVenta;
  String? nombreUsuario;

  Venta(
      {this.id,
      this.precio,
      this.product,
      this.fechaVenta,
      this.nombreUsuario});

  Venta.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    precio = json['precio'];
    if (json['product'] != null) {
      product = <Product>[];
      json['productDtos'].forEach((v) {
        product!.add(new Product.fromJson(v));
      });
    }
    fechaVenta = json['fechaVenta'];
    nombreUsuario = json['nombreUsuario'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['precio'] = this.precio;
    if (this.product != null) {
      data['product'] = this.product!.map((v) => v.toJson()).toList();
    }
    data['fechaVenta'] = this.fechaVenta;
    data['nombreUsuario'] = this.nombreUsuario;
    return data;
  }
}
