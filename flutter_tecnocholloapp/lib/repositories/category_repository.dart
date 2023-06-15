import 'dart:convert';
import 'package:flutter_tecnocholloapp/models/createcategory.dart';
import 'package:injectable/injectable.dart';
import '../config/locator.dart';
import '../models/category.dart';
import '../rest/rest_client.dart';

@Order(-1)
@singleton
class CategoryRepository {
  late RestAuthenticatedClient _client;

  CategoryRepository() {
    _client = getIt<RestAuthenticatedClient>();
  }

  Future<CategoryResponse> getCategories(int page) async {
    // contador++;
    String url = "/categoria/?page=$page";
    var jsonResponse = await _client.get(url);
    var categories = CategoryResponse.fromJson(jsonDecode(jsonResponse));
    return categories;
  }

  Future<Category> editCategory(int id, String nombre) async {
    String url = "/admin/categoria/$id";
    var jsonResponse = await _client.put(url, CreateCategory(nombre: nombre));
    return Category.fromJson(jsonDecode(jsonResponse));
  }

  Future<Category> newCategory(String nombre) async {
    String url = "/admin/categoria/";
    var jsonResponse = await _client.post(url, CreateCategory(nombre: nombre));
    return Category.fromJson(jsonDecode(jsonResponse));
  }

  void deleteCategory(int id) async {
    String url = "/admin/categoria/$id";
    await _client.delete(url);
  }
}
