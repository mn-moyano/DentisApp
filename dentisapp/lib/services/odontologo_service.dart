import '../models/odontologo.dart';

/// Servicio local para administrar los odontólogos del sistema.
class OdontologoService {
  /// Lista en memoria con profesionales de ejemplo.
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

  /// Devuelve todos los odontólogos disponibles.
  List<Odontologo> obtenerOdontologos() {
    return _odontologos;
  }

  /// Busca un odontólogo por su identificador.
  Odontologo? obtenerOdontologoPorId(int id) {
    try {
      return _odontologos.firstWhere(
        (odontologo) => odontologo.idOdontologo == id,
      );
    } catch (_) {
      return null;
    }
  }

  /// Agrega un odontólogo nuevo a la lista local.
  void agregarOdontologo(Odontologo odontologo) {
    _odontologos.add(odontologo);
  }

  /// Actualiza la información de un odontólogo existente.
  void actualizarOdontologo(Odontologo odontologoActualizado) {
    final index = _odontologos.indexWhere(
      (o) => o.idOdontologo == odontologoActualizado.idOdontologo,
    );

    if (index != -1) {
      _odontologos[index] = odontologoActualizado;
    }
  }

  /// Elimina un odontólogo por su identificador.
  void eliminarOdontologo(int id) {
    _odontologos.removeWhere(
      (odontologo) => odontologo.idOdontologo == id,
    );
  }
}