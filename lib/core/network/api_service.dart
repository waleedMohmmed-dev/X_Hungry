import 'package:dio/dio.dart';
import 'package:hungry_app/core/network/api_exceptions.dart';
import 'package:hungry_app/core/network/dio_client.dart';

class ApiService {
  final DioClient _dioClient = DioClient();

  Future<dynamic> get(String endpoint, {dynamic params}) async {
    try {
      final response = await _dioClient.dio.get(
        endpoint,
        queryParameters: params,
      );
      return response.data;
    } on DioException catch (e) {
      return ApiExceptions.handleError(e);
    }
  }

  Future<dynamic> post(String endpoint, dynamic body) async {
    try {
      final response = await _dioClient.dio.post(endpoint, data: body);
      return response.data;
    } on DioException catch (e) {
      return ApiExceptions.handleError(e);
    }
  }

  Future<dynamic> put(String endpoint, dynamic body) async {
    try {
      final response = await _dioClient.dio.put(endpoint, data: body);
      return response.data;
    } on DioException catch (e) {
      return ApiExceptions.handleError(e);
    }
  }

  Future<dynamic> delete(
    String endpoint,
    dynamic body, {
    dynamic params,
  }) async {
    try {
      final response = await _dioClient.dio.delete(
        endpoint,
        data: body,
        queryParameters: params,
      );
      return response.data;
    } on DioException catch (e) {
      return ApiExceptions.handleError(e);
    }
  }
}
