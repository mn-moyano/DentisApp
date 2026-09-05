import 'dart:convert';

class JwtService {
  Map<String, dynamic>? _obtenerPayload(String token) {
    try {
      final partes = token.split('.');

      if (partes.length != 3) {
        return null;
      }

      final payloadNormalizado =
          base64Url.normalize(partes[1]);

      final payloadDecoded =
          utf8.decode(
        base64Url.decode(payloadNormalizado),
      );

      return jsonDecode(payloadDecoded)
          as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  /// Obtiene el rol almacenado dentro del JWT.
  String? obtenerRol(String token) {
    final datos = _obtenerPayload(token);

    if (datos == null) {
      return null;
    }

    return datos[
      'http://schemas.microsoft.com/ws/2008/06/identity/claims/role'
    ]?.toString();
  }

  /// Obtiene el nombre de usuario almacenado dentro del JWT.
  String? obtenerUsuario(String token) {
    final datos = _obtenerPayload(token);

    if (datos == null) {
      return null;
    }

    return datos[
      'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name'
    ]?.toString();
  }
}