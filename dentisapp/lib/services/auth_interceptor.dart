import 'package:dio/dio.dart';

import 'storage/secure_storage_service.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._secureStorage);

  final SecureStorageService _secureStorage;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final requiresAuth =
        options.extra['requiresAuth'] != false;

    if (!requiresAuth) {
      handler.next(options);
      return;
    }

    final token = await _secureStorage.obtenerToken();

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }
}