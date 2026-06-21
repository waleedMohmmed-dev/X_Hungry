import 'package:dio/dio.dart';
import 'package:hungry_app/core/network/api_error.dart';
import 'package:hungry_app/core/network/api_service.dart';
import 'package:hungry_app/features/auth/data/models/user_model.dart';

class AuthRemoteDataSource {
  final ApiService _apiService;

  AuthRemoteDataSource(this._apiService);

  Future<UserModel> login(String email, String password) async {
    final response = await _apiService.post('/login', {
      'email': email,
      'password': password,
    });

    return _handleResponse(response);
  }

  Future<UserModel> signup(String name, String email, String password) async {
    final response = await _apiService.post('/register', {
      'name': name,
      'password': password,
      'email': email,
    });

    return _handleResponse(response);
  }

  Future<UserModel> getProfile() async {
    final response = await _apiService.get('/profile');
    return _handleResponse(response);
  }

  Future<UserModel> updateProfile({
    required String name,
    required String email,
    required String address,
    String? visa,
    String? imagePath,
  }) async {
    final formData = FormData.fromMap({
      'name': name,
      'email': email,
      'address': address,
      if (visa != null && visa.isNotEmpty) 'Visa': visa,
      if (imagePath != null && imagePath.isNotEmpty)
        'image': await MultipartFile.fromFile(
          imagePath,
          filename: 'profile.jpg',
        ),
    });

    final response = await _apiService.post('/update-profile', formData);
    return _handleResponse(response);
  }

  Future<void> logout() async {
    final response = await _apiService.post('/logout', {});
    if (response is ApiError) throw response;
    if (response is Map<String, dynamic> && response['data'] != null) {
      throw ApiError(message: 'Something went wrong');
    }
  }

  UserModel _handleResponse(dynamic response) {
    if (response is ApiError) throw response;

    if (response is Map<String, dynamic>) {
      final code = response['code'];
      final statusCode = int.tryParse(code.toString()) ?? code;
      if (statusCode != 200 && statusCode != 201) {
        throw ApiError(message: response['message'] ?? 'Unknown error');
      }
      return UserModel.fromJson(response['data']);
    }
    throw ApiError(message: 'Unexpected error from server');
  }
}
