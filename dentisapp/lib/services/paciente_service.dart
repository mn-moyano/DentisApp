import '../models/paciente.dart';

/// Servicio local para gestionar pacientes en la aplicación.
class PacienteService {
  /// Lista en memoria que simula los datos del sistema.
  final List<Paciente> _pacientes = [
    Paciente(
      idPaciente: 1,
      nombres: 'Juan',
      apellidos: 'Pérez',
      cedula: '1234567890',
      fechaNacimiento: DateTime(1990, 1, 1),
      telefono: '0991234567',
      direccion: 'Av. Quito',
      correo: 'juan@gmail.com',
    ),
    Paciente(
      idPaciente: 2,
      nombres: 'María',
      apellidos: 'Gómez',
      cedula: '0987654321',
      fechaNacimiento: DateTime(1992, 5, 15),
      telefono: '0987654321',
      direccion: 'Av. Amazonas',
      correo: 'maria@gmail.com',
    ),
    Paciente(
      idPaciente: 3,
      nombres: 'Carlos',
      apellidos: 'Rodríguez',
      cedula: '1122334455',
      fechaNacimiento: DateTime(1988, 8, 10),
      telefono: '0977777777',
      direccion: 'La Concordia',
      correo: 'carlos@gmail.com',
    ),
  ];

  /// Devuelve todos los pacientes registrados localmente.
  List<Paciente> obtenerPacientes() {
    return _pacientes;
  }

  /// Busca un paciente por su identificador.
  Paciente? obtenerPacientePorId(int id) {
    try {
      return _pacientes.firstWhere(
        (paciente) => paciente.idPaciente == id,
      );
    } catch (_) {
      return null;
    }
  }

  /// Agrega un nuevo paciente a la lista en memoria.
  void agregarPaciente(Paciente paciente) {
    _pacientes.add(paciente);
  }

  /// Actualiza la información de un paciente existente.
  void actualizarPaciente(Paciente pacienteActualizado) {
    final index = _pacientes.indexWhere(
      (p) => p.idPaciente == pacienteActualizado.idPaciente,
    );

    if (index != -1) {
      _pacientes[index] = pacienteActualizado;
    }
  }

  /// Elimina un paciente por su identificador.
  void eliminarPaciente(int id) {
    _pacientes.removeWhere(
      (paciente) => paciente.idPaciente == id,
    );
  }
}