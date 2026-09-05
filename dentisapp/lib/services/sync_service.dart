import 'dart:async';
import 'dart:convert';

import '../models/paciente.dart';
import 'api_client.dart';
import 'connectivity_service.dart';
import 'paciente_api_service.dart';
import 'pending_operations_service.dart';

class SyncService {
  SyncService({
    PendingOperationsService? pendingOperations,
    PacienteApiService? pacientes,
    ConnectivityService? connectivity,
  }) : _pendingOperations = pendingOperations ?? PendingOperationsService(),
       _pacientes = pacientes ?? PacienteApiService(),
       _connectivity = connectivity ?? ConnectivityService();

  final PendingOperationsService _pendingOperations;
  final PacienteApiService _pacientes;
  final ConnectivityService _connectivity;
  StreamSubscription<bool>? _connectivitySubscription;
  bool _syncing = false;

  void iniciar() {
    _connectivitySubscription ??= _connectivity.estadoConexion.listen((
      connected,
    ) {
      if (connected) {
        sincronizar();
      }
    });
  }

  Future<void> sincronizar() async {
    if (_syncing || !await _connectivity.tieneConexion()) return;
    _syncing = true;

    try {
      final operations = await _pendingOperations.obtenerPendientes();
      for (final operation in operations) {
        await _procesar(operation);
      }
    } finally {
      _syncing = false;
    }
  }

  Future<void> _procesar(Map<String, dynamic> operation) async {
    final operationId = operation['operation_id'] as String;
    final retryCount = (operation['retry_count'] as int?) ?? 0;
    final maxRetries = (operation['max_retries'] as int?) ?? 5;

    try {
      if (operation['entity_type'] != 'paciente' ||
          operation['operation_type'] != 'create') {
        await _pendingOperations.eliminar(operationId);
        return;
      }

      final payload = jsonDecode(operation['payload']) as Map<String, dynamic>;
      final created = await _pacientes.crearPaciente(
        Paciente.fromJson(payload),
      );

      if (created?.idPaciente == null) {
        throw const ApiException(
          'La API no devolvió el paciente creado.',
          statusCode: 502,
        );
      }

      await _pendingOperations.marcarPacienteSincronizado(
        clientId: operation['entity_client_id'] as String,
        idPaciente: created!.idPaciente!,
      );
      await _pendingOperations.eliminar(operationId);
    } on ApiException catch (error) {
      if (retryCount + 1 >= maxRetries ||
          (error.statusCode >= 400 && error.statusCode != 408)) {
        return;
      }
      await _pendingOperations.registrarReintento(operationId, retryCount + 1);
    }
  }

  Future<void> cerrar() async {
    await _connectivitySubscription?.cancel();
    _connectivitySubscription = null;
  }
}
