import 'package:dio/dio.dart';

import 'http_method.dart';
import 'network_client.dart';

/// Base for all remote datasource implementations.
///
/// Subclasses call [baseSendRequest] instead of using Dio directly.
/// A fresh [CancelToken] is created per request and tracked so that
/// [dispose] can cancel every in-flight request at once (call this
/// from your BLoC / ViewModel close).
abstract class BaseRemoteDataSource {
  final List<CancelToken> _cancelTokens = [];

  /// Delegates to [NetworkClient.sendRequest] with an auto-managed [CancelToken].
  /// Returns [Response.data] directly as [dynamic].
  Future<dynamic> baseSendRequest(
    String path,
    HttpMethod method, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) {
    final token = CancelToken();
    _cancelTokens.add(token);
    return NetworkClient()
        .sendRequest(
          path,
          method,
          data: data,
          queryParameters: queryParameters,
          cancelToken: token,
        )
        .whenComplete(() => _cancelTokens.remove(token));
  }

  void dispose() {
    for (final token in _cancelTokens) {
      if (!token.isCancelled) token.cancel();
    }
    _cancelTokens.clear();
  }
}
