import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/paciente.dart';

class PacienteApiService {
  final String baseUrl = "https://localhost:5133/api/pacientes";

  /// Obtener lista de pacientes
  Future<List<Paciente>> obtenerPacientes() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Paciente.fromJson(json)).toList();
    } else {
      throw Exception("Error al obtener pacientes: ${response.statusCode}");
    }
  }

  /// Obtener paciente por ID
  Future<Paciente?> obtenerPacientePorId(int id) async {
    final response = await http.get(Uri.parse("$baseUrl/$id"));

    if (response.statusCode == 200) {
      return Paciente.fromJson(jsonDecode(response.body));
    } else {
      return null;
    }
  }

  /// Crear paciente
  Future<Paciente?> crearPaciente(Paciente paciente) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(paciente.toJson()),
    );

    if (response.statusCode == 201) {
      return Paciente.fromJson(jsonDecode(response.body));
    } else {
      return null;
    }
  }

  /// Actualizar paciente
  Future<Paciente?> actualizarPaciente(Paciente paciente) async {
    final response = await http.put(
      Uri.parse("$baseUrl/${paciente.idPaciente}"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(paciente.toJson()),
    );

    if (response.statusCode == 200) {
      return Paciente.fromJson(jsonDecode(response.body));
    } else {
      return null;
    }
  }

  /// Eliminar paciente
  Future<bool> eliminarPaciente(int id) async {
    final response = await http.delete(Uri.parse("$baseUrl/$id"));

    return response.statusCode == 200;
  }
}
