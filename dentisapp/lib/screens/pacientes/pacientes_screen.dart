import 'package:flutter/material.dart';

import '../../models/paciente.dart';
import '../../services/paciente_api_service.dart';
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
            child: construirContenido(),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),

        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => NuevoPacienteScreen(),
            ),
          );

          cargarPacientes();
        },
      ),
    );
  }

  Widget construirContenido() {
    if (cargando) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 50,
              ),

              const SizedBox(height: 16),

              const Text(
                'No se pudieron cargar los pacientes.',
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 10),

              Text(
                error!,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: cargarPacientes,
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    if (pacientes.isEmpty) {
      return const Center(
        child: Text(
          'No hay pacientes registrados.',
        ),
      );
    }

    return ListView.builder(
      itemCount: pacientes.length,

      itemBuilder: (context, index) {
        final paciente = pacientes[index];

        return CustomCard(
          child: ListTile(
            leading: CircleAvatar(
              child: Text(
                paciente.nombres.isNotEmpty
                    ? paciente.nombres[0]
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