class CategoryResponse {
  late final List<Category> category;
  late final int currentPage;
  late final bool last;
  late final bool first;
  late final int totalPages;
  late final int totalElements;

  CategoryResponse(
      {required this.category,
      required this.currentPage,
      required this.last,
      required this.first,
      required this.totalPages,
      required this.totalElements});

  CategoryResponse.fromJson(Map<String, dynamic> json) {
    if (json['content'] != null) {
      category = <Category>[];
      json['content'].forEach((v) {
        category.add(new Category.fromJson(v));
      });
    }
    currentPage = json['currentPage'];
    last = json['last'];
    first = json['first'];
    totalPages = json['totalPages'];
    totalElements = json['totalElements'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.category != null) {
      data['content'] = this.category.map((v) => v.toJson()).toList();
    }
    data['currentPage'] = this.currentPage;
    data['last'] = this.last;
    data['first'] = this.first;
    data['totalPages'] = this.totalPages;
    data['totalElements'] = this.totalElements;
    return data;
  }
}

class Category {
  late final int id;
  late final String nombre;

  Category({required this.id, required this.nombre});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nombre = json['nombre'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nombre'] = this.nombre;
    return data;
  }
}
