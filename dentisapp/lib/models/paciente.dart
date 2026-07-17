class Paciente {
  final int? idPaciente;
  final String nombre;
  final String apellido;
  final String cedula;
  final DateTime? fechaNacimiento;
  final String? telefono;
  final String? correo;
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

  /// Convierte un objeto Paciente a Map
  Map<String, dynamic> toMap() {
    return {
      'id_paciente': idPaciente,
      'nombre': nombre,
      'apellido': apellido,
      'cedula': cedula,
      'fecha_nacimiento': fechaNacimiento?.toIso8601String(),
      'telefono': telefono,
      'direccion': direccion,
      'correo': correo,
    };
  }

  /// Crea un objeto Paciente desde un Map
  factory Paciente.fromMap(Map<String, dynamic> map) {
    return Paciente(
      idPaciente: map['id_paciente'],
      nombre: map['nombre'],
      apellido: map['apellido'],
      cedula: map['cedula'],
      fechaNacimiento: map['fecha_nacimiento'] != null
          ? DateTime.parse(map['fecha_nacimiento'])
          : null,
      telefono: map['telefono'],
      direccion: map['direccion'],
      correo: map['correo'],
    );
  }
}


