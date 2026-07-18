import '../models/paciente.dart';

class PacienteService {

  final List<Paciente> _pacientes = [
    Paciente(
      idPaciente: 1,
      nombre: 'Juan',
      apellido: 'Pérez',
      cedula: '1234567890',
      fechaNacimiento: DateTime(1990, 1, 1),
      telefono: '0991234567',
      direccion: 'Av. Quito',
      correo: 'juan@gmail.com',
    ),
    Paciente(
      idPaciente: 2,
      nombre: 'María',
      apellido: 'Gómez',
      cedula: '0987654321',
      fechaNacimiento: DateTime(1992, 5, 15),
      telefono: '0987654321',
      direccion: 'Av. Amazonas',
      correo: 'maria@gmail.com',
    ),
    Paciente(
      idPaciente: 3,
      nombre: 'Carlos',
      apellido: 'Rodríguez',
      cedula: '1122334455',
      fechaNacimiento: DateTime(1988, 8, 10),
      telefono: '0977777777',
      direccion: 'La Concordia',
      correo: 'carlos@gmail.com',
    ),
  ];

  /// Obtener todos los pacientes
  List<Paciente> obtenerPacientes() {
    return _pacientes;
  }

  /// Buscar paciente por ID
  Paciente? obtenerPacientePorId(int id) {
    try {
      return _pacientes.firstWhere(
        (paciente) => paciente.idPaciente == id,
      );
    } catch (_) {
      return null;
    }
  }

  /// Agregar paciente
  void agregarPaciente(Paciente paciente) {
    _pacientes.add(paciente);
  }

  /// Actualizar paciente
  void actualizarPaciente(Paciente pacienteActualizado) {
    final index = _pacientes.indexWhere(
      (p) => p.idPaciente == pacienteActualizado.idPaciente,
    );

    if (index != -1) {
      _pacientes[index] = pacienteActualizado;
    }
  }

  /// Eliminar paciente
  void eliminarPaciente(int id) {
    _pacientes.removeWhere(
      (paciente) => paciente.idPaciente == id,
    );
  }
}