import 'package:flutter_tecnocholloapp/models/product.dart';

class Carrito {
  int? id;
  int? precio;
  List<Product>? productos;
  String? fechaVenta;
  String? nombreUsuario;

  Carrito(
      {this.id,
      this.precio,
      this.productos,
      this.fechaVenta,
      this.nombreUsuario});

  Carrito.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    precio = json['precio'];
    if (json['productos'] != null) {
      productos = <Product>[];
      json['productos'].forEach((v) {
        productos!.add(new Product.fromJson(v));
      });
    }
    fechaVenta = json['fechaVenta'];
    nombreUsuario = json['nombreUsuario'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['precio'] = this.precio;
    if (this.productos != null) {
      data['productos'] = this.productos!.map((v) => v.toJson()).toList();
    }
    data['fechaVenta'] = this.fechaVenta;
    data['nombreUsuario'] = this.nombreUsuario;
    return data;
  }
}
