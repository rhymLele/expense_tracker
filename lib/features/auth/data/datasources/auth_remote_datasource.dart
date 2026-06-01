import '../../../../core/errors/app_exception.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/network/base_remote_datasource.dart';
import '../../../../core/network/http_method.dart';
import '../../../../core/storage/token_storage.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login({required String email, required String password});
  Future<UserModel> register({
    required String email,
    required String password,
    required String name,
    required String role,
  });
  Future<void> logout();
  Future<UserModel?> getCurrentUser();
}

class AuthRemoteDataSourceImpl extends BaseRemoteDataSource
    implements AuthRemoteDataSource {
  final TokenStorage _tokenStorage;

  AuthRemoteDataSourceImpl({required TokenStorage tokenStorage})
      : _tokenStorage = tokenStorage;

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final res = await baseSendRequest(
      ApiConstants.login,
      HttpMethod.post,
      data: {'email': email, 'password': password},
    );
    await _saveTokens(res['data'] as Map<String, dynamic>);
    return _fetchMe();
  }

  @override
  Future<UserModel> register({
    required String email,
    required String password,
    required String name,
    required String role,
  }) async {
    final res = await baseSendRequest(
      ApiConstants.register,
      HttpMethod.post,
      data: {'email': email, 'password': password, 'name': name, 'role': role},
    );
    await _saveTokens(res['data'] as Map<String, dynamic>);
    return _fetchMe();
  }

  @override
  Future<void> logout() async {
    try {
      await baseSendRequest(ApiConstants.logout, HttpMethod.post);
    } finally {
      await _tokenStorage.clearTokens();
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final token = await _tokenStorage.getAccessToken();
    if (token == null) return null;
    try {
      return await _fetchMe();
    } on AppException {
      return null;
    }
  }

  Future<void> _saveTokens(Map<String, dynamic> data) =>
      _tokenStorage.saveTokens(
        accessToken: data['accessToken'] as String,
        refreshToken: data['refreshToken'] as String,
      );

  Future<UserModel> _fetchMe() async {
    final res = await baseSendRequest(ApiConstants.authMe, HttpMethod.get);
    return UserModel.fromJson(res['data'] as Map<String, dynamic>);
  }
}
