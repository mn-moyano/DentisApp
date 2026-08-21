import 'package:flutter/material.dart';
import 'nueva_cita_screen.dart';
import 'editar_cita_screen.dart';
import '../../widgets/custom_search_bar.dart';
import '../../widgets/custom_card.dart';
import '../../widgets/async_state_view.dart';

class CitasScreen extends StatelessWidget {
  const CitasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Controlador obligatorio para el CustomSearchBar
    final searchController = TextEditingController();

    // Datos simulados (próximamente vendrán de la API)
    final citas = [
      {
        'id_cita': 1,
        'fecha': '20/07/2026 09:00',
        'estado': 'Programada',
        'id_paciente': 1,
        'paciente': 'Juan Pérez',
        'id_odontologo': 1,
        'odontologo': 'Andrés Morales',
      },
      {
        'id_cita': 2,
        'fecha': '20/07/2026 11:00',
        'estado': 'Atendida',
        'id_paciente': 2,
        'paciente': 'María Gómez',
        'id_odontologo': 2,
        'odontologo': 'Paola Vera',
      },
      {
        'id_cita': 3,
        'fecha': '21/07/2026 15:30',
        'estado': 'Cancelada',
        'id_paciente': 3,
        'paciente': 'Carlos Rodríguez',
        'id_odontologo': 1,
        'odontologo': 'Andrés Morales',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Citas'),
      ),
      body: Column(
        children: [
          CustomSearchBar(
            controller: searchController,
            hint: 'Buscar cita por paciente u odontólogo...',
            onChanged: (value) {
              // Lógica de filtrado futura
            },
          ),
          Expanded(
            child: AsyncStateView(
              isLoading: false, 
              error: null, // Se cambia a un String cuando haya un error de la API
              isEmpty: citas.isEmpty,
              onRetry: () {
                // Lógica para recargar
              },
              child: ListView.builder(
                itemCount: citas.length,
                itemBuilder: (context, index) {
                  final cita = citas[index];

                  // CustomCard ahora recibe el ListTile como su 'child'
                  return CustomCard(
                    child: ListTile(
                      leading: const CircleAvatar(
                        child: Icon(Icons.calendar_today),
                      ),
                      title: Text(
                        cita['paciente'].toString(),
                      ),
                      subtitle: Text(
                        'Fecha: ${cita['fecha']}\n'
                        'Odontólogo: ${cita['odontologo']}\n'
                        'Estado: ${cita['estado']}',
                      ),
                      isThreeLine: true,
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditarCitaScreen(
                              cita: cita,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NuevaCitaScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}