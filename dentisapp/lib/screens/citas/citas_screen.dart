import 'package:flutter/material.dart';

import '../../widgets/async_state_view.dart';
import '../../widgets/custom_card.dart';
import '../../widgets/custom_search_bar.dart';
import 'editar_cita_screen.dart';
import 'nueva_cita_screen.dart';

class CitasScreen extends StatefulWidget {
  const CitasScreen({super.key});

  @override
  State<CitasScreen> createState() => _CitasScreenState();
}

class _CitasScreenState extends State<CitasScreen> {
  final TextEditingController searchController =
      TextEditingController();

  final List<Map<String, dynamic>> citas = [
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

  @override
  void initState() {
    super.initState();

    searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get citasFiltradas {
    final texto =
        searchController.text.trim().toLowerCase();

    if (texto.isEmpty) {
      return citas;
    }

    return citas.where((cita) {
      final paciente =
          cita['paciente'].toString().toLowerCase();

      final odontologo =
          cita['odontologo'].toString().toLowerCase();

      final estado =
          cita['estado'].toString().toLowerCase();

      final fecha =
          cita['fecha'].toString().toLowerCase();

      return paciente.contains(texto) ||
          odontologo.contains(texto) ||
          estado.contains(texto) ||
          fecha.contains(texto);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final lista = citasFiltradas;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Citas'),
      ),

      body: Column(
        children: [
          CustomSearchBar(
            controller: searchController,
            hint: 'Buscar cita por paciente u odontólogo...',
          ),

          Expanded(
            child: AsyncStateView(
              isLoading: false,
              error: null,
              isEmpty: lista.isEmpty,
              onRetry: () {
                setState(() {});
              },
              child: ListView.builder(
                padding: const EdgeInsets.only(
                  top: 8,
                  bottom: 80,
                ),
                itemCount: lista.length,
                itemBuilder: (context, index) {
                  final cita = lista[index];

                  return CustomCard(
                    child: ListTile(
                      leading: const CircleAvatar(
                        child: Icon(
                          Icons.calendar_today,
                        ),
                      ),

                      title: Text(
                        cita['paciente'].toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
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

                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditarCitaScreen(
                              cita: cita,
                            ),
                          ),
                        );

                        setState(() {});
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
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const NuevaCitaScreen(),
            ),
          );

          setState(() {});
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}