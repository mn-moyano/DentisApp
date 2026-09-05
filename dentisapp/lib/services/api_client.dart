import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'storage/secure_storage_service.dart';

class ApiException implements Exception {
  const ApiException(this.message, {required this.statusCode});

  final String message;
  final int statusCode;

  @override
  String toString() => message;
}

class ApiClient {
  ApiClient({http.Client? client, SecureStorageService? secureStorage})
      : _client = client ?? http.Client(),
        _secureStorage = secureStorage ?? SecureStorageService();

  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:5133',
  );

  final http.Client _client;
  final SecureStorageService _secureStorage;

  Future<http.Response> get(String path) =>
      _send((headers) => _client.get(_uri(path), headers: headers));

  Future<http.Response> post(
    String path, {
    Object? body,
    bool authenticated = true,
  }) =>
      _send(
        (headers) => _client.post(
          _uri(path),
          headers: headers,
          body: body == null ? null : jsonEncode(body),
        ),
        authenticated: authenticated,
      );

  Future<http.Response> put(String path, {Object? body}) => _send(
        (headers) => _client.put(
          _uri(path),
          headers: headers,
          body: body == null ? null : jsonEncode(body),
        ),
      );

  Future<http.Response> delete(String path) =>
      _send((headers) => _client.delete(_uri(path), headers: headers));

  Uri _uri(String path) => Uri.parse('$baseUrl$path');

  Future<Map<String, String>> _headers({bool authenticated = true}) async {
    final token = authenticated ? await _secureStorage.obtenerToken() : null;
    return {
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  Future<http.Response> _send(
    Future<http.Response> Function(Map<String, String> headers) request, {
    bool authenticated = true,
  }) async {
    try {
      final response = await request(
        await _headers(authenticated: authenticated),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode >= 400) {
        throw ApiException(
          _messageFrom(response),
          statusCode: response.statusCode,
        );
      }
      return response;
    } on TimeoutException {
      throw const ApiException(
        'La solicitud tardó demasiado. Verifica tu conexión.',
        statusCode: 408,
      );
    } on ApiException {
      rethrow;
    } on http.ClientException catch (error) {
      throw ApiException(
        'No fue posible conectar con el servidor: ${error.message}',
        statusCode: 0,
      );
    }
  }

  String _messageFrom(http.Response response) {
    try {
      final data = jsonDecode(response.body);
      if (data is Map<String, dynamic> && data['message'] is String) {
        return data['message'] as String;
      }
    } on FormatException {
      // Use a generic message for non-JSON responses.
    }
    return 'Error de comunicación con el servidor (${response.statusCode}).';
  }
}
