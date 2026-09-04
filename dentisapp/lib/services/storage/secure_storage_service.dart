import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const String _tokenKey = 'auth_token';

  final FlutterSecureStorage _storage =
      const FlutterSecureStorage();

  /// Guarda el token JWT de forma segura.
  Future<void> guardarToken(String token) async {
    await _storage.write(
      key: _tokenKey,
      value: token,
    );
  }

  /// Obtiene el token almacenado.
  Future<String?> obtenerToken() async {
    return await _storage.read(
      key: _tokenKey,
    );
  }

  /// Verifica si existe una sesión activa.
  Future<bool> tieneSesion() async {
    final token = await obtenerToken();

    return token != null && token.isNotEmpty;
  }

  /// Elimina únicamente el token.
  Future<void> eliminarToken() async {
    await _storage.delete(
      key: _tokenKey,
    );
  }

  /// Elimina todos los datos seguros.
  Future<void> eliminarTodo() async {
    await _storage.deleteAll();
  }
}