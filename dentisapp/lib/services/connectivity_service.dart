import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {

  final Connectivity _connectivity =
      Connectivity();

  Future<bool> tieneConexion() async {
    final resultado =
        await _connectivity.checkConnectivity();

    return resultado.any(
      (conexion) =>
          conexion != ConnectivityResult.none,
    );
  }

 Stream<bool> get estadoConexion {
  return _connectivity.onConnectivityChanged.map(
    (resultado) {
      final conectado = resultado.any(
        (conexion) =>
            conexion != ConnectivityResult.none,
      );

      print('🌐 CONECTIVIDAD: $resultado → conectado=$conectado');

      return conectado;
    },
  );
}}