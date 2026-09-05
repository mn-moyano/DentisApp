import 'package:uuid/uuid.dart';

import '../database/local_database.dart';
import '../models/paciente.dart';
import '../models/paciente_local.dart';

/// Servicio encargado de administrar los pacientes
/// almacenados localmente en SQLite.
///
/// Permite:
/// - Guardar datos obtenidos desde el servidor.
/// - Consultar pacientes sin conexión.
/// - Mantener el estado de sincronización.
/// - Obtener la fecha de la última actualización.
class PacienteLocalService {
  final LocalDatabase _localDatabase = LocalDatabase.instance;

  final Uuid _uuid = const Uuid();

  /// Nombre de la tabla de pacientes locales.
  static const String _table = 'pacientes_local';

  /// Guarda o actualiza pacientes obtenidos desde el servidor.
  ///
  /// Los pacientes que tengan operaciones pendientes no son
  /// sobrescritos para evitar perder cambios realizados offline.
  Future<void> guardarDesdeServidor(
    List<Paciente> pacientes,
  ) async {
    final db = await _localDatabase.database;

    final batch = db.batch();

    final ahora = DateTime.now().toUtc().toIso8601String();

    for (final paciente in pacientes) {
      final existente = await db.query(
        _table,
        where: 'id_paciente = ?',
        whereArgs: [paciente.idPaciente],
        limit: 1,
      );

      if (existente.isNotEmpty) {
        final estadoActual =
            existente.first['sync_status']?.toString();

        // No sobrescribir cambios realizados offline.
        if (estadoActual != 'pending_create' &&
            estadoActual != 'pending_update' &&
            estadoActual != 'pending_delete') {
          batch.update(
            _table,
            {
              'nombres': paciente.nombres,
              'apellidos': paciente.apellidos,
              'cedula': paciente.cedula,
              'fecha_nacimiento':
                  paciente.fechaNacimiento?.toIso8601String(),
              'telefono': paciente.telefono,
              'correo': paciente.correo,
              'direccion': paciente.direccion,
              'sync_status': 'synced',
              'updated_at_server': null,
              'cached_at': ahora,
            },
            where: 'id_paciente = ?',
            whereArgs: [paciente.idPaciente],
          );
        }
      } else {
        batch.insert(
          _table,
          {
            'id_paciente': paciente.idPaciente,
            'client_id': _uuid.v4(),
            'nombres': paciente.nombres,
            'apellidos': paciente.apellidos,
            'cedula': paciente.cedula,
            'fecha_nacimiento':
                paciente.fechaNacimiento?.toIso8601String(),
            'telefono': paciente.telefono,
            'correo': paciente.correo,
            'direccion': paciente.direccion,
            'sync_status': 'synced',
            'updated_at_server': null,
            'cached_at': ahora,
          },
        );
      }
    }

    await batch.commit(noResult: true);
  }

  /// Obtiene todos los pacientes almacenados localmente.
  ///
  /// Los pacientes marcados como pending_delete no se muestran
  /// en la interfaz mientras esperan la sincronización.
  Future<List<PacienteLocal>> obtenerPacientesLocales() async {
    final db = await _localDatabase.database;

    final resultado = await db.query(
      _table,
      where: 'sync_status != ?',
      whereArgs: ['pending_delete'],
      orderBy: 'nombres ASC, apellidos ASC',
    );

    return resultado
        .map(
          (map) => PacienteLocal.fromMap(map),
        )
        .toList();
  }

  /// Actualiza el estado de sincronización de un paciente.
  Future<void> actualizarEstadoSincronizacion({
    required String clientId,
    required String syncStatus,
    int? idPaciente,
    DateTime? updatedAtServer,
  }) async {
    final db = await _localDatabase.database;

    final valores = <String, dynamic>{
      'sync_status': syncStatus,
      'cached_at': DateTime.now().toUtc().toIso8601String(),
    };

    if (idPaciente != null) {
      valores['id_paciente'] = idPaciente;
    }

    if (updatedAtServer != null) {
      valores['updated_at_server'] =
          updatedAtServer.toUtc().toIso8601String();
    }

    await db.update(
      _table,
      valores,
      where: 'client_id = ?',
      whereArgs: [clientId],
    );
  }

