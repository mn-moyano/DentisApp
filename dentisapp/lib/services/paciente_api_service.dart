import 'dart:convert';

import '../models/paciente.dart';
import 'api_client.dart';

class PacienteApiService {
  final ApiClient _apiClient = ApiClient();
  String get baseUrl => '/api/pacientes';

  Future<List<Paciente>> obtenerPacientes() async {
    final response = await _apiClient.get(baseUrl);
    final data = (jsonDecode(response.body) as Map<String, dynamic>)['data']
        as List<dynamic>;
    return data.map((json) => Paciente.fromJson(json)).toList();
  }

  Future<Paciente?> crearPaciente(Paciente paciente) async {
    final response = await _apiClient.post(baseUrl, body: paciente.toJson());
    final data = (jsonDecode(response.body) as Map<String, dynamic>)['data'];
    return Paciente.fromJson(data);
  }

  Future<Paciente?> actualizarPaciente(Paciente paciente) async {
    final response = await _apiClient.put(
      '$baseUrl/${paciente.idPaciente}',
      body: paciente.toJson(),
    );
    final data = (jsonDecode(response.body) as Map<String, dynamic>)['data'];
    return Paciente.fromJson(data);
  }

  Future<bool> eliminarPaciente(int id) async {
    await _apiClient.delete('$baseUrl/$id');
    return true;
  }
}
