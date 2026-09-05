import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/paciente.dart';
import '../../providers/pacientes_provider.dart';
import '../../widgets/async_state_view.dart';
import '../../widgets/custom_card.dart';
import '../../widgets/custom_search_bar.dart';
import 'nuevo_paciente_screen.dart';
import 'editar_paciente_screen.dart';

/// Pantalla principal para listar y manejar los pacientes del sistema.
class PacientesScreen extends ConsumerStatefulWidget {
  const PacientesScreen({super.key});

  @override
  ConsumerState<PacientesScreen> createState() => _PacientesScreenState();
}

class _PacientesScreenState extends ConsumerState<PacientesScreen> {
  final TextEditingController buscarController = TextEditingController();

  @override
  void initState() {
    super.initState();

    buscarController.addListener(() {
      setState(() {});
    });
  }

  List<Paciente> get pacientesFiltrados {
    final texto = buscarController.text.trim().toLowerCase();
    final pacientes = ref.read(pacientesProvider).valueOrNull ?? [];

    if (texto.isEmpty) {
      return pacientes;
    }

    return pacientes.where((paciente) {
      final nombre = '${paciente.nombres} ${paciente.apellidos}'.toLowerCase();

      final cedula = paciente.cedula.toLowerCase();

      final telefono = (paciente.telefono ?? '').toLowerCase();

      final correo = (paciente.correo ?? '').toLowerCase();

      return nombre.contains(texto) ||
          cedula.contains(texto) ||
          telefono.contains(texto) ||
          correo.contains(texto);
    }).toList();
  }

  @override
  void dispose() {
    buscarController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pacientesState = ref.watch(pacientesProvider);
    final cacheTimestamp = ref.watch(pacientesCacheTimestampProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Pacientes')),

      body: Column(
        children: [
          CustomSearchBar(
            controller: buscarController,
            hint: 'Buscar paciente...',
          ),
          if (cacheTimestamp != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                'Sin conexión. Datos guardados hace '
                '${_formatAge(cacheTimestamp)}.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),

          Expanded(
            child: AsyncStateView(
              isLoading: pacientesState.isLoading,
              error: pacientesState.hasError
                  ? 'No se pudieron cargar los pacientes.\n\n'
                        '${pacientesState.error}'
                  : null,
              isEmpty:
                  !pacientesState.isLoading &&
                  !pacientesState.hasError &&
                  pacientesFiltrados.isEmpty,
              onRetry: () => ref.read(pacientesProvider.notifier).recargar(),
              child: construirLista(),
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => NuevoPacienteScreen()),
          );

          ref.read(pacientesProvider.notifier).recargar();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  String _formatAge(DateTime timestamp) {
    final age = DateTime.now().difference(timestamp);
    if (age.inMinutes < 1) return 'menos de un minuto';
    if (age.inHours < 1) return '${age.inMinutes} minutos';
    if (age.inDays < 1) return '${age.inHours} horas';
    return '${age.inDays} días';
  }

  Widget construirLista() {
    final lista = pacientesFiltrados;

    if (lista.isEmpty) {
      return const Center(
        child: Text(
          'No se encontraron pacientes.',
          textAlign: TextAlign.center,
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 80),
      itemCount: lista.length,
      itemBuilder: (context, index) {
        final paciente = lista[index];

        return CustomCard(
          child: ListTile(
            leading: CircleAvatar(
              child: Text(
                paciente.nombres.isNotEmpty
                    ? paciente.nombres[0].toUpperCase()
                    : '?',
              ),
            ),

            title: Text(
              '${paciente.nombres} ${paciente.apellidos}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),

            subtitle: Text(
              'Cédula: ${paciente.cedula}\n'
              'Teléfono: ${paciente.telefono ?? ""}\n'
              'Correo: ${paciente.correo ?? ""}\n'
              'Dirección: ${paciente.direccion ?? ""}',
            ),

            trailing: const Icon(Icons.arrow_forward_ios),

            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditarPacienteScreen(paciente: paciente),
                ),
              );

              ref.read(pacientesProvider.notifier).recargar();
            },
          ),
        );
      },
    );
  }
}
