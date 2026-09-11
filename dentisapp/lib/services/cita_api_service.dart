import 'package:dio/dio.dart';

import '../models/cita.dart';
import 'api_client.dart';

class CitaApiService {
  final Dio _dio = ApiClient.instance.dio;

  static const String baseUrl = '/api/citas';

  Future<List<Cita>> obtenerCitas() async {
    try {
      final response = await _dio.get(baseUrl);

      final data = response.data as Map<String, dynamic>;

      final lista = data['data'] as List<dynamic>;

      return lista
          .map(
            (json) => Cita.fromMap(
              json as Map<String, dynamic>,
            ),
          )
          .toList();
    } on DioException catch (error) {
      throw _convertirError(error);
    }
  }

  Future<Cita?> obtenerCitaPorId(int id) async {
    try {
      final response = await _dio.get('$baseUrl/$id');

      final data = response.data as Map<String, dynamic>;

      if (data['data'] == null) {
        return null;
      }

      return Cita.fromMap(
        data['data'] as Map<String, dynamic>,
      );
    } on DioException catch (error) {
      if (error.response?.statusCode == 404) {
        return null;
      }

      throw _convertirError(error);
    }
  }

  Future<Cita?> crearCita(Cita cita) async {
    try {
      final response = await _dio.post(
        baseUrl,
        data: cita.toMap(),
      );

      final data = response.data as Map<String, dynamic>;

      if (data['data'] == null) {
        return null;
      }

      return Cita.fromMap(
        data['data'] as Map<String, dynamic>,
      );
    } on DioException catch (error) {
      throw _convertirError(error);
    }
  }

  Future<Cita?> actualizarCita(Cita cita) async {
    try {
      final response = await _dio.put(
        '$baseUrl/${cita.idCita}',
        data: cita.toMap(),
      );

      final data = response.data as Map<String, dynamic>;

      if (data['data'] == null) {
        return null;
      }

      return Cita.fromMap(
        data['data'] as Map<String, dynamic>,
      );
    } on DioException catch (error) {
      throw _convertirError(error);
    }
  }

  Future<bool> eliminarCita(int id) async {
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

    if (responseData is Map<String, dynamic> &&
        responseData['message'] is String) {
      message = responseData['message'] as String;
    } else {
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
          break;
      }
    }

    return ApiException(
      message,
      statusCode: error.response?.statusCode ?? 0,
    );
  }
}