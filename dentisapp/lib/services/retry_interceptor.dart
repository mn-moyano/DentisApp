import 'package:dio/dio.dart';

class RetryInterceptor extends Interceptor {
  RetryInterceptor({
    required this.dio,
    this.maxRetries = 2,
  });

  final Dio dio;
  final int maxRetries;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final request = err.requestOptions;

    // Solo reintentamos operaciones GET.
    if (request.method.toUpperCase() != 'GET') {
      handler.next(err);
      return;
    }

    // No reintentamos solicitudes que no sean errores temporales.
    if (!_esErrorReintentable(err)) {
      handler.next(err);
      return;
    }

    final retryCount =
        (request.extra['retryCount'] as int?) ?? 0;

    if (retryCount >= maxRetries) {
      handler.next(err);
      return;
    }

    request.extra['retryCount'] = retryCount + 1;

    try {
      final response = await dio.fetch(request);

      handler.resolve(response);
    } on DioException catch (error) {
      handler.next(error);
    }
  }

  bool _esErrorReintentable(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionError:
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return true;

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;

        return statusCode == 408 ||
            statusCode == 429 ||
            (statusCode != null &&
                statusCode >= 500 &&
                statusCode <= 599);

      default:
        return false;
    }
  }
}