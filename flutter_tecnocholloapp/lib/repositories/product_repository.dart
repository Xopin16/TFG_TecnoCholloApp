import 'dart:convert';
import 'package:file_picker/file_picker.dart';
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

  Future<ProductResponse> getProducts(int page, [String? nombre]) async {
    if (nombre == null) {
      nombre = "";
    }
    String url = "/producto/?s=sent:false,nombre:$nombre&page=$page";
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
      CreateProduct body, PlatformFile file, String token) async {
    String url = "/product";
    var jsonResponse = await _client.postMultiPart(url, body, file, token);
    return Product.fromJson(jsonDecode(jsonResponse));
  }

  Future<Product> editProduct(
      /*int id, String nombre, double precio, String descripcion*/
      int id,
      CreateProduct body,
      PlatformFile file,
      String token) async {
    String url = "/usuario/product/$id";
    var jsonResponse = await _client.putMultiPart(url, body, file, token);
    // CreateProduct(
    //     /*id: id, */
    //     nombre: nombre,
    //     precio: precio,
    //     descripcion: descripcion));
    return Product.fromJson(jsonDecode(jsonResponse));
  }

  void deleteProduct(int id) async {
    String url = "/usuario/producto/$id";
    await _client.delete(url);
  }

  void deleteFavorite(int id) async {
    String url = "/usuario/favorito/$id";
    await _client.delete(url);
  }
}
