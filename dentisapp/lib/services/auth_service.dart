import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/login_response.dart';
import 'jwt_service.dart';
import 'storage/secure_storage_service.dart';

class AuthService {
  static const String apiBaseUrl =
      String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:5133',
  );

  final SecureStorageService _secureStorage =
      SecureStorageService();

  final JwtService _jwtService = JwtService();

  Future<LoginResponse> login({
    required String username,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$apiBaseUrl/api/auth/login'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    final Map<String, dynamic> data =
        jsonDecode(response.body);

    if (response.statusCode == 200 &&
        data['success'] == true) {
      final loginResponse =
          LoginResponse.fromJson(data);

      await _secureStorage.guardarToken(
        loginResponse.token,
      );

      return loginResponse;
    }

    throw Exception(
      data['message'] ??
          'No fue posible iniciar sesión.',
    );
  }

  Future<bool> tieneSesionActiva() async {
    return await _secureStorage.tieneSesion();
  }

  Future<String?> obtenerToken() async {
    return await _secureStorage.obtenerToken();
  }

  Future<String?> obtenerRol() async {
    final token = await _secureStorage.obtenerToken();

    if (token == null || token.isEmpty) {
      return null;
    }

    return _jwtService.obtenerRol(token);
  }

  Future<String?> obtenerUsuario() async {
    final token = await _secureStorage.obtenerToken();

    if (token == null || token.isEmpty) {
      return null;
    }

    return _jwtService.obtenerUsuario(token);
  }

  Future<void> cerrarSesion() async {
    await _secureStorage.eliminarTodo();
  }
}