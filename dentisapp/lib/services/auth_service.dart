import 'dart:convert';

import '../database/local_database.dart';
import '../models/login_response.dart';
import 'api_client.dart';
import 'storage/secure_storage_service.dart';

class AuthService {
  final SecureStorageService _secureStorage = SecureStorageService();
  final ApiClient _apiClient = ApiClient();

  Future<LoginResponse> login({
    required String username,
    required String password,
  }) async {
    final response = await _apiClient.post(
      '/api/auth/login',
      authenticated: false,
      body: {'username': username, 'password': password},
    );

    final Map<String, dynamic> data = jsonDecode(response.body);

    if (response.statusCode == 200 && data['success'] == true) {
      final loginResponse = LoginResponse.fromJson(data);

      await _secureStorage.guardarToken(loginResponse.token);

      return loginResponse;
    }

    throw Exception(data['message'] ?? 'No fue posible iniciar sesión.');
  }

  Future<bool> tieneSesionActiva() async {
    return await _secureStorage.tieneSesion();
  }

  Future<String?> obtenerToken() async {
    return await _secureStorage.obtenerToken();
  }

  Future<void> cerrarSesion() async {
    await _secureStorage.eliminarTodo();
    await LocalDatabase.instance.eliminarBaseDatos();
  }
}
