import 'package:flutter/material.dart';

import '../../models/paciente.dart';
import '../../services/paciente_api_service.dart';
import '../../widgets/async_state_view.dart';
import '../../widgets/custom_card.dart';
import '../../widgets/custom_search_bar.dart';
import 'nuevo_paciente_screen.dart';
import 'editar_paciente_screen.dart';

/// Pantalla principal para listar y manejar los pacientes del sistema.
class PacientesScreen extends StatefulWidget {
  const PacientesScreen({super.key});

  @override
  State<PacientesScreen> createState() => _PacientesScreenState();
}

class _PacientesScreenState extends State<PacientesScreen> {
  final PacienteApiService pacienteApiService = PacienteApiService();

  final TextEditingController buscarController =
      TextEditingController();

  List<Paciente> pacientes = [];

  bool cargando = true;

  String? error;

  @override
  void initState() {
    super.initState();

    buscarController.addListener(() {
      setState(() {});
    });

    cargarPacientes();
  }

  Future<void> cargarPacientes() async {
    setState(() {
      cargando = true;
      error = null;
    });

    try {
      final resultado =
          await pacienteApiService.obtenerPacientes();

      setState(() {
        pacientes = resultado;
        cargando = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        cargando = false;
      });
    }
  }

  List<Paciente> get pacientesFiltrados {
    final texto = buscarController.text.trim().toLowerCase();

    if (texto.isEmpty) {
      return pacientes;
    }

    return pacientes.where((paciente) {
      final nombre =
          '${paciente.nombres} ${paciente.apellidos}'.toLowerCase();

      final cedula =
          paciente.cedula.toLowerCase();

      final telefono =
          (paciente.telefono ?? '').toLowerCase();

      final correo =
          (paciente.correo ?? '').toLowerCase();

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pacientes'),
      ),

      body: Column(
        children: [
          CustomSearchBar(
            controller: buscarController,
            hint: 'Buscar paciente...',
          ),

          Expanded(
            child: AsyncStateView(
              isLoading: cargando,
              error: error != null
                  ? 'No se pudieron cargar los pacientes.\n\n$error'
                  : null,
              isEmpty: !cargando &&
                  error == null &&
                  pacientesFiltrados.isEmpty,
              onRetry: cargarPacientes,
              child: construirLista(),
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => NuevoPacienteScreen(),
            ),
          );

          cargarPacientes();
        },
        child: const Icon(Icons.add),
      ),
    );
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
      padding: const EdgeInsets.only(
        top: 8,
        bottom: 80,
      ),
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
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),

            subtitle: Text(
              'Cédula: ${paciente.cedula}\n'
              'Teléfono: ${paciente.telefono ?? ""}\n'
              'Correo: ${paciente.correo ?? ""}\n'
              'Dirección: ${paciente.direccion ?? ""}',
            ),

            trailing: const Icon(
              Icons.arrow_forward_ios,
            ),

            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditarPacienteScreen(
                    paciente: paciente,
                  ),
                ),
              );

              cargarPacientes();
            },
          ),
        );
      },
    );
  }
}