import 'paciente.dart';

class PacienteLocal {

  final int? idLocal;

  final int? idPaciente;

  final String clientId;

  final String nombres;

  final String apellidos;

  final String cedula;

  final String? telefono;

  final String? correo;

  final String syncStatus;

  final DateTime? updatedAtServer;

  final DateTime cachedAt;

  PacienteLocal({
    this.idLocal,
    this.idPaciente,
    required this.clientId,
    required this.nombres,
    required this.apellidos,
    required this.cedula,
    this.telefono,
    this.correo,
    required this.syncStatus,
    this.updatedAtServer,
    required this.cachedAt,
  });

  Map<String, dynamic> toMap() {

    return {
      'id_local': idLocal,

      'id_paciente': idPaciente,

      'client_id': clientId,

      'nombres': nombres,

      'apellidos': apellidos,

      'cedula': cedula,

      'telefono': telefono,

      'correo': correo,

      'sync_status': syncStatus,

      'updated_at_server':
          updatedAtServer
              ?.toIso8601String(),

      'cached_at':
          cachedAt.toIso8601String(),
    };
  }

  factory PacienteLocal.fromMap(
    Map<String, dynamic> map,
  ) {

    return PacienteLocal(

      idLocal: map['id_local'],

      idPaciente:
          map['id_paciente'],

      clientId:
          map['client_id'],

      nombres:
          map['nombres'],

      apellidos:
          map['apellidos'],

      cedula:
          map['cedula'],

      telefono:
          map['telefono'],

      correo:
          map['correo'],

      syncStatus:
          map['sync_status'],

      updatedAtServer:
          map['updated_at_server'] != null
              ? DateTime.parse(
                  map[
                    'updated_at_server'
                  ],
                )
              : null,

      cachedAt:
          DateTime.parse(
            map['cached_at'],
          ),
    );
  }

  Paciente toPaciente() {

    return Paciente(
      idPaciente: idPaciente,

      nombres: nombres,

      apellidos: apellidos,

      cedula: cedula,

      telefono: telefono,

      correo: correo,
    );
  }
}