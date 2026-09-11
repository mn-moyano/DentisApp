import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/paciente.dart';
import '../repositories/paciente_repository.dart';

final pacienteRepositoryProvider =
    Provider<PacienteRepository>(
  (ref) => PacienteRepository(),
);

final pacientesProvider =
    AsyncNotifierProvider<PacientesNotifier, List<Paciente>>(
  PacientesNotifier.new,
);

final pacientesOfflineProvider =
    StateProvider<bool>((ref) => false);

final pacientesCacheTimestampProvider =
    StateProvider<DateTime?>((ref) => null);

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

    return resultado.pacientes;
  }

  Future<void> recargar() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(build);
  }
}