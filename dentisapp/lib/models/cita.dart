class Cita {
  final int? idCita;
  final DateTime fecha;
  final String estado;
  final int idPaciente;
  final int idOdontologo;

  Cita({
    this.idCita,
    required this.fecha,
    required this.estado,
    required this.idPaciente,
    required this.idOdontologo,
  });

  Map<String, dynamic> toMap() {
    return {
      'id_cita': idCita,
      'fecha': fecha.toIso8601String(),
      'estado': estado,
      'id_paciente': idPaciente,
      'id_odontologo': idOdontologo,
    };
  }

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