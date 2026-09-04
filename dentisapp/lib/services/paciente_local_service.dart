import 'package:uuid/uuid.dart';

import '../database/local_database.dart';
import '../models/paciente.dart';
import '../models/paciente_local.dart';

class PacienteLocalService {

  final LocalDatabase _localDatabase =
      LocalDatabase.instance;

  final Uuid _uuid = const Uuid();

  Future<void>
      guardarDesdeServidor(
    List<Paciente> pacientes,
  ) async {

    final db =
        await _localDatabase.database;

    final batch = db.batch();

    await db.delete(
      'pacientes_local',
    );

    final ahora =
        DateTime.now().toIso8601String();

    for (final paciente in pacientes) {

      batch.insert(
        'pacientes_local',
        {
          'id_paciente':
              paciente.idPaciente,

          'client_id':
              _uuid.v4(),

          'nombres':
              paciente.nombres,

          'apellidos':
              paciente.apellidos,

          'cedula':
              paciente.cedula,

          'telefono':
              paciente.telefono,

          'correo':
              paciente.correo,

          'sync_status':
              'synced',

          'updated_at_server':
              null,

          'cached_at':
              ahora,
        },
      );
    }

    await batch.commit(
      noResult: true,
    );
  }

  Future<List<PacienteLocal>>
      obtenerPacientesLocales() async {

    final db =
        await _localDatabase.database;

    final resultado =
        await db.query(
      'pacientes_local',
      orderBy: 'nombres ASC',
    );

    return resultado
        .map(
          (map) =>
              PacienteLocal.fromMap(map),
        )
        .toList();
  }

  Future<void>
      guardarPacientePendiente(
    Paciente paciente,
  ) async {

    final db =
        await _localDatabase.database;

    await db.insert(
      'pacientes_local',
      {
        'id_paciente': null,

        'client_id':
            _uuid.v4(),

        'nombres':
            paciente.nombres,

        'apellidos':
            paciente.apellidos,

        'cedula':
            paciente.cedula,

        'telefono':
            paciente.telefono,

        'correo':
            paciente.correo,

        'sync_status':
            'pending_create',

        'updated_at_server':
            null,

        'cached_at':
            DateTime.now()
                .toIso8601String(),
      },
    );
  }

  Future<DateTime?>
      obtenerUltimaActualizacion() async {

    final db =
        await _localDatabase.database;

    final resultado =
        await db.rawQuery('''
      SELECT MAX(cached_at) AS ultima
      FROM pacientes_local
    ''');

    final valor =
        resultado.first['ultima'];

    if (valor == null) {
      return null;
    }

    return DateTime.parse(
      valor.toString(),
    );
  }
}