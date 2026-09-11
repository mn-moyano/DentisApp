import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const String _tokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';

  final FlutterSecureStorage _storage =
      const FlutterSecureStorage();

  /// Guarda el token JWT de forma segura.
  Future<void> guardarToken(String token) async {
    await _storage.write(
      key: _tokenKey,
      value: token,
    );
  }

  /// Obtiene el token JWT almacenado.
  Future<String?> obtenerToken() async {
    return await _storage.read(
      key: _tokenKey,
    );
  }

  /// Guarda el refresh token de forma segura.
  Future<void> guardarRefreshToken(String refreshToken) async {
    await _storage.write(
      key: _refreshTokenKey,
      value: refreshToken,
    );
  }

  /// Obtiene el refresh token almacenado.
  Future<String?> obtenerRefreshToken() async {
    return await _storage.read(
      key: _refreshTokenKey,
    );
  }

  /// Verifica si existe una sesión activa.
  Future<bool> tieneSesion() async {
    final token = await obtenerToken();

    return token != null && token.isNotEmpty;
  }

  /// Elimina únicamente el token JWT.
  Future<void> eliminarToken() async {
    await _storage.delete(
      key: _tokenKey,
    );
  }

  /// Elimina el refresh token.
  Future<void> eliminarRefreshToken() async {
    await _storage.delete(
      key: _refreshTokenKey,
    );
  }

  /// Elimina todos los datos seguros.
  Future<void> eliminarTodo() async {
    await _storage.deleteAll();
  }
}