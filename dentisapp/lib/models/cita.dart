/// Modelo que representa una cita médica del sistema.
class Cita {
  /// Identificador único de la cita.
  final int? idCita;

  /// Fecha y hora programada para la cita.
  final DateTime fecha;

  /// Estado de la cita, por ejemplo programada o atendida.
  final String estado;

  /// Identificador del paciente asociado a la cita.
  final int idPaciente;

  /// Identificador del odontólogo asignado a la cita.
  final int idOdontologo;

  Cita({
    this.idCita,
    required this.fecha,
    required this.estado,
    required this.idPaciente,
    required this.idOdontologo,
  });

  /// Convierte el modelo a un mapa para persistencia o envío.
  Map<String, dynamic> toMap() {
    return {
      'id_cita': idCita,
      'fecha': fecha.toIso8601String(),
      'estado': estado,
      'id_paciente': idPaciente,
      'id_odontologo': idOdontologo,
    };
  }

  /// Crea una instancia desde un mapa de datos.
  factory Cita.fromMap(Map<String, dynamic> map) {
    return Cita(
      idCita: map['id_cita'],
      fecha: DateTime.parse(map['fecha']),
      estado: map['estado'],
      idPaciente: map['id_paciente'],
      idOdontologo: map['id_odontologo'],
    );
  }
}