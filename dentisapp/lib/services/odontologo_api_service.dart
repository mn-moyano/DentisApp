import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/odontologo.dart';

class OdontologoApiService {
  static const String apiBaseUrl =
      String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:5133',
  );

  String get baseUrl =>
      '$apiBaseUrl/api/odontologos';

  /// Obtener todos los odontólogos.
  Future<List<Odontologo>> obtenerOdontologos() async {
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
            (json) => Odontologo.fromJson(json),
          )
          .toList();
    }

    throw Exception(
      'Error al obtener odontólogos: '
      '${response.statusCode} - '
      '${response.body}',
    );
  }

  /// Obtener odontólogo por ID.
  Future<Odontologo?> obtenerOdontologoPorId(
    int id,
  ) async {
    final response = await http.get(
      Uri.parse('$baseUrl/$id'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> respuesta =
          jsonDecode(response.body);

      return Odontologo.fromJson(
        respuesta['data'],
      );
    }

    if (response.statusCode == 404) {
      return null;
    }

    throw Exception(
      'Error al obtener odontólogo: '
      '${response.statusCode}',
    );
  }

  /// Crear odontólogo.
  Future<Odontologo?> crearOdontologo(
    Odontologo odontologo,
  ) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(
        odontologo.toJson(),
      ),
    );

    print(
      'STATUS CREAR ODONTÓLOGO: '
      '${response.statusCode}',
    );

    print(
      'RESPUESTA CREAR ODONTÓLOGO: '
      '${response.body}',
    );

    if (response.statusCode == 201) {
      final Map<String, dynamic> respuesta =
          jsonDecode(response.body);

      return Odontologo.fromJson(
        respuesta['data'],
      );
    }

    return null;
  }

  /// Actualizar odontólogo.
  Future<Odontologo?> actualizarOdontologo(
    Odontologo odontologo,
  ) async {
    final response = await http.put(
      Uri.parse(
        '$baseUrl/${odontologo.idOdontologo}',
      ),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(
        odontologo.toJson(),
      ),
    );

    print(
      'STATUS ACTUALIZAR ODONTÓLOGO: '
      '${response.statusCode}',
    );

    print(
      'RESPUESTA ACTUALIZAR ODONTÓLOGO: '
      '${response.body}',
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> respuesta =
          jsonDecode(response.body);

      return Odontologo.fromJson(
        respuesta['data'],
      );
    }

    return null;
  }

  /// Eliminar odontólogo.
  Future<bool> eliminarOdontologo(
    int id,
  ) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$id'),
    );

    return response.statusCode == 200;
  }
}