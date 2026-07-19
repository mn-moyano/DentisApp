import '../models/tratamiento.dart';

/// Servicio local para administrar los tratamientos disponibles.
class TratamientoService {
  /// Lista en memoria con tratamientos de ejemplo.
  final List<Tratamiento> _tratamientos = [
    Tratamiento(
      idTratamiento: 1,
      descripcion: 'Limpieza dental',
      costo: 35.00,
    ),
    Tratamiento(
      idTratamiento: 2,
      descripcion: 'Resina dental',
      costo: 60.00,
    ),
    Tratamiento(
      idTratamiento: 3,
      descripcion: 'Extracción dental',
      costo: 80.00,
    ),
  ];

  /// Devuelve todos los tratamientos registrados localmente.
  List<Tratamiento> obtenerTratamientos() {
    return _tratamientos;
  }

  /// Busca un tratamiento por su identificador.
  Tratamiento? obtenerTratamientoPorId(int id) {
    try {
      return _tratamientos.firstWhere(
        (tratamiento) => tratamiento.idTratamiento == id,
      );
    } catch (_) {
      return null;
    }
  }

  /// Agrega un nuevo tratamiento a la lista local.
  void agregarTratamiento(Tratamiento tratamiento) {
    _tratamientos.add(tratamiento);
  }

  /// Actualiza un tratamiento existente.
  void actualizarTratamiento(Tratamiento tratamientoActualizado) {
    final index = _tratamientos.indexWhere(
      (t) => t.idTratamiento == tratamientoActualizado.idTratamiento,
    );

    if (index != -1) {
      _tratamientos[index] = tratamientoActualizado;
    }
  }

  /// Elimina un tratamiento por su identificador.
  void eliminarTratamiento(int id) {
    _tratamientos.removeWhere(
      (tratamiento) => tratamiento.idTratamiento == id,
    );
  }
}