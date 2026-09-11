// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'odontologo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Odontologo _$OdontologoFromJson(Map<String, dynamic> json) => Odontologo(
  idOdontologo: (json['idOdontologo'] as num?)?.toInt(),
  nombres: json['nombres'] as String,
  apellidos: json['apellidos'] as String,
  especialidad: json['especialidad'] as String,
  telefono: json['telefono'] as String?,
  correo: json['correo'] as String?,
  estado: json['estado'] as String? ?? 'Activo',
);

Map<String, dynamic> _$OdontologoToJson(Odontologo instance) =>
    <String, dynamic>{
      'idOdontologo': instance.idOdontologo,
      'nombres': instance.nombres,
      'apellidos': instance.apellidos,
      'especialidad': instance.especialidad,
      'telefono': instance.telefono,
      'correo': instance.correo,
      'estado': instance.estado,
    };
