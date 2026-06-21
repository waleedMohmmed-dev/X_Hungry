import 'package:hungry_app/core/network/api_error.dart';
import 'package:hungry_app/core/network/api_service.dart';
import 'package:hungry_app/features/cart/data/models/cart_model.dart';

class CartRemoteDataSource {
  final ApiService _apiService;

  CartRemoteDataSource(this._apiService);

  Future<void> addToCart(Map<String, dynamic> data) async {
    final res = await _apiService.post('/cart/add', data);
    if (res is ApiError) throw res;
  }

  Future<GetCartResponse> getCart() async {
    final res = await _apiService.get('/cart');
    if (res is ApiError) throw res;
    return GetCartResponse.fromJson(res);
  }

  Future<void> removeCartItem(int id) async {
    final res = await _apiService.delete('/cart/remove/$id', {});
    if (res is ApiError) throw res;
  }
}
