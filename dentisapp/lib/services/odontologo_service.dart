import '../models/odontologo.dart';

class OdontologoService {

  final List<Odontologo> _odontologos = [

    Odontologo(
      idOdontologo: 1,
      nombre: 'Dr. Andrés Morales',
      especialidad: 'Ortodoncia',
      telefono: '0991111111',
      correo: 'amorales@dentisapp.com',
      estado: 'Activo',
    ),

    Odontologo(
      idOdontologo: 2,
      nombre: 'Dra. María López',
      especialidad: 'Endodoncia',
      telefono: '0992222222',
      correo: 'mlopez@dentisapp.com',
      estado: 'Activo',
    ),

    Odontologo(
      idOdontologo: 3,
      nombre: 'Dr. Carlos Sánchez',
      especialidad: 'Odontología General',
      telefono: '0993333333',
      correo: 'csanchez@dentisapp.com',
      estado: 'Inactivo',
    ),
  ];

  /// Obtener todos los odontólogos
  List<Odontologo> obtenerOdontologos() {
    return _odontologos;
  }

  /// Obtener odontólogo por ID
  Odontologo? obtenerOdontologoPorId(int id) {
    try {
      return _odontologos.firstWhere(
        (odontologo) => odontologo.idOdontologo == id,
      );
    } catch (_) {
      return null;
    }
  }

  /// Agregar odontólogo
  void agregarOdontologo(Odontologo odontologo) {
    _odontologos.add(odontologo);
  }

  /// Actualizar odontólogo
  void actualizarOdontologo(Odontologo odontologoActualizado) {
    final index = _odontologos.indexWhere(
      (o) => o.idOdontologo == odontologoActualizado.idOdontologo,
    );

    if (index != -1) {
      _odontologos[index] = odontologoActualizado;
    }
  }

  /// Eliminar odontólogo
  void eliminarOdontologo(int id) {
    _odontologos.removeWhere(
      (odontologo) => odontologo.idOdontologo == id,
    );
  }
}