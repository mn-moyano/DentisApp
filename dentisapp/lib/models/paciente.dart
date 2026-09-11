import 'package:json_annotation/json_annotation.dart';

part 'paciente.g.dart';

/// Modelo que representa a un paciente dentro del sistema odontológico.
@JsonSerializable()
class Paciente {
  final int? idPaciente;
  final String nombres;
  final String apellidos;
  final String cedula;
  final DateTime? fechaNacimiento;
  final String? telefono;
  final String? correo;
  final String? direccion;

  Paciente({
    this.idPaciente,
    required this.nombres,
    required this.apellidos,
    required this.cedula,
    this.fechaNacimiento,
    this.telefono,
    this.correo,
    this.direccion,
  });

  factory Paciente.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$PacienteFromJson(json);

  Map<String, dynamic> toJson() =>
      _$PacienteToJson(this);
}