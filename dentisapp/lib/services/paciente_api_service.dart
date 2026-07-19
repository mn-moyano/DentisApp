import '../models/paciente.dart';

/// Servicio de acceso a datos para pacientes.
///
/// Aunque todavía no se conecta a la base de datos, este servicio define la
/// estructura que luego permitirá consumir la API de forma organizada.
class PacienteApiService {

  /// Obtiene la lista de pacientes desde la ruta esperada del backend.
  Future<List<Paciente>> obtenerPacientes() async {
    // Por ahora se devuelve una lista vacía hasta conectar la API.
    return [];
  }

  /// Obtiene un paciente por su identificador.
  Future<Paciente?> obtenerPacientePorId(int id) async {
    return null;
  }

  /// Envía un nuevo paciente al backend.
  Future<Paciente?> crearPaciente(Paciente paciente) async {
    return paciente;
  }

  /// Actualiza la información de un paciente existente.
  Future<Paciente?> actualizarPaciente(Paciente paciente) async {
    return paciente;
  }

  /// Elimina un paciente por su identificador.
  Future<bool> eliminarPaciente(int id) async {
    return true;
  }
}
