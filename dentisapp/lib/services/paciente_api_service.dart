import 'package:dio/dio.dart';

import '../models/paciente.dart';
import 'api_client.dart';

class PacienteApiService {
  final Dio _dio = ApiClient.instance.dio;

  static const String baseUrl = '/api/pacientes';

  Future<List<Paciente>> obtenerPacientes() async {
    try {
      final response = await _dio.get(baseUrl);

      final data = response.data as Map<String, dynamic>;

      final lista = data['data'] as List<dynamic>;

      return lista
          .map(
            (json) => Paciente.fromJson(
              json as Map<String, dynamic>,
            ),
          )
          .toList();
    } on DioException catch (error) {
      throw _convertirError(error);
    }
  }

  Future<Paciente?> crearPaciente(
    Paciente paciente,
  ) async {
    try {
      final response = await _dio.post(
        baseUrl,
        data: paciente.toJson(),
      );

      final data = response.data as Map<String, dynamic>;

      if (data['data'] == null) {
        return null;
      }

      return Paciente.fromJson(
        data['data'] as Map<String, dynamic>,
      );
    } on DioException catch (error) {
      throw _convertirError(error);
    }
  }

  Future<Paciente?> actualizarPaciente(
    Paciente paciente,
  ) async {
    try {
      final response = await _dio.put(
        '$baseUrl/${paciente.idPaciente}',
        data: paciente.toJson(),
      );

      final data = response.data as Map<String, dynamic>;

      if (data['data'] == null) {
        return null;
      }

      return Paciente.fromJson(
        data['data'] as Map<String, dynamic>,
      );
    } on DioException catch (error) {
      throw _convertirError(error);
    }
  }

  Future<bool> eliminarPaciente(int id) async {
    try {
      await _dio.delete('$baseUrl/$id');

      return true;
    } on DioException catch (error) {
      throw _convertirError(error);
    }
  }

  ApiException _convertirError(
    DioException error,
  ) {
    final responseData = error.response?.data;

    String message =
        'No fue posible comunicarse con el servidor.';

    Map<String, dynamic>? errors;

    // Errores enviados por el backend.
    if (responseData is Map<String, dynamic>) {
      if (responseData['message'] is String) {
        message = responseData['message'] as String;
      }

      if (responseData['errors'] is Map<String, dynamic>) {
        errors =
            responseData['errors'] as Map<String, dynamic>;
      }
    }

    // Errores relacionados con la conexión.
    if (responseData == null) {
      switch (error.type) {
        case DioExceptionType.connectionError:
          message =
              'No fue posible conectar con el servidor.';
          break;

        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          message =
              'La solicitud tardó demasiado. Verifica tu conexión.';
          break;

        default:
          message =
              'Ocurrió un error inesperado de comunicación.';
          break;
      }
    }

    return ApiException(
      message,
      statusCode: error.response?.statusCode ?? 0,
      errors: errors,
    );
  }
}