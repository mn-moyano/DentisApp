import 'dart:convert';

import '../models/paciente.dart';
import 'api_client.dart';

class PacienteApiService {
  String get baseUrl => '/api/pacientes';

  final ApiClient _apiClient = ApiClient();

  Future<List<Paciente>> obtenerPacientes() async {
    final response = await _apiClient.get(baseUrl);
    final respuesta = jsonDecode(response.body) as Map<String, dynamic>;
    final data = respuesta['data'] as List<dynamic>;

    return data.map((json) => Paciente.fromJson(json)).toList();
  }

  Future<Paciente?> crearPaciente(Paciente paciente) async {
    final response = await _apiClient.post(baseUrl, body: paciente.toJson());
    final respuesta = jsonDecode(response.body) as Map<String, dynamic>;
    return Paciente.fromJson(respuesta['data']);
  }

  Future<Paciente?> actualizarPaciente(Paciente paciente) async {
    final response = await _apiClient.put(
      '$baseUrl/${paciente.idPaciente}',
      body: paciente.toJson(),
    );
    final respuesta = jsonDecode(response.body) as Map<String, dynamic>;
    return Paciente.fromJson(respuesta['data']);
  }

  Future<bool> eliminarPaciente(int id) async {
    await _apiClient.delete('$baseUrl/$id');
    return true;
  }
}
