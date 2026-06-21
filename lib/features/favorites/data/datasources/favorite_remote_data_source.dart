import 'package:hungry_app/core/network/api_error.dart';
import 'package:hungry_app/core/network/api_service.dart';
import 'package:hungry_app/features/home/data/models/product_model.dart';

class FavoriteRemoteDataSource {
  final ApiService _apiService;

  FavoriteRemoteDataSource(this._apiService);

  Future<Map<String, dynamic>> toggleFavorite(int productId) async {
    final res = await _apiService.post('/favorites', {'product_id': productId});
    if (res is ApiError) throw res;
    return res as Map<String, dynamic>;
  }

  Future<List<ProductModel>> getFavorites() async {
    final res = await _apiService.get('/favorites');
    if (res is ApiError) throw res;
    final data = (res as Map<String, dynamic>)['data'] as List;
    return data.map((e) => ProductModel.fromJson(e)).toList();
  }
}
