import 'dart:async';
import 'dart:convert';

import '../models/paciente.dart';
import 'api_client.dart';
import 'connectivity_service.dart';
import 'paciente_api_service.dart';
import 'paciente_local_service.dart';
import 'pending_operations_service.dart';
import 'notification_service.dart';

class SyncService {
  SyncService({
    PendingOperationsService? pendingOperations,
    PacienteApiService? pacientes,
    PacienteLocalService? pacientesLocal,
    ConnectivityService? connectivity,
    NotificationService? notificationService,
  })  : _pendingOperations =
            pendingOperations ?? PendingOperationsService(),
        _pacientes = pacientes ?? PacienteApiService(),
        _pacientesLocal =
            pacientesLocal ?? PacienteLocalService(),
        _connectivity =
            connectivity ?? ConnectivityService(),
        _notifications =
            notificationService ?? NotificationService.instance;

  final PendingOperationsService _pendingOperations;
  final PacienteApiService _pacientes;
  final PacienteLocalService _pacientesLocal;
  final ConnectivityService _connectivity;
  final NotificationService _notifications;

  StreamSubscription<bool>? _connectivitySubscription;

  bool _syncing = false;

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

  Future<void> sincronizar() async {
    final tieneConexion =
        await _connectivity.tieneConexion();

    if (_syncing || !tieneConexion) {
      return;
    }

    _syncing = true;

    try {
      final operations =
          await _pendingOperations.obtenerPendientes();

      for (final operation in operations) {
        await _procesar(operation);
      }

      await _actualizarCachePacientes();
    } finally {
      _syncing = false;
    }
  }

  Future<void> _actualizarCachePacientes() async {
    try {
      final pacientes =
          await _pacientes.obtenerPacientes();

      await _pacientesLocal.guardarDesdeServidor(
        pacientes,
      );
    } on ApiException {
      return;
    }
  }

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

      await _pendingOperations
          .marcarPacienteSincronizado(
        clientId: clientId,
        idPaciente: created!.idPaciente!,
      );

      await _pendingOperations.eliminar(
        operationId,
      );

      // Notificar que la sincronización fue exitosa.
      await _notifications.mostrarNotificacion(
        id: 3,
        titulo: 'DentisApp',
        mensaje: 'Paciente sincronizado correctamente.',
      );
    } on ApiException catch (error) {
      final siguienteIntento =
          retryCount + 1;

      final errorPermanente =
          error.statusCode >= 400 &&
          error.statusCode < 500 &&
          error.statusCode != 408;

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
      return;
    }
  }

  Future<void> cerrar() async {
    await _connectivitySubscription?.cancel();

    _connectivitySubscription = null;
  }
}