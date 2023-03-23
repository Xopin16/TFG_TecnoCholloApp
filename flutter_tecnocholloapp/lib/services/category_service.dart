import 'package:flutter_tecnocholloapp/models/category.dart';
import 'package:flutter_tecnocholloapp/repositories/category_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import '../config/locator.dart';
import 'localstorage_service.dart';

@Order(2)
@singleton
class CategoryService {
  late CategoryRepository _categoryRepository;
  late LocalStorageService _localStorageService;

  CategoryService() {
    _categoryRepository = getIt<CategoryRepository>();
    GetIt.I
        .getAsync<LocalStorageService>()
        .then((value) => _localStorageService = value);
  }

  Future<CategoryResponse> getAllCategories(page) async {
    String? token = _localStorageService.getFromDisk("user_token");
    CategoryResponse categories = await _categoryRepository.getCategories(page);
    return categories;
  }

  Future<Category> newCategory(String nombre) async {
    Category response = await _categoryRepository.newCategory(nombre);
    return response;
  }

  Future<Category> editCategory(int id, String nombre) async {
    Category response = await _categoryRepository.editCategory(id, nombre);
    return response;
  }

  Future<void> deleteCategory(id) async {
    return _categoryRepository.deleteCategory(id);
  }
}
