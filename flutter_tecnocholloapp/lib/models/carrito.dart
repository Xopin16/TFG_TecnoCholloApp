import 'package:flutter_tecnocholloapp/models/product.dart';

class Carrito {
  int? id;
  List<Product>? productos;
  double? total;

  Carrito({this.id, this.productos, this.total});

  Carrito.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['productos'] != null) {
      productos = <Product>[];
      json['productos'].forEach((v) {
        productos!.add(new Product.fromJson(v));
      });
    }
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.productos != null) {
      data['productos'] = this.productos!.map((v) => v.toJson()).toList();
    }
    data['total'] = this.total;
    return data;
  }
}
