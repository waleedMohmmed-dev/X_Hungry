import 'package:hungry_app/core/network/api_service.dart';
import 'package:hungry_app/features/home/data/models/product_model.dart';
import 'package:hungry_app/features/home/data/models/toppings_model.dart';

class ProductRepo {
  ApiService _apiService = ApiService();

  ///Get Products
  Future<List<ProductModel>> getProducts() async {
    try {
      final response = await _apiService.get('/products/');

      return (response['data'] as List)
          .map((product) => ProductModel.fromJson(product))
          .toList();
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  /// Get Toppings
  Future<List<ToppingModel>> getToppings() async {
    try {
      final response = await _apiService.get('/toppings');
      return (response['data'] as List)
          .map((topping) => ToppingModel.fromJson(topping))
          .toList();
    } catch (e) {
      print(e.toString());
    }
    return [];
  }

  /// Get Options

  Future<List<ToppingModel>> getOptions() async {
    try {
      final response = await _apiService.get('/side-options');
      return (response['data'] as List)
          .map((option) => ToppingModel.fromJson(option))
          .toList();
    } catch (e) {
      print(e.toString());
    }
    return [];
  }

  /// Search
  Future<List<ProductModel>> serchProducts(String name) async {
    try {
      final response = await _apiService.get(
        '/products',
        params: {'name': name},
      );
      return (response['data'] as List)
          .map((product) => ProductModel.fromJson(product))
          .toList();
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  /// Category
}
