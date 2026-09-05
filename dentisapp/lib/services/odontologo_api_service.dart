import 'dart:convert';

import '../models/odontologo.dart';
import 'api_client.dart';

class OdontologoApiService {
  final ApiClient _apiClient = ApiClient();
  String get baseUrl => '/api/odontologos';

  Future<List<Odontologo>> obtenerOdontologos() async {
    final response = await _apiClient.get(baseUrl);
    final data =
        (jsonDecode(response.body) as Map<String, dynamic>)['data']
            as List<dynamic>;
    return data.map((json) => Odontologo.fromJson(json)).toList();
  }

  Future<Odontologo?> obtenerOdontologoPorId(int id) async {
    try {
      final response = await _apiClient.get('$baseUrl/$id');
      final data = (jsonDecode(response.body) as Map<String, dynamic>)['data'];
      return Odontologo.fromJson(data);
    } on ApiException catch (error) {
      if (error.statusCode == 404) return null;
      rethrow;
    }
  }

  Future<Odontologo?> crearOdontologo(Odontologo odontologo) async {
    final response = await _apiClient.post(baseUrl, body: odontologo.toJson());
    final data = (jsonDecode(response.body) as Map<String, dynamic>)['data'];
    return Odontologo.fromJson(data);
  }

  Future<Odontologo?> actualizarOdontologo(Odontologo odontologo) async {
    final response = await _apiClient.put(
      '$baseUrl/${odontologo.idOdontologo}',
      body: odontologo.toJson(),
    );
    final data = (jsonDecode(response.body) as Map<String, dynamic>)['data'];
    return Odontologo.fromJson(data);
  }

  Future<bool> eliminarOdontologo(int id) async {
    await _apiClient.delete('$baseUrl/$id');
    return true;
  }
}
