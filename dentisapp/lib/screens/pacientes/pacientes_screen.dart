import 'package:flutter/material.dart';

import '../../models/paciente.dart';
import '../../services/paciente_service.dart';
import '../../widgets/custom_card.dart';
import '../../widgets/custom_search_bar.dart';
import 'nuevo_paciente_screen.dart';
import 'editar_paciente_screen.dart';

class PacientesScreen extends StatelessWidget {
  PacientesScreen({super.key});

  final PacienteService pacienteService = PacienteService();
  final TextEditingController buscarController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final List<Paciente> pacientes = pacienteService.obtenerPacientes();

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
            child: ListView.builder(
              itemCount: pacientes.length,
              itemBuilder: (context, index) {

                final paciente = pacientes[index];

                return CustomCard(
                  child: ListTile(

                    leading: CircleAvatar(
                      child: Text(
                        paciente.nombre[0],
                      ),
                    ),

                    title: Text(
                      '${paciente.nombre} ${paciente.apellido}',
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

                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditarPacienteScreen(
                            paciente: paciente,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),

        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => NuevoPacienteScreen(),
            ),
          );
        },
      ),
    );
  }
}