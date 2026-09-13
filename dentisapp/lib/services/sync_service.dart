import 'dart:async';
import 'dart:convert';

import '../models/paciente.dart';
import 'api_client.dart';
import 'connectivity_service.dart';
import 'paciente_api_service.dart';
import 'paciente_local_service.dart';
import 'pending_operations_service.dart';

class SyncService {
  SyncService({
    PendingOperationsService? pendingOperations,
    PacienteApiService? pacientes,
    PacienteLocalService? pacientesLocal,
    ConnectivityService? connectivity,
  })  : _pendingOperations =
            pendingOperations ?? PendingOperationsService(),
        _pacientes = pacientes ?? PacienteApiService(),
        _pacientesLocal =
            pacientesLocal ?? PacienteLocalService(),
        _connectivity =
            connectivity ?? ConnectivityService();

  final PendingOperationsService _pendingOperations;
  final PacienteApiService _pacientes;
  final PacienteLocalService _pacientesLocal;
  final ConnectivityService _connectivity;

  StreamSubscription<bool>? _connectivitySubscription;

  bool _syncing = false;

  /// Inicia la escucha de cambios en la conexión.
  ///
  /// Cuando vuelve la conexión, se intenta sincronizar
  /// automáticamente la información pendiente.
  void iniciar() {
    _connectivitySubscription ??=
        _connectivity.estadoConexion.listen((connected) {
      if (connected) {
        sincronizar();
      }
    });

    // Intentar una sincronización inicial inmediatamente.
    sincronizar();
  }

  /// Procesa la sincronización completa.
  Future<void> sincronizar() async {
    final tieneConexion =
        await _connectivity.tieneConexion();

    if (_syncing || !tieneConexion) {
      return;
    }

    _syncing = true;

    try {
      // 1. Obtener operaciones pendientes.
      final operations =
          await _pendingOperations.obtenerPendientes();

      // 2. Procesar operaciones pendientes.
      for (final operation in operations) {
        await _procesar(operation);
      }

      // 3. Actualizar la caché local desde el servidor.
      await _actualizarCachePacientes();
    } finally {
      _syncing = false;
    }
  }

  /// Descarga los pacientes del servidor y actualiza
  /// la información almacenada localmente.
  Future<void> _actualizarCachePacientes() async {
    try {
      final pacientes =
          await _pacientes.obtenerPacientes();

      await _pacientesLocal.guardarDesdeServidor(
        pacientes,
      );
    } on ApiException {
      // Si falla la actualización de la caché,
      // se conserva la información local existente.
      return;
    }
  }

  /// Procesa una operación individual.
  ///
  /// En esta primera versión solamente se procesa
  /// la creación offline de pacientes.
  Future<void> _procesar(
    Map<String, dynamic> operation,
  ) async {
    final operationId =
        operation['operation_id'] as String;

    final retryCount =
        (operation['retry_count'] as int?) ?? 0;

    final maxRetries =
        (operation['max_retries'] as int?) ?? 5;

    try {
      // Por ahora solamente manejamos:
      // entidad = paciente
      // operación = create
      if (operation['entity_type'] != 'paciente' ||
          operation['operation_type'] != 'create') {
        await _pendingOperations.eliminar(
          operationId,
        );

        return;
      }

      final payload =
          jsonDecode(operation['payload'])
              as Map<String, dynamic>;

      final paciente =
          Paciente.fromJson(payload);

      final created =
          await _pacientes.crearPaciente(
        paciente,
      );

      if (created?.idPaciente == null) {
        throw const ApiException(
          'La API no devolvió el paciente creado.',
          statusCode: 502,
        );
      }

      final clientId =
          operation['entity_client_id'] as String;

      // Actualizamos el registro local con el ID
      // generado por el servidor.
      await _pendingOperations
          .marcarPacienteSincronizado(
        clientId: clientId,
        idPaciente: created!.idPaciente!,
      );

      // La operación ya fue procesada correctamente,
      // por lo que se elimina de la cola.
      await _pendingOperations.eliminar(
        operationId,
      );
    } on ApiException catch (error) {
      final siguienteIntento =
          retryCount + 1;

      // Errores 4xx, excepto 408, normalmente representan
      // problemas que no se solucionan simplemente reintentando.
      final errorPermanente =
          error.statusCode >= 400 &&
          error.statusCode < 500 &&
          error.statusCode != 408;

      // Si es un error permanente, dejamos
      // la operación en la cola.
      if (errorPermanente) {
        return;
      }

      if (siguienteIntento > maxRetries) {
        return;
      }

      await _pendingOperations.registrarReintento(
        operationId,
        siguienteIntento,
      );
    } on FormatException {
      // No se reintenta automáticamente porque
      // el problema está en los datos almacenados.
      return;
    }
  }

  /// Detiene la escucha de cambios de conectividad.
  Future<void> cerrar() async {
    await _connectivitySubscription?.cancel();

    _connectivitySubscription = null;
  }
}