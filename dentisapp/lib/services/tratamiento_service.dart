import '../models/tratamiento.dart';

class TratamientoService {
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

  /// Obtener todos los tratamientos
  List<Tratamiento> obtenerTratamientos() {
    return _tratamientos;
  }

  /// Obtener tratamiento por ID
  Tratamiento? obtenerTratamientoPorId(int id) {
    try {
      return _tratamientos.firstWhere(
        (tratamiento) => tratamiento.idTratamiento == id,
      );
    } catch (_) {
      return null;
    }
  }

  /// Agregar tratamiento
  void agregarTratamiento(Tratamiento tratamiento) {
    _tratamientos.add(tratamiento);
  }

  /// Actualizar tratamiento
  void actualizarTratamiento(Tratamiento tratamientoActualizado) {
    final index = _tratamientos.indexWhere(
      (t) => t.idTratamiento == tratamientoActualizado.idTratamiento,
    );

    if (index != -1) {
      _tratamientos[index] = tratamientoActualizado;
    }
  }

  /// Eliminar tratamiento
  void eliminarTratamiento(int id) {
    _tratamientos.removeWhere(
      (tratamiento) => tratamiento.idTratamiento == id,
    );
  }
}