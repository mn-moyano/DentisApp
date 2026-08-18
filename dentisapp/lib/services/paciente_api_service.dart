import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/paciente.dart';

class PacienteApiService {
  // URL de la API.
  static const String apiBaseUrl =
      String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:5133',
  );

  // Endpoint de pacientes.
  String get baseUrl =>
      '$apiBaseUrl/api/pacientes';

  /// Obtener lista de pacientes.
  Future<List<Paciente>> obtenerPacientes() async {
    final response =
        await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> respuesta =
          jsonDecode(response.body);

      final List<dynamic> data =
          respuesta['data'];

      return data
          .map(
            (json) => Paciente.fromJson(json),
          )
          .toList();
    }

    throw Exception(
      'Error al obtener pacientes: '
      '${response.statusCode} - '
      '${response.body}',
    );
  }

  /// Obtener paciente por ID.
  Future<Paciente?> obtenerPacientePorId(
    int id,
  ) async {
    final response = await http.get(
      Uri.parse('$baseUrl/$id'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> respuesta =
          jsonDecode(response.body);

      return Paciente.fromJson(
        respuesta['data'],
      );
    }

    if (response.statusCode == 404) {
      return null;
    }

    throw Exception(
      'Error al obtener paciente: '
      '${response.statusCode}',
    );
  }

  /// Crear paciente.
  Future<Paciente?> crearPaciente(
    Paciente paciente,
  ) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(
        paciente.toJson(),
      ),
    );

    print(
      'STATUS CREAR PACIENTE: '
      '${response.statusCode}',
    );

    print(
      'RESPUESTA CREAR PACIENTE: '
      '${response.body}',
    );

    if (response.statusCode == 200 ||
        response.statusCode == 201) {
      final Map<String, dynamic> respuesta =
          jsonDecode(response.body);

      return Paciente.fromJson(
        respuesta['data'],
      );
    }

    return null;
  }

  /// Actualizar paciente.
  Future<Paciente?> actualizarPaciente(
    Paciente paciente,
  ) async {
    final url =
        '$baseUrl/${paciente.idPaciente}';

    print('========== ACTUALIZAR PACIENTE ==========');
    print('URL: $url');
    print('ID: ${paciente.idPaciente}');
    print(
      'JSON ENVIADO: '
      '${paciente.toJson()}',
    );

    final response = await http.put(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(
        paciente.toJson(),
      ),
    );

    print(
      'STATUS ACTUALIZAR: '
      '${response.statusCode}',
    );

    print(
      'RESPUESTA ACTUALIZAR: '
      '${response.body}',
    );

    print(
      '==========================================',
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> respuesta =
          jsonDecode(response.body);

      return Paciente.fromJson(
        respuesta['data'],
      );
    }

    return null;
  }

  /// Eliminar paciente.
  Future<bool> eliminarPaciente(
    int id,
  ) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$id'),
    );

    return response.statusCode == 200;
  }
}