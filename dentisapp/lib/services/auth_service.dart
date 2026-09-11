import 'package:dio/dio.dart';

import '../database/local_database.dart';
import '../models/login_response.dart';
import 'api_client.dart';
import 'jwt_service.dart';
import 'storage/secure_storage_service.dart';

class AuthService {
  final SecureStorageService _secureStorage =
      SecureStorageService();

  final JwtService _jwtService = JwtService();

  Dio get _dio => ApiClient.instance.dio;

  Future<LoginResponse> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        '/api/auth/login',
        data: {
          'username': username,
          'password': password,
        },
        options: Options(
          extra: {
            'requiresAuth': false,
          },
        ),
      );

      final data = response.data as Map<String, dynamic>;

      if (data['success'] == true) {
        final loginResponse =
            LoginResponse.fromJson(data);

        await _secureStorage.guardarToken(
          loginResponse.token,
        );

        await _secureStorage.guardarRefreshToken(
          loginResponse.refreshToken,
        );

        return loginResponse;
      }

      throw ApiException(
        data['message'] ??
            'No fue posible iniciar sesión.',
        statusCode: response.statusCode ?? 0,
      );
    } on DioException catch (error) {
      throw ApiException(
        _mensajeDesdeError(error),
        statusCode:
            error.response?.statusCode ?? 0,
      );
    }
  }

  Future<bool> tieneSesionActiva() async {
    return _secureStorage.tieneSesion();
  }

  Future<String?> obtenerToken() async {
    return _secureStorage.obtenerToken();
  }

  Future<String?> obtenerRefreshToken() async {
    return _secureStorage.obtenerRefreshToken();
  }

  Future<String?> obtenerRol() async {
    final token =
        await _secureStorage.obtenerToken();

    if (token == null || token.isEmpty) {
      return null;
    }

    return _jwtService.obtenerRol(token);
  }

  Future<String?> obtenerUsuario() async {
    final token =
        await _secureStorage.obtenerToken();

    if (token == null || token.isEmpty) {
      return null;
    }

    return _jwtService.obtenerUsuario(token);
  }

  Future<void> guardarTokens({
    required String token,
    required String refreshToken,
  }) async {
    await _secureStorage.guardarToken(token);

    await _secureStorage.guardarRefreshToken(
      refreshToken,
    );
  }

  Future<void> cerrarSesion() async {
    await _secureStorage.eliminarTodo();

    await LocalDatabase.instance
        .eliminarBaseDatos();
  }

  String _mensajeDesdeError(
    DioException error,
  ) {
    final responseData = error.response?.data;

    if (responseData is Map<String, dynamic> &&
        responseData['message'] is String) {
      return responseData['message'] as String;
    }

    switch (error.type) {
      case DioExceptionType.connectionError:
        return 'No fue posible conectar con el servidor.';

      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'La solicitud tardó demasiado. Verifica tu conexión.';

      default:
        return 'No fue posible iniciar sesión.';
    }
  }
}