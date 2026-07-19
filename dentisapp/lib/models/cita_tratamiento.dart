/// Relación entre una cita y los tratamientos que se aplican en ella.
class CitaTratamiento {
  /// Identificador de la cita asociada.
  final int idCita;

  /// Identificador del tratamiento asignado.
  final int idTratamiento;

  CitaTratamiento({
    required this.idCita,
    required this.idTratamiento,
  });

  /// Convierte la relación a un mapa de datos.
  Map<String, dynamic> toMap() {
    return {
      'id_cita': idCita,
      'id_tratamiento': idTratamiento,
    };
  }

  /// Crea la relación desde un mapa recibido.
  factory CitaTratamiento.fromMap(Map<String, dynamic> map) {
    return CitaTratamiento(
      idCita: map['id_cita'],
      idTratamiento: map['id_tratamiento'],
    );
  }
}