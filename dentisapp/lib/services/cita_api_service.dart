import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/cita.dart';

class CitaApiService {
  static const String apiBaseUrl =
      String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:5133',
  );

  String get baseUrl => '$apiBaseUrl/api/citas';

  /// Obtener todas las citas.
  Future<List<Cita>> obtenerCitas() async {
    final response = await http.get(
      Uri.parse(baseUrl),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> respuesta =
          jsonDecode(response.body);

      final List<dynamic> data =
          respuesta['data'];

      return data
          .map(
            (json) => Cita.fromMap(json),
          )
          .toList();
    }

    throw Exception(
      'Error al obtener citas: '
      '${response.statusCode} - '
      '${response.body}',
    );
  }

  /// Obtener una cita por ID.
  Future<Cita?> obtenerCitaPorId(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/$id'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> respuesta =
          jsonDecode(response.body);

      return Cita.fromMap(
        respuesta['data'],
      );
    }

    if (response.statusCode == 404) {
      return null;
    }

    throw Exception(
      'Error al obtener cita: '
      '${response.statusCode}',
    );
  }

  /// Crear una nueva cita.
  Future<Cita?> crearCita(Cita cita) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(
        cita.toMap(),
      ),
    );

    print(
      'STATUS CREAR CITA: '
      '${response.statusCode}',
    );

    print(
      'RESPUESTA CREAR CITA: '
      '${response.body}',
    );

    if (response.statusCode == 200 ||
        response.statusCode == 201) {
      final Map<String, dynamic> respuesta =
          jsonDecode(response.body);

      return Cita.fromMap(
        respuesta['data'],
      );
    }

    return null;
  }

  /// Actualizar una cita existente.
  Future<Cita?> actualizarCita(Cita cita) async {
    final url = '$baseUrl/${cita.idCita}';

    print(
      '========== ACTUALIZAR CITA ==========',
    );

    print('URL: $url');

    print(
      'JSON ENVIADO: '
      '${cita.toMap()}',
    );

    final response = await http.put(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(
        cita.toMap(),
      ),
    );

    print(
      'STATUS ACTUALIZAR CITA: '
      '${response.statusCode}',
    );

    print(
      'RESPUESTA ACTUALIZAR CITA: '
      '${response.body}',
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> respuesta =
          jsonDecode(response.body);

      return Cita.fromMap(
        respuesta['data'],
      );
    }

    return null;
  }

  /// Eliminar una cita.
  Future<bool> eliminarCita(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$id'),
    );

    return response.statusCode == 200;
  }
}