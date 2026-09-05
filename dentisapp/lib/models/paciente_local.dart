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
  final DateTime? updatedAtServer;
  final DateTime cachedAt;

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
    this.updatedAtServer,
    required this.cachedAt,
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
          : DateTime.tryParse(map['fecha_nacimiento'].toString()),
      telefono: map['telefono'],
      correo: map['correo'],
      direccion: map['direccion'],
      syncStatus: map['sync_status'],
      updatedAtServer: map['updated_at_server'] == null
          ? null
          : DateTime.tryParse(map['updated_at_server'].toString()),
      cachedAt: DateTime.parse(map['cached_at'].toString()),
    );
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
