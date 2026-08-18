import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/paciente.dart';

class PacienteApiService {
  // URL de la API definida mediante variable de entorno.
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:5133',
  );

  // Endpoint de pacientes.
  String get baseUrl => '$apiBaseUrl/api/pacientes';

  /// Obtener lista de pacientes
  Future<List<Paciente>> obtenerPacientes() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> respuesta =
          jsonDecode(response.body);

      final List<dynamic> data = respuesta['data'];

      return data
          .map((json) => Paciente.fromJson(json))
          .toList();
    } else {
      throw Exception(
        "Error al obtener pacientes: ${response.statusCode} - ${response.body}",
      );
    }
  }

  /// Obtener paciente por ID
  Future<Paciente?> obtenerPacientePorId(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/$id'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> respuesta =
          jsonDecode(response.body);

      return Paciente.fromJson(respuesta['data']);
    }

    if (response.statusCode == 404) {
      return null;
    }

    throw Exception(
      "Error al obtener paciente: ${response.statusCode}",
    );
  }

  /// Crear paciente
  Future<Paciente?> crearPaciente(Paciente paciente) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(paciente.toJson()),
    );

    if (response.statusCode == 201) {
      final Map<String, dynamic> respuesta =
          jsonDecode(response.body);

      return Paciente.fromJson(respuesta['data']);
    }

    return null;
  }

  /// Actualizar paciente
  Future<Paciente?> actualizarPaciente(
    Paciente paciente,
  ) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${paciente.idPaciente}'),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(paciente.toJson()),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> respuesta =
          jsonDecode(response.body);

      return Paciente.fromJson(respuesta['data']);
    }

    return null;
  }

  /// Eliminar paciente
  Future<bool> eliminarPaciente(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$id'),
    );

    return response.statusCode == 200;
  }
}