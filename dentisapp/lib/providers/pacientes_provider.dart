import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/paciente.dart';
import '../repositories/paciente_repository.dart';
import '../services/paciente_local_service.dart';

final pacienteRepositoryProvider =
    Provider<PacienteRepository>(
  (ref) => PacienteRepository(),
);

final pacienteLocalServiceProvider =
    Provider<PacienteLocalService>(
  (ref) => PacienteLocalService(),
);

final pacientesProvider =
    AsyncNotifierProvider<PacientesNotifier, List<Paciente>>(
  PacientesNotifier.new,
);

final pacientesOfflineProvider =
    StateProvider<bool>((ref) => false);

final pacientesCacheTimestampProvider =
    StateProvider<DateTime?>((ref) => null);

/// Contiene la ruta local de la fotografía de cada paciente.
/// La llave es la cédula del paciente.
final pacientesFotosProvider =
    StateProvider<Map<String, String?>>(
  (ref) => {},
);

class PacientesNotifier
    extends AsyncNotifier<List<Paciente>> {
  @override
  Future<List<Paciente>> build() async {
    final repository = ref.read(
      pacienteRepositoryProvider,
    );

    final resultado =
        await repository.obtenerPacientesConEstado();

    ref
        .read(pacientesOfflineProvider.notifier)
        .state = resultado.offline;

    ref
        .read(
          pacientesCacheTimestampProvider.notifier,
        )
        .state = resultado.cacheTimestamp;

    await _cargarFotografiasLocales();

    return resultado.pacientes;
  }

  /// Carga las rutas de las fotografías almacenadas
  /// exclusivamente en SQLite.
  Future<void> _cargarFotografiasLocales() async {
    final localService = ref.read(
      pacienteLocalServiceProvider,
    );

    final pacientesLocales =
        await localService.obtenerPacientesLocales();

    final fotos = <String, String?>{};

    for (final pacienteLocal in pacientesLocales) {
      fotos[pacienteLocal.cedula] =
          pacienteLocal.fotoPath;
    }

    ref
        .read(pacientesFotosProvider.notifier)
        .state = fotos;
  }

  Future<void> recargar() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(build);
  }
}