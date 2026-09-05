import 'dart:convert';

import '../database/local_database.dart';
import '../models/login_response.dart';
import 'api_client.dart';
import 'jwt_service.dart';
import 'storage/secure_storage_service.dart';

class AuthService {
  final SecureStorageService _secureStorage = SecureStorageService();
  final ApiClient _apiClient = ApiClient();
  final JwtService _jwtService = JwtService();

  Future<LoginResponse> login({
    required String username,
    required String password,
  }) async {
    final response = await _apiClient.post(
      '/api/auth/login',
      authenticated: false,
      body: {'username': username, 'password': password},
    );

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode == 200 && data['success'] == true) {
      final loginResponse = LoginResponse.fromJson(data);
      await _secureStorage.guardarToken(loginResponse.token);
      return loginResponse;
    }

    throw Exception(data['message'] ?? 'No fue posible iniciar sesión.');
  }

  Future<bool> tieneSesionActiva() async => _secureStorage.tieneSesion();

  Future<String?> obtenerToken() async => _secureStorage.obtenerToken();

  Future<String?> obtenerRol() async {
    final token = await _secureStorage.obtenerToken();
    return token == null || token.isEmpty ? null : _jwtService.obtenerRol(token);
  }

  Future<String?> obtenerUsuario() async {
    final token = await _secureStorage.obtenerToken();
    return token == null || token.isEmpty
        ? null
        : _jwtService.obtenerUsuario(token);
  }

  Future<void> cerrarSesion() async {
    await _secureStorage.eliminarTodo();
    await LocalDatabase.instance.eliminarBaseDatos();
  }
}
