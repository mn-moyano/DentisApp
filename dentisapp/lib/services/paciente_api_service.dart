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

    final data =
        response.data as Map<String, dynamic>;

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
    final statusCode = error.response?.statusCode;
    final responseData = error.response?.data;

    Map<String, dynamic>? errors;

    // Conservamos los errores de validación enviados por el backend.
    if (responseData is Map<String, dynamic>) {
      if (responseData['errors'] is Map<String, dynamic>) {
        errors =
            responseData['errors'] as Map<String, dynamic>;
      }
    }

    // 1. Errores de conectividad.
    if (error.type == DioExceptionType.connectionError) {
      return const ApiException(
        'No fue posible conectar con el servidor. Verifica tu conexión.',
      );
    }

    // 2. Errores de tiempo de espera.
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return const ApiException(
        'La solicitud tardó demasiado. Verifica tu conexión e inténtalo nuevamente.',
      );
    }

    // 3. Errores HTTP enviados por el backend.
    if (statusCode != null) {
      String message;

      switch (statusCode) {
        case 401:
          message =
              'Tu sesión ha expirado. Inicia sesión nuevamente.';
          break;

        case 403:
          message =
              'No tienes permisos para realizar esta operación.';
          break;

        case 404:
          message =
              'El recurso solicitado no fue encontrado.';
          break;

        case 422:
          message =
              'Los datos enviados no son válidos.';
          break;

        case 408:
          message =
              'El servidor tardó demasiado en responder.';
          break;

        case 429:
          message =
              'Se realizaron demasiadas solicitudes. Inténtalo nuevamente más tarde.';
          break;

        default:
          if (statusCode >= 500 && statusCode <= 599) {
            message =
                'El servidor presentó un problema. Inténtalo nuevamente más tarde.';
          } else {
            message =
                'El servidor rechazó la solicitud.';
          }
      }

      // Si el backend proporciona un mensaje,
      // lo conservamos cuando sea útil.
      if (responseData is Map<String, dynamic> &&
          responseData['message'] is String &&
          (responseData['message'] as String).isNotEmpty) {
        message = responseData['message'] as String;
      }

      return ApiException(
        message,
        statusCode: statusCode,
        errors: errors,
      );
    }

    // 4. Error inesperado de comunicación.
    return const ApiException(
      'Ocurrió un error inesperado de comunicación.',
    );
  }
}