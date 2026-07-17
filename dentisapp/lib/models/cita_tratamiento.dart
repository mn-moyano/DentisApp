class CitaTratamiento {
  final int idCita;
  final int idTratamiento;

  CitaTratamiento({
    required this.idCita,
    required this.idTratamiento,
  });

  Map<String, dynamic> toMap() {
    return {
      'id_cita': idCita,
      'id_tratamiento': idTratamiento,
    };
  }

  factory CitaTratamiento.fromMap(Map<String, dynamic> map) {
    return CitaTratamiento(
      idCita: map['id_cita'],
      idTratamiento: map['id_tratamiento'],
    );
  }
}