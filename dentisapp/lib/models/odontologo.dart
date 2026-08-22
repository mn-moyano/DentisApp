/// Modelo que representa a un odontólogo dentro del sistema.
class Odontologo {
  final int? idOdontologo;
  final String nombres;
  final String apellidos;
  final String especialidad;
  final String? telefono;
  final String? correo;
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

  /// Convierte el objeto a JSON para enviarlo a la API.
  Map<String, dynamic> toJson() {
    return {
      if (idOdontologo != null)
        'idOdontologo': idOdontologo,
      'nombres': nombres,
      'apellidos': apellidos,
      'especialidad': especialidad,
      'telefono': telefono,
      'correo': correo,
      'estado': estado,
    };
  }

  /// Crea un odontólogo a partir de la respuesta de la API.
  factory Odontologo.fromJson(
    Map<String, dynamic> json,
  ) {
    return Odontologo(
      idOdontologo: json['idOdontologo'],
      nombres: json['nombres'] ?? '',
      apellidos: json['apellidos'] ?? '',
      especialidad: json['especialidad'] ?? '',
      telefono: json['telefono'],
      correo: json['correo'],
      estado: json['estado'] ?? 'Activo',
    );
  }
}