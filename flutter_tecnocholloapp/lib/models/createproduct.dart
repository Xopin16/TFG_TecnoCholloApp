class CreateProduct {
  int? id;
  String? nombre;
  double? precio;
  String? descripcion;
  // String? categoria;
  // String? fechaPublicacion;

  CreateProduct({
    this.id,
    this.nombre,
    this.precio,
    this.descripcion,
    /*this.categoria,
      this.fechaPublicacion*/
  });

  CreateProduct.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nombre = json['nombre'];
    precio = json['precio'];
    descripcion = json['descripcion'];
    // categoria = json['categoria'];
    // fechaPublicacion = json['fechaPublicacion'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nombre'] = this.nombre;
    data['precio'] = this.precio;
    data['descripcion'] = this.descripcion;
    // data['categoria'] = this.categoria;
    // data['fechaPublicacion'] = this.fechaPublicacion;
    return data;
  }
}
