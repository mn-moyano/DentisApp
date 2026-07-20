/// Modelo que representa a un paciente dentro del sistema odontológico.
class Paciente {
  final int? idPaciente;
  final String nombres;
  final String apellidos;
  final String cedula;
  final DateTime? fechaNacimiento;
  final String? telefono;
  final String? correo;
  final String? direccion;

  Paciente({
    this.idPaciente,
    required this.nombres,
    required this.apellidos,
    required this.cedula,
    this.fechaNacimiento,
    this.telefono,
    this.correo,
    this.direccion,
  });

  /// Convierte un objeto Paciente en JSON
  Map<String, dynamic> toJson() {
    return {
      'idPaciente': idPaciente,
      'nombre': nombres,
      'apellido': apellidos,
      'cedula': cedula,
      'fechaNacimiento': fechaNacimiento?.toIso8601String(),
      'telefono': telefono,
      'direccion': direccion,
      'correo': correo,
    };
  }

  /// Convierte JSON en objeto Paciente
  factory Paciente.fromJson(Map<String, dynamic> json) {
    return Paciente(
      idPaciente: json['idPaciente'] ?? json['id_paciente'],
      nombres: json['nombre'] ?? '',
      apellidos: json['apellido'] ?? '',
      cedula: json['cedula'] ?? '',
      fechaNacimiento: json['fechaNacimiento'] != null
          ? DateTime.parse(json['fechaNacimiento'])
          : (json['fecha_nacimiento'] != null
              ? DateTime.parse(json['fecha_nacimiento'])
              : null),
      telefono: json['telefono'],
      direccion: json['direccion'],
      correo: json['correo'],
    );
  }
}
