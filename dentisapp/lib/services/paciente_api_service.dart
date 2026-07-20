import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/paciente.dart';

/// Servicio de acceso a datos para pacientes.
///
/// Aunque todavía no se conecta a la base de datos, este servicio define la
/// estructura que luego permitirá consumir la API de forma organizada.
class PacienteApiService {
  final String baseUrl= "https://localhost:5133/api/pacientes";

  /// Obtiene la lista de pacientes desde la ruta esperada del backend.
  Future<List<Paciente>> obtenerPacientes() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Paciente.fromMap(json)).toList();
    } else {
      throw Exception("Error al obtener pacientes: ${response.statusCode}");
    }
  }

  /// Obtiene un paciente por su identificador.
  Future<Paciente?> obtenerPacientePorId(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      return Paciente.fromMap(jsonDecode(response.body));
    } else {
      return null;
    }
  }

  /// Envía un nuevo paciente al backend.
  Future<Paciente?> crearPaciente(Paciente paciente) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(paciente.toMap()),
    );
    if (response.statusCode == 201) {
      return Paciente.fromMap(jsonDecode(response.body));
    } else {
      return null;
    }
  }
}
