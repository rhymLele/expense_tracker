import 'package:dio/dio.dart';

import '../storage/token_storage.dart';
import 'api_constants.dart';

/// Injects the Authorization header on every request.
/// On 401: silently attempts to refresh tokens and retries the original request once.
/// If refresh also fails → clears stored tokens (user must log in again).
class AuthInterceptor extends Interceptor {
  final Dio _dio;
  final TokenStorage _tokenStorage;

  // Separate Dio for refresh calls to avoid interceptor infinite loop.
  late final Dio _refreshDio;

  AuthInterceptor({required Dio dio, required TokenStorage tokenStorage})
      : _dio = dio,
        _tokenStorage = tokenStorage {
    _refreshDio = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));
  }

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _tokenStorage.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode != 401) {
      handler.next(err);
      return;
    }

    // Do not retry refresh endpoint itself (would loop).
    if (err.requestOptions.path == ApiConstants.refresh) {
      await _tokenStorage.clearTokens();
      handler.next(err);
      return;
    }

    try {
      final refreshToken = await _tokenStorage.getRefreshToken();
      if (refreshToken == null) {
        handler.next(err);
        return;
      }

      final response = await _refreshDio.post(
        ApiConstants.refresh,
        options: Options(headers: {'Authorization': 'Bearer $refreshToken'}),
      );

      final data = response.data['data'] as Map<String, dynamic>;
      await _tokenStorage.saveTokens(
        accessToken: data['accessToken'] as String,
        refreshToken: data['refreshToken'] as String,
      );

      // Retry original request with new token.
      final retryOptions = err.requestOptions
        ..headers['Authorization'] = 'Bearer ${data['accessToken']}';
      final retryResponse = await _dio.fetch(retryOptions);
      handler.resolve(retryResponse);
    } catch (_) {
      await _tokenStorage.clearTokens();
      handler.next(err);
    }
  }
}
