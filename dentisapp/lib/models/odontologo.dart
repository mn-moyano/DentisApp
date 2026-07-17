class Odontologo {
  final int? idOdontologo;
  final String nombre;
  final String especialidad;
  final String? telefono;
  final String? correo;
  final String estado;

  Odontologo({
    this.idOdontologo,
    required this.nombre,
    required this.especialidad,
    this.telefono,
    this.correo,
    this.estado = 'Activo',
  });

  /// Convertir objeto a Map
  Map<String, dynamic> toMap() {
    return {
      'id_odontologo': idOdontologo,
      'nombre': nombre,
      'especialidad': especialidad,
      'telefono': telefono,
      'correo': correo,
      'estado': estado,
    };
  }

  /// Crear objeto desde Map
  factory Odontologo.fromMap(Map<String, dynamic> map) {
    return Odontologo(
      idOdontologo: map['id_odontologo'],
      nombre: map['nombre'],
      especialidad: map['especialidad'],
      telefono: map['telefono'],
      correo: map['correo'],
      estado: map['estado'] ?? 'Activo',
    );
  }
}