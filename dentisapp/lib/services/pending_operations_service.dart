import 'dart:convert';

import 'package:uuid/uuid.dart';

import '../database/local_database.dart';
import '../models/paciente.dart';

/// Servicio encargado de administrar la cola de operaciones
/// pendientes de sincronización.
///
/// Permite:
/// - Registrar operaciones realizadas offline.
/// - Consultar operaciones pendientes.
/// - Eliminar operaciones sincronizadas.
/// - Registrar reintentos.
/// - Marcar pacientes como sincronizados.
class PendingOperationsService {
  PendingOperationsService({
    LocalDatabase? localDatabase,
    Uuid? uuid,
  })  : _localDatabase = localDatabase ?? LocalDatabase.instance,
        _uuid = uuid ?? const Uuid();

  final LocalDatabase _localDatabase;
  final Uuid _uuid;

  /// Registra la creación de un paciente realizada offline.
  ///
  /// La creación del paciente local y la operación pendiente
  /// se realizan dentro de una única transacción.
  ///
  /// Esto evita que exista el paciente local sin su operación
  /// pendiente, o viceversa.
  Future<String> enqueueCreatePaciente(
    Paciente paciente,
  ) async {
    final db = await _localDatabase.database;

    final operationId = _uuid.v4();
    final clientId = _uuid.v4();
    final ahora = DateTime.now().toUtc().toIso8601String();

    await db.transaction((transaction) async {
      await transaction.insert(
        'pacientes_local',
        {
          'id_paciente': paciente.idPaciente,
          'client_id': clientId,
          'nombres': paciente.nombres,
          'apellidos': paciente.apellidos,
          'cedula': paciente.cedula,
          'fecha_nacimiento': paciente.fechaNacimiento?.toIso8601String(),
          'telefono': paciente.telefono,
          'correo': paciente.correo,
          'direccion': paciente.direccion,
          'sync_status': 'pending_create',
          'updated_at_server': null,
          'cached_at': ahora,
        },
      );

      await transaction.insert(
        'pending_operations',
        {
          'operation_id': operationId,
          'entity_type': 'paciente',
          'entity_client_id': clientId,
          'operation_type': 'create',
          'payload': jsonEncode(
            paciente.toJson(),
          ),
          'retry_count': 0,
          'max_retries': 5,
          'next_retry_at': null,
          'created_at': ahora,
        },
      );
    });

    return operationId;
  }

  /// Obtiene las operaciones pendientes que ya pueden
  /// ser procesadas.
  ///
  /// Las operaciones con una fecha futura de reintento
  /// todavía no se devuelven.
  Future<List<Map<String, dynamic>>> obtenerPendientes() async {
    final db = await _localDatabase.database;

    final ahora = DateTime.now().toUtc().toIso8601String();

    return db.query(
      'pending_operations',
      where: 'next_retry_at IS NULL OR next_retry_at <= ?',
      whereArgs: [ahora],
      orderBy: 'created_at ASC',
    );
  }

  /// Elimina una operación de la cola.
  ///
  /// Debe ejecutarse después de que el servidor confirme
  /// correctamente la operación.
  Future<void> eliminar(
    String operationId,
  ) async {
    final db = await _localDatabase.database;

    await db.delete(
      'pending_operations',
      where: 'operation_id = ?',
      whereArgs: [operationId],
    );
  }

  /// Registra un intento fallido de sincronización.
  ///
  /// Utiliza un backoff exponencial:
  ///
  /// primer reintento -> 5 segundos
  /// segundo reintento -> 10 segundos
  /// tercer reintento -> 20 segundos
  /// cuarto reintento -> 40 segundos
  /// quinto reintento -> 80 segundos
  Future<void> registrarReintento(
    String operationId,
    int retryCount,
  ) async {
    final db = await _localDatabase.database;

    final delaySeconds = 5 * (1 << retryCount);

    final nextRetry = DateTime.now()
        .toUtc()
        .add(
          Duration(seconds: delaySeconds),
        )
        .toIso8601String();

    await db.update(
      'pending_operations',
      {
        'retry_count': retryCount,
        'next_retry_at': nextRetry,
      },
      where: 'operation_id = ?',
      whereArgs: [operationId],
    );
  }

  /// Marca un paciente como sincronizado después de que
  /// el servidor confirme su creación.
  ///
  /// También guarda el ID asignado por el servidor.
  Future<void> marcarPacienteSincronizado({
    required String clientId,
    required int idPaciente,
  }) async {
    final db = await _localDatabase.database;

    final ahora = DateTime.now().toUtc().toIso8601String();

    await db.update(
      'pacientes_local',
      {
        'id_paciente': idPaciente,
        'sync_status': 'synced',
        'updated_at_server': ahora,
        'cached_at': ahora,
      },
      where: 'client_id = ?',
      whereArgs: [clientId],
    );
  }
}