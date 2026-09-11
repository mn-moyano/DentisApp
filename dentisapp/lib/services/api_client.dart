import 'package:dio/dio.dart';

import 'auth_interceptor.dart';
import 'retry_interceptor.dart';
import 'storage/secure_storage_service.dart';
import 'token_refresh_interceptor.dart';

class ApiException implements Exception {
  const ApiException(
    this.message, {
    this.statusCode = 0,
    this.errors,
  });

  final String message;
  final int statusCode;
  final Map<String, dynamic>? errors;

  @override
  String toString() => message;
}

class ApiClient {
  ApiClient._internal()
      : _secureStorage = SecureStorageService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: _validatedBaseUrl(),
        connectTimeout: const Duration(seconds: 10),
        sendTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      AuthInterceptor(_secureStorage),
    );

    _dio.interceptors.add(
      TokenRefreshInterceptor(
        secureStorage: _secureStorage,
        dio: _dio,
      ),
    );

    _dio.interceptors.add(
      RetryInterceptor(
        dio: _dio,
      ),
    );
  }

  static final ApiClient instance = ApiClient._internal();

  late final Dio _dio;

  final SecureStorageService _secureStorage;

  static const String environment = String.fromEnvironment(
    'APP_ENV',
    defaultValue: 'development',
  );

  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:5133',
  );

  static String _validatedBaseUrl() {
    if (environment == 'production' &&
        !baseUrl.startsWith('https://')) {
      throw StateError(
        'En producción la API debe utilizar HTTPS.',
      );
    }

    return baseUrl;
  }

  Dio get dio => _dio;

  Future<String?> obtenerToken() async {
    return _secureStorage.obtenerToken();
  }
}