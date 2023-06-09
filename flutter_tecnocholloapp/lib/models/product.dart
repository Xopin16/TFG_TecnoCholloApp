class ProductResponse {
  late final List<Product> product;
  late final int currentPage;
  late final int totalPages;
  late final int totalElements;
  late final bool last;

  ProductResponse(
      {required this.product,
      required this.currentPage,
      required this.totalPages,
      required this.totalElements,
      required this.last});

  ProductResponse.fromJson(Map<String, dynamic> json) {
    if (json['content'] != null) {
      product = <Product>[];
      json['content'].forEach((v) {
        product.add(new Product.fromJson(v));
      });
    }
    // currentPage = json['currentPage'];
    totalPages = json['totalPages'];
    totalElements = json['totalElements'];
    last = json['last'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.product != null) {
      data['product'] = this.product.map((v) => v.toJson()).toList();
    }
    data['currentPage'] = this.currentPage;
    data['totalPages'] = this.totalPages;
    data['totalElements'] = this.totalElements;
    return data;
  }
}

class Product {
  late final int id;
  late final String nombre;
  late final double precio;
  late final String descripcion;
  String? imagen;
  late final String categoria;
  late final String fechaPublicacion;
  late final int cantidad;
  late final inFav;

  Product(
      {required this.id,
      required this.nombre,
      required this.precio,
      required this.descripcion,
      this.imagen,
      required this.categoria,
      required this.fechaPublicacion,
      required this.cantidad,
      required this.inFav});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nombre = json['nombre'];
    // fechaPublicacion = json['fechaPublicacion'];
    precio = json['precio'];
    descripcion = json['descripcion'];
    imagen = json['imagen'];
    categoria = json['categoria'];
    cantidad = json['cantidad'];
    inFav = json['inFav'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nombre'] = this.nombre;
    data['precio'] = this.precio;
    data['descripcion'] = this.descripcion;
    data['imagen'] = this.imagen;
    data['categoria'] = this.categoria;
    data['fechaPublicacion'] = this.fechaPublicacion;
    data['cantidad'] = this.cantidad;
    data['inFav'] = this.inFav;
    return data;
  }
}
