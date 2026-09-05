import 'dart:convert';

import 'package:uuid/uuid.dart';

import '../database/local_database.dart';
import '../models/paciente.dart';

class PendingOperationsService {
  PendingOperationsService({LocalDatabase? localDatabase, Uuid? uuid})
    : _localDatabase = localDatabase ?? LocalDatabase.instance,
      _uuid = uuid ?? const Uuid();

  final LocalDatabase _localDatabase;
  final Uuid _uuid;

  Future<String> enqueueCreatePaciente(Paciente paciente) async {
    final db = await _localDatabase.database;
    final operationId = _uuid.v4();
    final clientId = _uuid.v4();

    await db.transaction((transaction) async {
      await transaction.insert('pacientes_local', {
        'id_paciente': paciente.idPaciente,
        'client_id': clientId,
        'nombres': paciente.nombres,
        'apellidos': paciente.apellidos,
        'cedula': paciente.cedula,
        'telefono': paciente.telefono,
        'correo': paciente.correo,
        'direccion': paciente.direccion,
        'sync_status': 'pending_create',
        'updated_at_server': null,
        'cached_at': DateTime.now().toIso8601String(),
      });

      await transaction.insert('pending_operations', {
        'operation_id': operationId,
        'entity_type': 'paciente',
        'entity_client_id': clientId,
        'operation_type': 'create',
        'payload': jsonEncode(paciente.toJson()),
        'retry_count': 0,
        'max_retries': 5,
        'next_retry_at': null,
        'created_at': DateTime.now().toIso8601String(),
      });
    });

    return operationId;
  }

  Future<List<Map<String, dynamic>>> obtenerPendientes() async {
    final db = await _localDatabase.database;
    return db.query(
      'pending_operations',
      where: 'next_retry_at IS NULL OR next_retry_at <= ?',
      whereArgs: [DateTime.now().toIso8601String()],
      orderBy: 'created_at ASC',
    );
  }

  Future<void> eliminar(String operationId) async {
    final db = await _localDatabase.database;
    await db.delete(
      'pending_operations',
      where: 'operation_id = ?',
      whereArgs: [operationId],
    );
  }

  Future<void> registrarReintento(String operationId, int retryCount) async {
    final db = await _localDatabase.database;
    final nextRetry = DateTime.now()
        .add(Duration(seconds: 5 * (1 << retryCount)))
        .toIso8601String();

    await db.update(
      'pending_operations',
      {'retry_count': retryCount, 'next_retry_at': nextRetry},
      where: 'operation_id = ?',
      whereArgs: [operationId],
    );
  }

  Future<void> marcarPacienteSincronizado({
    required String clientId,
    required int idPaciente,
  }) async {
    final db = await _localDatabase.database;
    await db.update(
      'pacientes_local',
      {
        'id_paciente': idPaciente,
        'sync_status': 'synced',
        'updated_at_server': DateTime.now().toIso8601String(),
      },
      where: 'client_id = ?',
      whereArgs: [clientId],
    );
  }
}
