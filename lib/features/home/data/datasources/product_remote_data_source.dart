import 'package:hungry_app/core/network/api_service.dart';
import 'package:hungry_app/features/home/data/models/product_model.dart';
import 'package:hungry_app/features/home/data/models/toppings_model.dart';

class ProductRemoteDataSource {
  final ApiService _apiService;

  ProductRemoteDataSource(this._apiService);

  Future<List<ProductModel>> getProducts() async {
    final response = await _apiService.get('/products/');
    return (response['data'] as List)
        .map((product) => ProductModel.fromJson(product))
        .toList();
  }

  Future<List<ToppingModel>> getToppings() async {
    final response = await _apiService.get('/toppings');
    return (response['data'] as List)
        .map((topping) => ToppingModel.fromJson(topping))
        .toList();
  }

  Future<List<ToppingModel>> getOptions() async {
    final response = await _apiService.get('/side-options');
    return (response['data'] as List)
        .map((option) => ToppingModel.fromJson(option))
        .toList();
  }

  Future<List<ProductModel>> searchProducts(String name) async {
    final response = await _apiService.get(
      '/products',
      params: {'name': name},
    );
    return (response['data'] as List)
        .map((product) => ProductModel.fromJson(product))
        .toList();
  }
}
