import 'package:hungry_app/core/network/api_error.dart';
import 'package:hungry_app/core/network/api_service.dart';
import 'package:hungry_app/features/cart/data/cart_model.dart';

class CartRepo {
  final ApiService _apiService = ApiService();

  /// add to cart
  Future<void> addToCart(CartRequestModel cartData) async {
    try {
      final res = await _apiService.post('/cart/add', cartData.toJosn());
      throw ApiError(message: 'Product Added To Cart');
    } catch (e) {
      throw ApiError(message: e.toString());
    }
  }

  /// get cart

  Future<GetCartResponse?> getCartData() async {
    try {
      final res = await _apiService.get('/cart');

      if (res is ApiError) {
        throw ApiError(message: res.message);
      }
      return GetCartResponse.fromJson(res);
    } catch (e) {
      throw ApiError(message: e.toString());
    }
  }

  /// delete from cart
  Future<void> removeCartItem(int id) async {
    try {
      final res = await _apiService.delete('/cart/remove/$id', {});
      if (res['code'] == 200 && res['data '] == null) {
        throw ApiError(message: res['message']);
      }
    } catch (e) {
      throw ApiError(message: 'Remove  Cart Item :  ${e.toString()}');
    }
  }
}
