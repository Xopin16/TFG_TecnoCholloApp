class CreateCategory {
  late final String nombre;

  CreateCategory({required this.nombre});

  CreateCategory.fromJson(Map<String, dynamic> json) {
    nombre = json['nombre'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nombre'] = this.nombre;
    return data;
  }
}
