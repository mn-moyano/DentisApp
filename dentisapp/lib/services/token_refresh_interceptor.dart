import 'package:dio/dio.dart';

import 'storage/secure_storage_service.dart';

class TokenRefreshInterceptor extends QueuedInterceptor {
  TokenRefreshInterceptor({
    required this._secureStorage,
    required this._dio,
  });

  final SecureStorageService _secureStorage;
  final Dio _dio;

  Future<String?>? _refreshingToken;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final statusCode = err.response?.statusCode;

    final alreadyRetried =
        err.requestOptions.extra['alreadyRetried'] == true;

    final requiresAuth =
        err.requestOptions.extra['requiresAuth'] != false;

    final isRefreshRequest =
        err.requestOptions.path == '/api/auth/refresh';

    if (statusCode != 401 ||
        alreadyRetried ||
        !requiresAuth ||
        isRefreshRequest) {
      handler.next(err);
      return;
    }

    try {
      final newToken = await _refreshToken();

      if (newToken == null || newToken.isEmpty) {
        handler.next(err);
        return;
      }

      err.requestOptions.extra['alreadyRetried'] = true;

      err.requestOptions.headers['Authorization'] =
          'Bearer $newToken';

      final response = await _dio.fetch(
        err.requestOptions,
      );

      handler.resolve(response);
    } on DioException {
      await _secureStorage.eliminarTodo();
      handler.next(err);
    } catch (_) {
      await _secureStorage.eliminarTodo();
      handler.next(err);
    }
  }

  Future<String?> _refreshToken() async {
    if (_refreshingToken != null) {
      return _refreshingToken;
    }

    _refreshingToken = _realizarRefresh();

    try {
      return await _refreshingToken;
    } finally {
      _refreshingToken = null;
    }
  }

  Future<String?> _realizarRefresh() async {
    final refreshToken =
        await _secureStorage.obtenerRefreshToken();

    if (refreshToken == null || refreshToken.isEmpty) {
      return null;
    }

    final response = await _dio.post(
      '/api/auth/refresh',
      data: {
        'refreshToken': refreshToken,
      },
      options: Options(
        extra: {
          'requiresAuth': false,
          'skipRefresh': true,
        },
      ),
    );

    final data = response.data as Map<String, dynamic>;

    if (data['success'] != true) {
      return null;
    }

    final newToken = data['token'] as String?;
    final newRefreshToken =
        data['refreshToken'] as String?;

    if (newToken == null ||
        newToken.isEmpty ||
        newRefreshToken == null ||
        newRefreshToken.isEmpty) {
      return null;
    }

    await _secureStorage.guardarToken(newToken);

    await _secureStorage.guardarRefreshToken(
      newRefreshToken,
    );

    return newToken;
  }
}