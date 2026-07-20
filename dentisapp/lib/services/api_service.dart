/// Servicio base para centralizar la configuración de llamadas a la API.
///
/// En este proyecto todavía no se conecta a una base de datos real, por lo que
/// este archivo actúa como punto de referencia para futuras integraciones.
class ApiService {
  /// URL base de la API. Se deja preparada para cuando se conecte el backend.
  static const String baseUrl = 'https://localhost:5133/api';

  /// Devuelve la ruta completa para un endpoint dado.
  String buildUrl(String endpoint) {
    return '$baseUrl/$endpoint';
  }
}
