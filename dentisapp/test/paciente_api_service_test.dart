import 'package:flutter_test/flutter_test.dart';
import 'package:dentisapp/services/paciente_api_service.dart';

void main() {
  group('PacienteApiService', () {
    test('debe devolver una lista vacía mientras no haya conexión a la API', () async {
      final service = PacienteApiService();
      final pacientes = await service.obtenerPacientes();

      expect(pacientes, isEmpty);
    });

    test('debe devolver null al buscar un paciente inexistente', () async {
      final service = PacienteApiService();
      final paciente = await service.obtenerPacientePorId(999);

      expect(paciente, isNull);
    });
  });
}
