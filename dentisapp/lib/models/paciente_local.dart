import 'paciente.dart';

class PacienteLocal {
  final int? idLocal;

  final int? idPaciente;

  final String clientId;

  final String nombres;

  final String apellidos;

  final String cedula;

  final DateTime? fechaNacimiento;

  final String? telefono;

  final String? correo;

  final String? direccion;

  final String syncStatus;

  final DateTime cachedAt;

  final DateTime? updatedAtServer;

  PacienteLocal({
    this.idLocal,
    this.idPaciente,
    required this.clientId,
    required this.nombres,
    required this.apellidos,
    required this.cedula,
    this.fechaNacimiento,
    this.telefono,
    this.correo,
    this.direccion,
    required this.syncStatus,
    required this.cachedAt,
    this.updatedAtServer,
  });

  factory PacienteLocal.fromMap(Map<String, dynamic> map) {
    return PacienteLocal(
      idLocal: map['id_local'],
      idPaciente: map['id_paciente'],
      clientId: map['client_id'],
      nombres: map['nombres'],
      apellidos: map['apellidos'],
      cedula: map['cedula'],
      fechaNacimiento: map['fecha_nacimiento'] == null
          ? null
          : DateTime.tryParse(
              map['fecha_nacimiento'].toString(),
            ),
      telefono: map['telefono'],
      correo: map['correo'],
      direccion: map['direccion'],
      syncStatus: map['sync_status'],
      cachedAt: DateTime.parse(
        map['cached_at'].toString(),
      ),
      updatedAtServer: map['updated_at_server'] == null
          ? null
          : DateTime.tryParse(
              map['updated_at_server'].toString(),
            ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_local': idLocal,
      'id_paciente': idPaciente,
      'client_id': clientId,
      'nombres': nombres,
      'apellidos': apellidos,
      'cedula': cedula,
      'fecha_nacimiento': fechaNacimiento?.toIso8601String(),
      'telefono': telefono,
      'correo': correo,
      'direccion': direccion,
      'sync_status': syncStatus,
      'cached_at': cachedAt.toIso8601String(),
      'updated_at_server': updatedAtServer?.toIso8601String(),
    };
  }

  Paciente toPaciente() {
    return Paciente(
      idPaciente: idPaciente,
      nombres: nombres,
      apellidos: apellidos,
      cedula: cedula,
      fechaNacimiento: fechaNacimiento,
      telefono: telefono,
      correo: correo,
      direccion: direccion,
    );
  }
}