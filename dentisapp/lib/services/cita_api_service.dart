import 'dart:convert';

import '../models/cita.dart';
import 'api_client.dart';

class CitaApiService {
  final ApiClient _apiClient = ApiClient();
  String get baseUrl => '/api/citas';

  Future<List<Cita>> obtenerCitas() async {
    final response = await _apiClient.get(baseUrl);
    final data =
        (jsonDecode(response.body) as Map<String, dynamic>)['data']
            as List<dynamic>;
    return data.map((json) => Cita.fromMap(json)).toList();
  }

  Future<Cita?> obtenerCitaPorId(int id) async {
    try {
      final response = await _apiClient.get('$baseUrl/$id');
      final data = (jsonDecode(response.body) as Map<String, dynamic>)['data'];
      return Cita.fromMap(data);
    } on ApiException catch (error) {
      if (error.statusCode == 404) return null;
      rethrow;
    }
  }

  Future<Cita?> crearCita(Cita cita) async {
    final response = await _apiClient.post(baseUrl, body: cita.toMap());
    final data = (jsonDecode(response.body) as Map<String, dynamic>)['data'];
    return Cita.fromMap(data);
  }

  Future<Cita?> actualizarCita(Cita cita) async {
    final response = await _apiClient.put(
      '$baseUrl/${cita.idCita}',
      body: cita.toMap(),
    );
    final data = (jsonDecode(response.body) as Map<String, dynamic>)['data'];
    return Cita.fromMap(data);
  }

  Future<bool> eliminarCita(int id) async {
    await _apiClient.delete('$baseUrl/$id');
    return true;
  }
}
