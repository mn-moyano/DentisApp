import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/paciente.dart';
import '../services/api_client.dart';
import '../services/paciente_local_service.dart';
import '../services/paciente_api_service.dart';

final pacienteApiServiceProvider = Provider<PacienteApiService>(
  (ref) => PacienteApiService(),
);

final pacientesProvider =
    AsyncNotifierProvider<PacientesNotifier, List<Paciente>>(
      PacientesNotifier.new,
    );

final pacientesCacheTimestampProvider = StateProvider<DateTime?>((ref) => null);

class PacientesNotifier extends AsyncNotifier<List<Paciente>> {
  final PacienteLocalService _localService = PacienteLocalService();

  @override
  Future<List<Paciente>> build() async {
    try {
      final pacientes = await ref
          .read(pacienteApiServiceProvider)
          .obtenerPacientes();
      await _localService.guardarDesdeServidor(pacientes);
      ref.read(pacientesCacheTimestampProvider.notifier).state = null;
      return pacientes;
    } on ApiException catch (error) {
      if (error.statusCode != 0 && error.statusCode != 408) {
        rethrow;
      }

      final locales = await _localService.obtenerPacientesLocales();
      final timestamp = await _localService.obtenerUltimaActualizacion();
      ref.read(pacientesCacheTimestampProvider.notifier).state = timestamp;
      return locales.map((paciente) => paciente.toPaciente()).toList();
    }
  }

  Future<void> recargar() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(build);
  }
}
