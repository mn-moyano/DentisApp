import '../models/paciente.dart';
import '../services/connectivity_service.dart';
import '../services/paciente_api_service.dart';
import '../services/paciente_local_service.dart';
import '../services/pending_operations_service.dart';

class PacienteRepositoryResult {
  const PacienteRepositoryResult({
    required this.pacientes,
    required this.offline,
    this.cacheTimestamp,
  });

  final List<Paciente> pacientes;
  final bool offline;
  final DateTime? cacheTimestamp;
}

class PacienteRepository {
  PacienteRepository({
    PacienteApiService? remote,
    PacienteLocalService? local,
    PendingOperationsService? pendingOperations,
    ConnectivityService? connectivity,
  })  : _remote = remote ?? PacienteApiService(),
        _local = local ?? PacienteLocalService(),
        _pendingOperations =
            pendingOperations ?? PendingOperationsService(),
        _connectivity = connectivity ?? ConnectivityService();

  final PacienteApiService _remote;
  final PacienteLocalService _local;
  final PendingOperationsService _pendingOperations;
  final ConnectivityService _connectivity;

  /// Obtiene pacientes.
  ///
  /// Si existe conexión, consulta la API y actualiza
  /// la caché local.
  ///
  /// Si no existe conexión, utiliza los datos almacenados
  /// en SQLite.
  Future<List<Paciente>> obtenerPacientes() async {
    final tieneConexion =
        await _connectivity.tieneConexion();

    if (!tieneConexion) {
      return _obtenerDesdeLocal();
    }

    final pacientes =
        await _remote.obtenerPacientes();

    await _local.guardarDesdeServidor(
      pacientes,
    );

    return pacientes;
  }

  Future<PacienteRepositoryResult> obtenerPacientesConEstado() async {
    final tieneConexion =
        await _connectivity.tieneConexion();

    if (!tieneConexion) {
      final pacientes = await _obtenerDesdeLocal();

      final timestamp =
          await _local.obtenerUltimaActualizacion();

      return PacienteRepositoryResult(
        pacientes: pacientes,
        offline: true,
        cacheTimestamp: timestamp,
      );
    }

    final pacientes =
        await _remote.obtenerPacientes();

    await _local.guardarDesdeServidor(
      pacientes,
    );

    return PacienteRepositoryResult(
      pacientes: pacientes,
      offline: false,
      cacheTimestamp: null,
    );
  }

  /// Obtiene pacientes exclusivamente desde SQLite.
  Future<List<Paciente>> _obtenerDesdeLocal() async {
    final locales =
        await _local.obtenerPacientesLocales();

    return locales
        .map((paciente) => paciente.toPaciente())
        .toList();
  }

  /// Crea un paciente.
  ///
  /// Con conexión, la creación se realiza inmediatamente
  /// en el servidor.
  ///
  /// Sin conexión, se almacena localmente y se agrega
  /// a la cola de sincronización.
  Future<Paciente?> crearPaciente(
    Paciente paciente,
  ) async {
    final tieneConexion =
        await _connectivity.tieneConexion();

    if (tieneConexion) {
      final creado =
          await _remote.crearPaciente(paciente);

      if (creado != null) {
        await _local.guardarDesdeServidor(
          [creado],
        );
      }

      return creado;
    }

    await _pendingOperations.enqueueCreatePaciente(
      paciente,
    );

    return paciente;
  }

  /// Actualiza un paciente directamente en el servidor.
  ///
  /// Las actualizaciones offline todavía se gestionan
  /// mediante la lógica específica de sincronización.
  Future<Paciente?> actualizarPaciente(
    Paciente paciente,
  ) async {
    final actualizado =
        await _remote.actualizarPaciente(paciente);

    if (actualizado != null) {
      await _local.guardarDesdeServidor(
        [actualizado],
      );
    }

    return actualizado;
  }

  /// Elimina un paciente del servidor.
  Future<bool> eliminarPaciente(int id) async {
    final eliminado =
        await _remote.eliminarPaciente(id);

    if (eliminado) {
      final local =
          await _local.obtenerPorIdServidor(id);

      if (local != null) {
        await _local.eliminarPacienteLocal(
          local.clientId,
        );
      }
    }

    return eliminado;
  }

  /// Obtiene la fecha de actualización de la caché.
  Future<DateTime?> obtenerUltimaActualizacion() {
    return _local.obtenerUltimaActualizacion();
  }
}