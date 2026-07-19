/// Modelo que representa a un paciente dentro del sistema odontológico.
class Paciente {
  /// Identificador único del paciente.
  final int? idPaciente;

  /// Nombre del paciente.
  final String nombre;

  /// Apellido del paciente.
  final String apellido;

  /// Número de cédula.
  final String cedula;

  /// Fecha de nacimiento del paciente.
  final DateTime? fechaNacimiento;

  /// Teléfono de contacto.
  final String? telefono;

  /// Correo electrónico.
  final String? correo;

  /// Dirección de domicilio.
  final String? direccion;

  Paciente({
    this.idPaciente,
    required this.nombre,
    required this.apellido,
    required this.cedula,
    this.fechaNacimiento,
    this.telefono,
    this.correo,
    this.direccion,
  });

  /// Convierte el modelo a un mapa útil para almacenamiento o envío de datos.
  Map<String, dynamic> toMap() {
    return {
      'idPaciente': idPaciente,
      'nombre': nombre,
      'apellido': apellido,
      'cedula': cedula,
      'fechaNacimiento': fechaNacimiento?.toIso8601String(),
      'telefono': telefono,
      'direccion': direccion,
      'correo': correo,
    };
  }

  /// Crea una instancia del modelo desde un mapa de datos.
  factory Paciente.fromMap(Map<String, dynamic> map) {
    return Paciente(
      idPaciente: map['idPaciente'] ?? map['id_paciente'],
      nombre: map['nombre']?.toString() ?? '',
      apellido: map['apellido']?.toString() ?? '',
      cedula: map['cedula']?.toString() ?? '',
      fechaNacimiento: map['fechaNacimiento'] != null
          ? DateTime.parse(map['fechaNacimiento'].toString())
          : (map['fecha_nacimiento'] != null
              ? DateTime.parse(map['fecha_nacimiento'].toString())
              : null),
      telefono: map['telefono']?.toString(),
      direccion: map['direccion']?.toString(),
      correo: map['correo']?.toString(),
    );
  }
}


