/// Modelo que representa un tratamiento odontológico ofrecido.
class Tratamiento {
  /// Identificador único del tratamiento.
  final int? idTratamiento;

  /// Descripción del tratamiento.
  final String descripcion;

  /// Costo asociado al tratamiento.
  final double costo;

  Tratamiento({
    this.idTratamiento,
    required this.descripcion,
    required this.costo,
  });

  /// Convierte el tratamiento a un mapa de datos.
  Map<String, dynamic> toMap() {
    return {
      'id_tratamiento': idTratamiento,
      'descripcion': descripcion,
      'costo': costo,
    };
  }

  /// Crea un tratamiento desde un mapa recibido.
  factory Tratamiento.fromMap(Map<String, dynamic> map) {
    return Tratamiento(
      idTratamiento: map['id_tratamiento'],
      descripcion: map['descripcion'],
      costo: (map['costo'] as num).toDouble(),
    );
  }
}