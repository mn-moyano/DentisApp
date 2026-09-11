import 'package:json_annotation/json_annotation.dart';

part 'odontologo.g.dart';

/// Modelo que representa a un odontólogo dentro del sistema.
@JsonSerializable()
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

  factory Odontologo.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$OdontologoFromJson(json);

  Map<String, dynamic> toJson() =>
      _$OdontologoToJson(this);
}