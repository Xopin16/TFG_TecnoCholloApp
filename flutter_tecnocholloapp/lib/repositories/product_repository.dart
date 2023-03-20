import 'dart:convert';
import 'package:flutter_tecnocholloapp/config/locator.dart';
import 'package:flutter_tecnocholloapp/models/createproduct.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_tecnocholloapp/rest/rest.dart';
import '../models/product.dart';

@Order(-1)
@singleton
class ProductRepository {
  late RestAuthenticatedClient _client;
  // late LocalStorageService _localStorageService;

  ProductRepository() {
    _client = getIt<RestAuthenticatedClient>();
  }

  Future<ProductResponse> getProducts(int page) async {
    String url = "/producto/?page=$page";
    var jsonResponse = await _client.get(url);
    var products = ProductResponse.fromJson(jsonDecode(jsonResponse));
    return products;
  }

  Future<ProductResponse> getProductsCategory(int id, int page) async {
    String url = "/categoria/producto/$id?page=$page";
    var jsonResponse = await _client.get(url);
    var products = ProductResponse.fromJson(jsonDecode(jsonResponse));
    return products;
  }

  Future<ProductResponse> getFavourite(int page) async {
    String url = "/usuario/favorito/";
    var jsonResponse = await _client.get(url);
    var products = ProductResponse.fromJson(jsonDecode(jsonResponse));
    return products;
  }

  Future<Product> getDetails(int id) async {
    String url = "/producto/$id";
    var jsonResponse = await _client.get(url);
    return Product.fromJson(jsonDecode(jsonResponse));
  }

  Future<ProductResponse> getProductsUser(int page) async {
    String url = "/usuario/producto/?page=$page";
    var jsonResponse = await _client.get(url);
    var products = ProductResponse.fromJson(jsonDecode(jsonResponse));
    return products;
  }

  Future<Product> addFavourite(int id) async {
    String url = "/usuario/producto/$id";
    var jsonResponse = await _client.post(url);
    return Product.fromJson(jsonDecode(jsonResponse));
  }

  Future<Product> newProduct(
      int idCategoria, String nombre, double precio, String descripcion) async {
    String url = "/usuario/producto/nuevo/$idCategoria";
    var jsonResponse = await _client.post(
        url,
        CreateProduct(
            nombre: nombre, precio: precio, descripcion: descripcion));
    return Product.fromJson(jsonDecode(jsonResponse));
  }

  Future<ProductResponse> editProduct(
      int id, String nombre, double precio, String descripcion) async {
    String url = "/producto/$id";
    var jsonResponse = await _client.put(
        url,
        CreateProduct(
            nombre: nombre, precio: precio, descripcion: descripcion));
    return ProductResponse.fromJson(jsonDecode(jsonResponse));
  }

  void deleteProduct(int id) async {
    String url = "/producto/$id";
    await _client.delete(url);
  }
}
