import '../models/cita.dart';

class CitaService {

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

  /// Obtener todas las citas
  List<Cita> obtenerCitas() {
    return _citas;
  }

  /// Obtener cita por ID
  Cita? obtenerCitaPorId(int id) {
    try {
      return _citas.firstWhere(
        (cita) => cita.idCita == id,
      );
    } catch (_) {
      return null;
    }
  }

  /// Agregar cita
  void agregarCita(Cita cita) {
    _citas.add(cita);
  }

  /// Actualizar cita
  void actualizarCita(Cita citaActualizada) {
    final index = _citas.indexWhere(
      (c) => c.idCita == citaActualizada.idCita,
    );

    if (index != -1) {
      _citas[index] = citaActualizada;
    }
  }

  /// Eliminar cita
  void eliminarCita(int id) {
    _citas.removeWhere(
      (cita) => cita.idCita == id,
    );
  }

  /// Obtener citas de un paciente
  List<Cita> obtenerCitasPorPaciente(int idPaciente) {
    return _citas.where(
      (cita) => cita.idPaciente == idPaciente,
    ).toList();
  }

  /// Obtener citas de un odontólogo
  List<Cita> obtenerCitasPorOdontologo(int idOdontologo) {
    return _citas.where(
      (cita) => cita.idOdontologo == idOdontologo,
    ).toList();
  }

  /// Obtener citas por estado
  List<Cita> obtenerCitasPorEstado(String estado) {
    return _citas.where(
      (cita) => cita.estado == estado,
    ).toList();
  }
}