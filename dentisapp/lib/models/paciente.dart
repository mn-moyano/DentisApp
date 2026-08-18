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

  /// Convierte un objeto Paciente en JSON.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'nombres': nombres,
      'apellidos': apellidos,
      'cedula': cedula,
      'fechaNacimiento': fechaNacimiento?.toIso8601String(),
      'telefono': telefono,
      'correo': correo,
      'direccion': direccion,
    };

    // El ID solamente se envía cuando el paciente ya existe.
    if (idPaciente != null) {
      data['idPaciente'] = idPaciente;
    }

    return data;
  }

  /// Convierte JSON en objeto Paciente.
  factory Paciente.fromJson(Map<String, dynamic> json) {
    return Paciente(
      idPaciente:
          json['idPaciente'] ?? json['id_paciente'],

      nombres:
          json['nombres'] ?? json['nombre'] ?? '',

      apellidos:
          json['apellidos'] ?? json['apellido'] ?? '',

      cedula:
          json['cedula'] ?? '',

      fechaNacimiento:
          json['fechaNacimiento'] != null
              ? DateTime.tryParse(
                  json['fechaNacimiento'].toString(),
                )
              : (json['fecha_nacimiento'] != null
                  ? DateTime.tryParse(
                      json['fecha_nacimiento'].toString(),
                    )
                  : null),

      telefono:
          json['telefono']?.toString(),

      correo:
          json['correo']?.toString(),

      direccion:
          json['direccion']?.toString(),
    );
  }
}