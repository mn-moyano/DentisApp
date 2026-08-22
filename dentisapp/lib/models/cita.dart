/// Modelo que representa una cita médica del sistema.
class Cita {
  /// Identificador único de la cita.
  final int? idCita;

  /// Fecha y hora programada para la cita.
  final DateTime fechaHora;

  /// Motivo de la cita.
  final String motivo;

  /// Estado de la cita.
  final String estado;

  /// Identificador del paciente asociado.
  final int idPaciente;

  /// Identificador del odontólogo asignado.
  final int idOdontologo;

  Cita({
    this.idCita,
    required this.fechaHora,
    required this.motivo,
    required this.estado,
    required this.idPaciente,
    required this.idOdontologo,
  });

  /// Convierte el modelo a JSON para la API.
  Map<String, dynamic> toMap() {
    return {
      if (idCita != null) 'idCita': idCita,
      'fechaHora': fechaHora.toIso8601String(),
      'motivo': motivo,
      'estado': estado,
      'idPaciente': idPaciente,
      'idOdontologo': idOdontologo,
    };
  }

  /// Crea una instancia desde la respuesta de la API.
  factory Cita.fromMap(Map<String, dynamic> map) {
    return Cita(
      idCita: map['idCita'],
      fechaHora: DateTime.parse(
        map['fechaHora'].toString(),
      ),
      motivo: map['motivo']?.toString() ?? '',
      estado: map['estado']?.toString() ?? '',
      idPaciente: map['idPaciente'],
      idOdontologo: map['idOdontologo'],
    );
  }
}