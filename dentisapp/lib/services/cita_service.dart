import '../models/cita.dart';

/// Servicio local para gestionar las citas del sistema.
class CitaService {
  /// Lista en memoria con ejemplos iniciales de citas.
  final List<Cita> _citas = [
    Cita(
      idCita: 1,
      fecha: DateTime(2026, 7, 20, 9, 0),
      estado: 'Programada',
      idPaciente: 1,
      idOdontologo: 1,
    ),
    Cita(
      idCita: 2,
      fecha: DateTime(2026, 7, 20, 10, 30),
      estado: 'Atendida',
      idPaciente: 2,
      idOdontologo: 2,
    ),
    Cita(
      idCita: 3,
      fecha: DateTime(2026, 7, 21, 14, 0),
      estado: 'Cancelada',
      idPaciente: 3,
      idOdontologo: 1,
    ),
  ];

  /// Devuelve todas las citas registradas localmente.
  List<Cita> obtenerCitas() {
    return _citas;
  }

  /// Busca una cita por su identificador.
  Cita? obtenerCitaPorId(int id) {
    try {
      return _citas.firstWhere(
        (cita) => cita.idCita == id,
      );
    } catch (_) {
      return null;
    }
  }

  /// Agrega una nueva cita a la lista local.
  void agregarCita(Cita cita) {
    _citas.add(cita);
  }

  /// Actualiza una cita existente.
  void actualizarCita(Cita citaActualizada) {
    final index = _citas.indexWhere(
      (c) => c.idCita == citaActualizada.idCita,
    );

    if (index != -1) {
      _citas[index] = citaActualizada;
    }
  }

  /// Elimina una cita por su identificador.
  void eliminarCita(int id) {
    _citas.removeWhere(
      (cita) => cita.idCita == id,
    );
  }

  /// Obtiene todas las citas asociadas a un paciente.
  List<Cita> obtenerCitasPorPaciente(int idPaciente) {
    return _citas.where(
      (cita) => cita.idPaciente == idPaciente,
    ).toList();
  }

  /// Obtiene todas las citas asignadas a un odontólogo.
  List<Cita> obtenerCitasPorOdontologo(int idOdontologo) {
    return _citas.where(
      (cita) => cita.idOdontologo == idOdontologo,
    ).toList();
  }

  /// Filtra las citas según su estado.
  List<Cita> obtenerCitasPorEstado(String estado) {
    return _citas.where(
      (cita) => cita.estado == estado,
    ).toList();
  }
}