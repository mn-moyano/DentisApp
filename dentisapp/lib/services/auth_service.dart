import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/login_response.dart';
import 'storage/secure_storage_service.dart';

class AuthService {
  static const String apiBaseUrl =
      String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:5133',
  );

  final SecureStorageService _secureStorage =
      SecureStorageService();

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

  Future<void> cerrarSesion() async {
    await _secureStorage.eliminarTodo();
  }
}