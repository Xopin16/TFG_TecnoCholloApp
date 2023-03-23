import 'package:flutter_tecnocholloapp/config/locator.dart';
import 'package:flutter_tecnocholloapp/repositories/product_repository.dart';
import 'package:flutter_tecnocholloapp/services/localstorage_service.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_tecnocholloapp/models/models.dart';
import 'package:flutter_tecnocholloapp/repositories/repositories.dart';
import '../models/product.dart';

@Order(2)
@singleton
class ProductService {
  late ProductRepository _productRepository;
  late LocalStorageService _localStorageService;

  ProductService() {
    _productRepository = getIt<ProductRepository>();
    GetIt.I
        .getAsync<LocalStorageService>()
        .then((value) => _localStorageService = value);
  }

  Future<ProductResponse> getAllProducts(page) async {
    String? token = _localStorageService.getFromDisk("user_token");
    ProductResponse products = await _productRepository.getProducts(page);
    return products;
  }

  Future<ProductResponse> getAllCategoryProducts(id, page) async {
    String? token = _localStorageService.getFromDisk("user_token");
    ProductResponse products =
        await _productRepository.getProductsCategory(id, page);
    return products;
  }

  Future<ProductResponse> getAllFavorite(page) async {
    String? token = _localStorageService.getFromDisk("user_token");
    ProductResponse products = await _productRepository.getFavourite(page);
    return products;
  }

  Future<Product> getDetail(int id) async {
    String? token = _localStorageService.getFromDisk("user_token");
    Product product = await _productRepository.getDetails(id);
    return product;
  }

  Future<ProductResponse> getAllProductsUser(page) async {
    String? token = _localStorageService.getFromDisk("user_token");
    ProductResponse products = await _productRepository.getProductsUser(page);
    return products;
  }

  Future<Product> addFavourite(id) async {
    String? token = _localStorageService.getFromDisk("user_token");
    Product response = await _productRepository.addFavourite(id);
    return response;
  }

  Future<Product> newProduct(
      int idCategoria, String nombre, double precio, String descripcion) async {
    Product response = await _productRepository.newProduct(
        idCategoria, nombre, precio, descripcion);
    return response;
  }

  Future<ProductResponse> editProduct(
      int id, String nombre, double precio, String descripcion) async {
    ProductResponse response =
        await _productRepository.editProduct(id, nombre, precio, descripcion);
    return response;
  }

  Future<void> deteleProduct(id) async {
    return _productRepository.deleteProduct(id);
  }
}
