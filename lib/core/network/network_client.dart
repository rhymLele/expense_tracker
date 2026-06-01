import 'dart:io';

import 'package:dio/dio.dart';

import '../errors/app_exception.dart';
import '../storage/token_storage.dart';
import 'api_constants.dart';
import 'auth_interceptor.dart';
import 'http_method.dart';

/// Singleton HTTP client. Call [NetworkClient.init] once at startup,
/// then use [NetworkClient().sendRequest] from [BaseRemoteDataSource].
class NetworkClient {
  static final NetworkClient _instance = NetworkClient._internal();
  factory NetworkClient() => _instance;
  NetworkClient._internal();

  static Dio _dio = _createDio();
  static bool _initialized = false;

  static Dio _createDio() => Dio(
        BaseOptions(
          baseUrl: ApiConstants.baseUrl,
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
          headers: {'Content-Type': 'application/json'},
        ),
      );

  /// Called once from [setupLocator] before any request is made.
  static void init(TokenStorage tokenStorage) {
    if (_initialized) return;
    _dio.interceptors.addAll([
      AuthInterceptor(dio: _dio, tokenStorage: tokenStorage),
      LogInterceptor(requestBody: true, responseBody: true),
    ]);
    _initialized = true;
  }

  /// Force-closes the current Dio instance and creates a fresh one.
  /// Call [init] again after this if authenticated requests are needed.
  static void close() {
    _dio.close(force: true);
    _dio = _createDio();
    _initialized = false;
  }

  /// Dispatches an HTTP request and returns [Response.data] directly.
  /// Maps [DioException] → typed [AppException].
  Future<dynamic> sendRequest(
    String path,
    HttpMethod method, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    required CancelToken cancelToken,
  }) async {
    try {
      final Response response;
      switch (method) {
        case HttpMethod.get:
          response = await _dio.get(
            path,
            queryParameters: queryParameters,
            cancelToken: cancelToken,
          );
        case HttpMethod.post:
          response = await _dio.post(
            path,
            data: data,
            cancelToken: cancelToken,
          );
        case HttpMethod.put:
          response = await _dio.put(
            path,
            data: data,
            cancelToken: cancelToken,
          );
        case HttpMethod.patch:
          response = await _dio.patch(
            path,
            data: data,
            cancelToken: cancelToken,
          );
        case HttpMethod.delete:
          response = await _dio.delete(
            path,
            data: data,
            cancelToken: cancelToken,
          );
      }
      return response.data;
    } on DioException catch (e) {
      throw _mapException(e);
    } on SocketException {
      throw const NetworkException();
    }
  }

  static AppException _mapException(DioException e) {
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return const NetworkException();
    }
    final statusCode = e.response?.statusCode ?? 0;
    final data = e.response?.data;
    final reason = (data is Map)
        ? (data['reason'] as String?) ??
            (data['message'] as String?) ??
            (data['error'] as String?) ??
            'Lỗi server'
        : 'Lỗi server';
    return switch (statusCode) {
      401 => AuthException(code: 'unauthorized', message: reason),
      409 => ServerException(code: 'conflict', message: reason),
      404 => NotFoundException(reason),
      422 => ServerException(code: 'validation', message: reason),
      _ => ServerException(code: statusCode.toString(), message: reason),
    };
  }
}
