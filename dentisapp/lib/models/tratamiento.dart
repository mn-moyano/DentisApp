class Tratamiento {
  final int? idTratamiento;
  final String descripcion;
  final double costo;

  Tratamiento({
    this.idTratamiento,
    required this.descripcion,
    required this.costo,
  });

  Map<String, dynamic> toMap() {
    return {
      'id_tratamiento': idTratamiento,
      'descripcion': descripcion,
      'costo': costo,
    };
  }

  factory Tratamiento.fromMap(Map<String, dynamic> map) {
    return Tratamiento(
      idTratamiento: map['id_tratamiento'],
      descripcion: map['descripcion'],
      costo: (map['costo'] as num).toDouble(),
    );
  }
}