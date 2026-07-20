/// Modelo que representa a un odontólogo dentro del sistema.
class Odontologo {
  /// Identificador único del odontólogo.
  final int? idOdontologo;

  /// Nombre completo del profesional.
  final String nombres;

  final String apellidos;

  /// Especialidad del odontólogo.
  final String especialidad;

  /// Teléfono de contacto.
  final String? telefono;

  /// Correo electrónico.
  final String? correo;

  /// Estado actual del profesional.
  final String estado;

  Odontologo({
    this.idOdontologo,
    required this.nombres,
    required this.apellidos,
    required this.especialidad,
    this.telefono,
    this.correo,
    this.estado = 'Activo',
  });

  /// Convierte el objeto a un mapa para su uso en almacenamiento o API.
  Map<String, dynamic> toMap() {
    return {
      'id_odontologo': idOdontologo,
      'nombre': nombres,
      'apellido': apellidos,
      'especialidad': especialidad,
      'telefono': telefono,
      'correo': correo,
      'estado': estado,
    };
  }

  /// Crea una instancia del modelo desde un mapa de datos.
  factory Odontologo.fromMap(Map<String, dynamic> map) {
    return Odontologo(
      idOdontologo: map['id_odontologo'],
      nombres: map['nombre'],
      apellidos: map['apellido'],
      especialidad: map['especialidad'],
      telefono: map['telefono'],
      correo: map['correo'],
      estado: map['estado'] ?? 'Activo',
    );
  }
}