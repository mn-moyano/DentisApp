import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/paciente.dart';
import 'auth_service.dart';

class PacienteApiService {

  static const String apiBaseUrl =
      String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:5133',
  );

  String get baseUrl =>
      '$apiBaseUrl/api/pacientes';

  final AuthService _authService =
      AuthService();

  Future<Map<String, String>>
      _headers() async {

    final token =
        await _authService.obtenerToken();

    return {
      'Content-Type':
          'application/json',

      if (token != null)
        'Authorization':
            'Bearer $token',
    };
  }

  Future<List<Paciente>>
      obtenerPacientes() async {

    final response = await http.get(
      Uri.parse(baseUrl),
      headers: await _headers(),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic>
          respuesta =
          jsonDecode(response.body);

      final List<dynamic> data =
          respuesta['data'];

      return data
          .map(
            (json) =>
                Paciente.fromJson(json),
          )
          .toList();
    }

    if (response.statusCode == 401) {
      throw Exception(
        'Sesión no autorizada.',
      );
    }

    throw Exception(
      'Error al obtener pacientes: '
      '${response.statusCode}',
    );
  }

  Future<Paciente?>
      crearPaciente(
    Paciente paciente,
  ) async {

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: await _headers(),
      body: jsonEncode(
        paciente.toJson(),
      ),
    );

    if (response.statusCode == 201) {

      final Map<String, dynamic>
          respuesta =
          jsonDecode(response.body);

      return Paciente.fromJson(
        respuesta['data'],
      );
    }

    throw Exception(
      'No se pudo registrar '
      'el paciente.',
    );
  }

  Future<Paciente?>
      actualizarPaciente(
    Paciente paciente,
  ) async {

    final response = await http.put(
      Uri.parse(
        '$baseUrl/${paciente.idPaciente}',
      ),
      headers: await _headers(),
      body: jsonEncode(
        paciente.toJson(),
      ),
    );

    if (response.statusCode == 200) {

      final Map<String, dynamic>
          respuesta =
          jsonDecode(response.body);

      return Paciente.fromJson(
        respuesta['data'],
      );
    }

    throw Exception(
      'No se pudo actualizar '
      'el paciente.',
    );
  }

  Future<bool> eliminarPaciente(
    int id,
  ) async {

    final response =
        await http.delete(
      Uri.parse('$baseUrl/$id'),
      headers: await _headers(),
    );

    return response.statusCode == 200;
  }
}