  /// Busca un paciente local utilizando su clientId.
  Future<PacienteLocal?> obtenerPorClientId(
    String clientId,
  ) async {
    final db = await _localDatabase.database;

    final resultado = await db.query(
      _table,
      where: 'client_id = ?',
      whereArgs: [clientId],
      limit: 1,
    );

    if (resultado.isEmpty) {
      return null;
    }

    return PacienteLocal.fromMap(
      resultado.first,
    );
  }

  /// Busca un paciente utilizando su ID del servidor.
  Future<PacienteLocal?> obtenerPorIdServidor(
    int idPaciente,
  ) async {
    final db = await _localDatabase.database;

    final resultado = await db.query(
      _table,
      where: 'id_paciente = ?',
      whereArgs: [idPaciente],
      limit: 1,
    );

    if (resultado.isEmpty) {
      return null;
    }

    return PacienteLocal.fromMap(
      resultado.first,
    );
  }

  /// Actualiza los datos almacenados de un paciente.
  ///
  /// Se utilizará posteriormente para modificaciones realizadas
  /// sin conexión.
  Future<void> actualizarPacienteLocal(
    PacienteLocal paciente,
  ) async {
    final db = await _localDatabase.database;

    await db.update(
      _table,
      {
        'nombres': paciente.nombres,
        'apellidos': paciente.apellidos,
        'cedula': paciente.cedula,
        'fecha_nacimiento':
            paciente.fechaNacimiento?.toIso8601String(),
        'telefono': paciente.telefono,
        'correo': paciente.correo,
        'direccion': paciente.direccion,
        'sync_status': paciente.syncStatus,
        'updated_at_server':
            paciente.updatedAtServer?.toUtc().toIso8601String(),
        'cached_at':
            DateTime.now().toUtc().toIso8601String(),
      },
      where: 'client_id = ?',
      whereArgs: [paciente.clientId],
    );
  }

  /// Marca un paciente para eliminación.
  ///
  /// No lo elimina inmediatamente de SQLite porque primero
  /// debe sincronizarse la operación con el servidor.
  Future<void> marcarParaEliminar(
    String clientId,
  ) async {
    final db = await _localDatabase.database;

    await db.update(
      _table,
      {
        'sync_status': 'pending_delete',
        'cached_at':
            DateTime.now().toUtc().toIso8601String(),
      },
      where: 'client_id = ?',
      whereArgs: [clientId],
    );
  }

  /// Elimina físicamente un paciente local.
  ///
  /// Debe utilizarse después de que el servidor confirme
  /// correctamente la eliminación.
  Future<void> eliminarPacienteLocal(
    String clientId,
  ) async {
    final db = await _localDatabase.database;

    await db.delete(
      _table,
      where: 'client_id = ?',
      whereArgs: [clientId],
    );
  }

  /// Obtiene la fecha de la última actualización
  /// de la caché local.
  ///
  /// Esta fecha puede utilizarse en la interfaz para mostrar:
  ///
  /// "Datos actualizados hace X minutos".
  Future<DateTime?> obtenerUltimaActualizacion() async {
    final db = await _localDatabase.database;

    final resultado = await db.rawQuery('''
      SELECT MAX(cached_at) AS ultima
      FROM $_table
    ''');

    if (resultado.isEmpty) {
      return null;
    }

    final valor = resultado.first['ultima'];

    if (valor == null) {
      return null;
    }

    return DateTime.tryParse(
      valor.toString(),
    )?.toLocal();
  }

  /// Elimina todos los pacientes locales.
  ///
  /// Se utilizará principalmente durante el cierre de sesión.
  Future<void> eliminarTodosLosPacientes() async {
    final db = await _localDatabase.database;

    await db.delete(_table);
  }
}