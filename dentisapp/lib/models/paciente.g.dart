// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paciente.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Paciente _$PacienteFromJson(Map<String, dynamic> json) => Paciente(
  idPaciente: (json['idPaciente'] as num?)?.toInt(),
  nombres: json['nombres'] as String,
  apellidos: json['apellidos'] as String,
  cedula: json['cedula'] as String,
  fechaNacimiento: json['fechaNacimiento'] == null
      ? null
      : DateTime.parse(json['fechaNacimiento'] as String),
  telefono: json['telefono'] as String?,
  correo: json['correo'] as String?,
  direccion: json['direccion'] as String?,
);

Map<String, dynamic> _$PacienteToJson(Paciente instance) => <String, dynamic>{
  'idPaciente': instance.idPaciente,
  'nombres': instance.nombres,
  'apellidos': instance.apellidos,
  'cedula': instance.cedula,
  'fechaNacimiento': instance.fechaNacimiento?.toIso8601String(),
  'telefono': instance.telefono,
  'correo': instance.correo,
  'direccion': instance.direccion,
};
